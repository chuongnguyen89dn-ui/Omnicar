#!/usr/bin/env python3
"""OmniCar HL8 unified diagnostics reader.

Reads OMCLogWrite's existing OmniCar.log files. Never mixes CarPlay PIDs,
never treats missing reader coverage as ABSENT, and never reads typed text.
Usage:
  python3 analyze_hl8_unified_log.py logs/OmniCar.log logs/OmniCar.log.old
  python3 analyze_hl8_unified_log.py --car-pid 42000 --json logs/OmniCar.log
"""
from __future__ import annotations

import argparse
import collections
import datetime as dt
import json
import pathlib
import re
import sys

LINE = re.compile(
    r"^(?P<time>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}(?:\.\d+)?) "
    r"\[(?P<process>[^:\]]+):(?P<pid>\d+)\].*?\[hl8diag\]\s+(?P<body>.*)$"
)
KEY = re.compile(r"(?:^|\s)([A-Za-z][A-Za-z0-9_-]*)=([^\s]+)")
FMT = "%Y-%m-%d %H:%M:%S.%f"


def parse_time(value: str) -> dt.datetime:
    if "." not in value:
        value += ".000"
    return dt.datetime.strptime(value, FMT)


def read_records(paths):
    seen = set()
    records = []
    for source in paths:
        with pathlib.Path(source).open("r", encoding="utf-8", errors="replace") as stream:
            for number, line in enumerate(stream, 1):
                if "[hl8diag]" not in line:
                    continue
                match = LINE.match(line.rstrip("\n"))
                if not match:
                    continue
                body = match.group("body")
                record = {
                    "at": match.group("time"),
                    "ts": parse_time(match.group("time")),
                    "process": match.group("process"),
                    "pid": int(match.group("pid")),
                    "source": str(source),
                    "line": number,
                    "body": body,
                    "fields": dict(KEY.findall(body)),
                }
                # The .log.old file can overlap the active log by a rotation.
                identity = (record["at"], record["process"], record["pid"], body)
                if identity in seen:
                    continue
                seen.add(identity)
                records.append(record)
    return sorted(records, key=lambda x: (x["ts"], x["pid"], x["line"]))


def get(r, key, default=None):
    return r["fields"].get(key, default)


def count(records, eye, event):
    return sum(get(r, "eye") == eye and get(r, "ev") == event for r in records)


def sample(records, eye, event, max_items=5):
    return [
        {"at": r["at"], "pid": r["pid"], "body": r["body"][:500]}
        for r in records
        if get(r, "eye") == eye and get(r, "ev") == event
    ][:max_items]


def analyze(all_records, target_pid=None):
    car = [r for r in all_records if r["process"] == "CarPlay"]
    car_pids = sorted({r["pid"] for r in car})
    if not car:
        return {"verdict": "NO_HL8_CAR_MARKERS", "car_pids": [],
                "note": "No instrumented CarPlayApp session in supplied files; "
                        "this is BLIND, not proof a feature did not run."}
    if target_pid is None:
        # Select latest instrumented CarPlay incarnation, not the most
        # frequent one and not a historical binary with a different PID.
        target_pid = max(car, key=lambda r: r["ts"])["pid"]
    chosen = [r for r in car if r["pid"] == target_pid]
    if not chosen:
        return {"verdict": "CAR_PID_NOT_PRESENT", "car_pids": car_pids,
                "requested_pid": target_pid}
    start, end = chosen[0]["ts"], chosen[-1]["ts"]
    # Include peers from this incarnation's temporal window. A separate
    # reader in another process can remain BLIND; do not manufacture a peer.
    earlier = start - dt.timedelta(seconds=30)
    later = end + dt.timedelta(seconds=30)
    rows = [r for r in all_records
            if (r["process"] == "CarPlay" and r["pid"] == target_pid)
            or (r["process"] != "CarPlay" and earlier <= r["ts"] <= later)]
    owner = [r for r in rows if r["process"] == "CarPlay"]
    peers = [r for r in rows if r["process"] != "CarPlay"]
    count_by_process = collections.Counter(
        f'{r["process"]}:{r["pid"]}' for r in rows
    )
    count_by_eye = collections.Counter(get(r, "eye", "unknown") for r in rows)

    formed = count(owner, "pinch", "formed")
    requested = sum(get(r, "eye") == "pinch" and
                    get(r, "ev") == "fs-gate" for r in owner)
    outcomes = [r for r in owner if get(r, "eye") == "pinch"
                and get(r, "ev") == "fs-result"]
    applied = sum(get(r, "applied") == "1" for r in outcomes)
    pair_rejects = [r for r in owner if get(r, "eye") == "pinch"
                    and get(r, "ev") == "drop"]
    if not formed:
        pinch = "NO_TWO_FINGER_PAIR_RECORDED"
    elif not requested:
        pinch = "PAIR_FORMED_BUT_FULLSCREEN_GATE_NOT_REACHED"
    elif not outcomes:
        pinch = "FULLSCREEN_REQUEST_WITHOUT_APPLIED_CALLBACK"
    elif not applied:
        pinch = "FULLSCREEN_CALLBACK_REJECTED_OR_NOT_APPLIED"
    else:
        pinch = "SOURCE_APPLIED__PIXEL_AND_DOCK_STILL_REQUIRE_CAR_TEST"

    beginnings = [r for r in owner if get(r, "eye") == "touch"
                  and get(r, "ev") == "begin"]
    dispatch = {
        get(r, "id"): r for r in owner
        if get(r, "eye") == "touch" and get(r, "ev") == "dispatch"
    }
    leaked = [r for r in beginnings
              if get(r, "kind") == "native" and get(r, "faded") == "1"
              and get(dispatch.get(get(r, "id"), {"fields": {}}), "path")
              == "forwarded-to-orig"]
    on_logo = [r for r in beginnings
               if get(r, "inLogo") == "1" and get(r, "faded") == "0"]
    logo_callbacks = count(owner, "logo", "callback")
    if leaked:
        native_wake = "FADED_NATIVE_TOUCH_FORWARDED_TO_APP"
    elif any(get(r, "decision") == "consume" for r in owner
             if get(r, "eye") == "native-wake"):
        native_wake = "CARPLAY_TOUCH_CONSUMED__VERIFY_NATIVE_SCENE_PIXEL"
    elif beginnings:
        native_wake = "NO_ACCEPTED_NATIVE_WAKE_IN_OBSERVED_TOUCHES"
    else:
        native_wake = "NO_TOUCH_BEGIN_COVERAGE__BLIND"
    if on_logo and not logo_callbacks:
        logo = "VISIBLE_LOGO_REGION_TOUCHED_BUT_NO_BUTTON_CALLBACK"
    elif logo_callbacks:
        logo = "LOGO_CALLBACK_OBSERVED__VERIFY_PANEL_PRESENTATION"
    else:
        logo = "NO_VISIBLE_LOGO_TEST_RECORDED__BLIND"

    focus = count(peers, "kb-app", "focus-became")
    blocked = count(peers, "kb-app", "publish-blocked")
    mode = count(peers, "kb-app", "mode-recv")
    spring_keyboard = count(peers, "kb-spring", "notification")
    car_keyboard = count(owner, "kb-car", "notification")
    if focus and blocked:
        keyboard = "HOSTED_FOCUS_EXISTS__DRAWN_PATH_BLOCKED_BY_NATIVE_LOCK"
    elif focus:
        keyboard = "HOSTED_FOCUS_EXISTS__FOLLOW_MODE_AND_NOTIFY_EYES"
    elif mode:
        keyboard = "MODE_ARRIVED_BUT_NO_FOCUS_EVENT_IN_WINDOW"
    else:
        keyboard = "NO_HOSTED_KEYBOARD_READER_COVERAGE__BLIND"

    sent = [r for r in owner if get(r, "eye") == "layout"
            and get(r, "ev") == "frame-send"]
    received = [r for r in peers if get(r, "eye") == "layout"
                and get(r, "ev") == "frame-recv"]
    settled = [r for r in peers if get(r, "eye") == "layout"
               and get(r, "ev") == "frame-settled"]
    rx_ids = {get(r, "seq") for r in received}
    missing_rx_ids = sorted({get(r, "seq") for r in sent
                             if get(r, "seq") not in rx_ids})
    stale = sum(get(r, "sameOwner") == "0" for r in settled)
    if not sent:
        geometry = "NO_HOSTED_FRAME_CHANGES_OBSERVED"
    elif not received:
        geometry = "SENDER_LOG_PRESENT_BUT_RECEIVER_EYE_BLIND_OR_INACTIVE"
    elif stale:
        geometry = "SOME_HOST_FRAMES_SETTLED_ON_DIFFERENT_OWNER"
    elif not settled:
        geometry = "HOST_RECEIVED_FRAMES_BUT_NO_SETTLED_READBACK"
    else:
        geometry = "HOSTED_FRAME_PIPELINE_RECORDED__CHECK_EXPECTED_VS_ACTUAL"

    result = {
        "schema": "omnicar-hl8diag-v1",
        "verdict": "DATA_READY__DEVICE_PIXEL_CONFIRMATION_SEPARATE",
        "car_pid": target_pid,
        "car_pids_seen": car_pids,
        "window": [chosen[0]["at"], chosen[-1]["at"]],
        "processes": dict(sorted(count_by_process.items())),
        "eyes": dict(sorted(count_by_eye.items())),
        "pinch": {"verdict": pinch, "pairs": formed,
                  "fs_gate": requested, "fs_callback": len(outcomes),
                  "applied": applied, "drops": len(pair_rejects),
                  "gate_examples": sample(owner, "pinch", "fs-gate")},
        "native_wake": {"verdict": native_wake,
                        "faded_native_forwarded": len(leaked),
                        "consumed": sum(get(r, "eye") == "native-wake"
                                        and get(r, "decision") == "consume"
                                        for r in owner),
                        "examples": sample(owner, "native-wake", "gate")},
        "logo": {"verdict": logo, "visible_region_touches": len(on_logo),
                 "callbacks": logo_callbacks,
                 "actions": count(owner, "logo", "action")},
        "keyboard": {"verdict": keyboard, "hosted_focus": focus,
                     "hosted_mode_received": mode,
                     "drawn_publish_blocked": blocked,
                     "spring_notification": spring_keyboard,
                     "carplay_notification": car_keyboard,
                     "native_keyboard_pixel_proven": False},
        "layout": {"verdict": geometry,
                   "car_relayout": count(owner, "layout", "car-relayout"),
                   "frame_send": len(sent), "frame_receive": len(received),
                   "frame_settled": len(settled),
                   "stale_owner": stale,
                   "unmatched_sent_seqs_sample": missing_rx_ids[:10],
                   "native_keyboard_following_ratio_pixel_proven": False},
        "limitations": [
            "Same OMC log stream, but multiple processes; always compare PID/time.",
            "A missing marker from an external reader is BLIND, not ABSENT.",
            "CarPlayTemplateUIHost/system keyboard pixels cannot be established "
            "from SpringBoard or CarPlayApp window enumeration alone.",
            "FS source callback and CGRect readback are not visual proof.",
            "No typed text, key contents, or private app data were collected.",
        ]
    }
    return result


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("logs", nargs="+", help="OmniCar.log and optionally .old")
    parser.add_argument("--car-pid", type=int, help="Select exact CarPlay PID")
    parser.add_argument("--json", action="store_true", help="Machine-readable report")
    args = parser.parse_args(argv)
    try:
        data = analyze(read_records(args.logs), args.car_pid)
    except OSError as ex:
        parser.error(str(ex))
    if args.json:
        print(json.dumps(data, indent=2, ensure_ascii=False))
    else:
        print("OMNICAR HL8 UNIFIED LOG —", data["verdict"])
        if "car_pid" in data:
            print("CarPlay PID", data["car_pid"], "window", " .. ".join(data["window"]))
            print("Readers:", ", ".join(data["processes"]))
            for eye in ("pinch", "native_wake", "logo", "keyboard", "layout"):
                print(eye.upper() + ":", data[eye]["verdict"])
                for k, v in data[eye].items():
                    if k not in ("verdict", "examples", "gate_examples"):
                        print(" ", k + ":", v)
            print("LIMIT: external keyboard pixels and Home view visibility "
                  "still need a short car video; missing source logs are BLIND.")
        else:
            print(data["note"] if "note" in data else data)
    return 0


if __name__ == "__main__":
    sys.exit(main())
