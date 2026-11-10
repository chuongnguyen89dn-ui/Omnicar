#!/usr/bin/env python3
"""Deterministic unit tests for analyze_hl8_unified_log.py (no device needed)."""
import pathlib
import tempfile
import unittest

from analyze_hl8_unified_log import analyze, read_records


class HL8ReaderTests(unittest.TestCase):
    def report(self, lines, car_pid=None):
        with tempfile.TemporaryDirectory() as temp:
            p = pathlib.Path(temp) / "OmniCar.log"
            p.write_text("\n".join(lines) + "\n", encoding="utf-8")
            return analyze(read_records([p]), car_pid)

    @staticmethod
    def row(at, process, pid, fields):
        tag = "SplitScreen" if process == "CarPlay" else "AppBridge"
        return (f"2026-11-10 12:{at} [{process}:{pid}] {tag}: "
                f"[hl8diag] {fields}")

    def test_no_coverage_is_blind(self):
        data = self.report(["legacy log without any hl8 marker"])
        self.assertEqual(data["verdict"], "NO_HL8_CAR_MARKERS")

    def test_actual_fullscreen_request_and_callback(self):
        lines = [
            self.row("23:01.000", "CarPlay", 401,
                     "eye=car ev=installed schema=1"),
            self.row("23:02.000", "CarPlay", 401,
                     "eye=pinch ev=formed pair=1"),
            self.row("23:02.020", "CarPlay", 401,
                     "eye=pinch ev=fs-gate pair=1 adapter=SCP state=0"),
            self.row("23:02.025", "CarPlay", 401,
                     "eye=pinch ev=fs-request pair=1 dir=expand"),
            self.row("23:02.070", "CarPlay", 401,
                     "eye=pinch ev=fs-result pair=1 applied=1"),
        ]
        d = self.report(lines)
        self.assertEqual(d["pinch"]["pairs"], 1)
        self.assertEqual(d["pinch"]["requests"], 1)
        self.assertEqual(d["pinch"]["applied"], 1)
        self.assertIn("SOURCE_APPLIED", d["pinch"]["verdict"])

    def test_gate_is_not_counted_as_request(self):
        lines = [
            self.row("23:01.000", "CarPlay", 401,
                     "eye=car ev=installed schema=1"),
            self.row("23:02.000", "CarPlay", 401,
                     "eye=pinch ev=formed pair=4"),
            self.row("23:02.001", "CarPlay", 401,
                     "eye=pinch ev=fs-gate pair=4 adapter=nil state=0"),
        ]
        d = self.report(lines)
        self.assertEqual(d["pinch"]["fs_gate"], 1)
        self.assertEqual(d["pinch"]["requests"], 0)
        self.assertEqual(d["pinch"]["verdict"],
                         "PAIR_FORMED_FS_GATE_EVALUATED_NO_REQUEST")
        self.assertEqual(d["pinch"]["gate_states"], {"0": 1})

    def test_pair_without_gate_does_not_claim_gate_failure(self):
        lines = [
            self.row("23:01.000", "CarPlay", 401,
                     "eye=car ev=installed schema=1"),
            self.row("23:02.000", "CarPlay", 401,
                     "eye=pinch ev=formed pair=1"),
            self.row("23:02.020", "CarPlay", 401,
                     "eye=pinch ev=drop pair=1 reason=popup-or-divider"),
        ]
        d = self.report(lines)
        self.assertEqual(d["pinch"]["fs_gate"], 0)
        self.assertEqual(d["pinch"]["requests"], 0)
        self.assertEqual(d["pinch"]["drop_reasons"],
                         {"popup-or-divider": 1})
        self.assertEqual(d["pinch"]["verdict"],
                         "PAIR_FORMED_NO_FS_GATE_EVALUATION")

    def test_native_wake_reason_is_exposed(self):
        lines = [
            self.row("23:01.000", "CarPlay", 401,
                     "eye=car ev=installed schema=1"),
            self.row("23:02.000", "CarPlay", 401,
                     "eye=native-wake ev=gate decision=forward "
                     "reason=controls-visible"),
            self.row("23:03.000", "CarPlay", 401,
                     "eye=native-wake ev=gate decision=consume "
                     "reason=first-tap-while-faded"),
        ]
        d = self.report(lines)
        self.assertEqual(d["native_wake"]["forward_reasons"],
                         {"controls-visible": 1})
        self.assertEqual(d["native_wake"]["consume_reasons"],
                         {"first-tap-while-faded": 1})

    def test_carplay_incarnations_not_merged(self):
        lines = [
            self.row("21:01.000", "CarPlay", 111, "eye=car ev=installed"),
            self.row("21:02.000", "CarPlay", 111,
                     "eye=pinch ev=formed pair=1"),
            self.row("24:01.000", "CarPlay", 222, "eye=car ev=installed"),
            self.row("24:02.000", "CarPlay", 222,
                     "eye=pinch ev=formed pair=2"),
        ]
        newest = self.report(lines)
        self.assertEqual(newest["car_pid"], 222)
        self.assertEqual(newest["pinch"]["pairs"], 1)
        old = self.report(lines, car_pid=111)
        self.assertEqual(old["car_pid"], 111)
        self.assertEqual(old["pinch"]["pairs"], 1)

    def test_native_faded_forward_is_explicit_problem(self):
        lines = [
            self.row("23:01.000", "CarPlay", 401, "eye=car ev=installed"),
            self.row("23:04.000", "CarPlay", 401,
                     "eye=touch ev=begin id=10 kind=native faded=1"),
            self.row("23:04.002", "CarPlay", 401,
                     "eye=touch ev=dispatch id=10 path=forwarded-to-orig"),
        ]
        d = self.report(lines)
        self.assertEqual(d["native_wake"]["faded_native_forwarded"], 1)
        self.assertEqual(d["native_wake"]["verdict"],
                         "FADED_NATIVE_TOUCH_FORWARDED_TO_APP")

    def test_keyboard_native_gate_without_pixel_claim(self):
        lines = [
            self.row("23:01.000", "CarPlay", 401, "eye=car ev=installed"),
            self.row("23:04.000", "YouTube", 403,
                     "eye=kb-app ev=mode-recv requested=0"),
            self.row("23:04.100", "YouTube", 403,
                     "eye=kb-app ev=focus-became"),
            self.row("23:04.110", "YouTube", 403,
                     "eye=kb-app ev=publish-blocked reason=native-locked"),
        ]
        d = self.report(lines)
        self.assertEqual(d["keyboard"]["hosted_focus"], 1)
        self.assertEqual(d["keyboard"]["drawn_publish_blocked"], 1)
        self.assertFalse(d["keyboard"]["native_keyboard_pixel_proven"])

    def test_layout_sender_receiver_and_settled(self):
        lines = [
            self.row("23:01.000", "CarPlay", 401, "eye=car ev=installed"),
            self.row("23:04.000", "CarPlay", 401,
                     "eye=layout ev=frame-send seq=8 bundle=yt"),
            self.row("23:04.010", "SpringBoard", 402,
                     "eye=layout ev=frame-recv seq=8 bundle=yt"),
            self.row("23:04.025", "SpringBoard", 402,
                     "eye=layout ev=frame-applied seq=8 bundle=yt"),
            self.row("23:04.400", "SpringBoard", 402,
                     "eye=layout ev=frame-settled seq=8 sameOwner=1"),
        ]
        d = self.report(lines)
        self.assertEqual(d["layout"]["frame_send"], 1)
        self.assertEqual(d["layout"]["frame_receive"], 1)
        self.assertEqual(d["layout"]["frame_settled"], 1)
        self.assertEqual(d["layout"]["unmatched_sent_seqs_sample"], [])
        self.assertFalse(d["layout"]["native_keyboard_following_ratio_pixel_proven"])


if __name__ == "__main__":
    unittest.main()
