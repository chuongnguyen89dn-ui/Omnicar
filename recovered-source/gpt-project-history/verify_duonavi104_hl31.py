#!/usr/bin/env python3
"""HL31 read-only SHA-pinned original DuoNavi104 ObjC/ARM64 audit.
Uses existing first-party DuoFace parser. Never copies vendor code into DuoCar.
"""
import bisect,hashlib,json,os,re,sys
from pathlib import Path
PKG="f3f911de5db461d487ce91249aed1bb25d44f076e7ff5fb89e54b658569328dd"
DYLIB="44fdd4b4df0e3cc277ca69f71129da356f3bd8d6af70e0fde1ef36f266b66d15"
TARGETS={
"CBVoiceSessionManager":["toggleSession","startSession","stopOrFinishSpeech","voiceTriggerDidRequestStart","voiceTriggerDidRequestStop","audioCaptureDidOutputPCMChunk:","audioCaptureDidTranscribeText:isFinal:","audioCaptureDidFailWithError:","voiceTransportDidReceiveDirective:","voiceTransportDidFailWithError:","voiceTransportDidConnect","setState:","announceErrorAndReset","resetToIdle"],
"CBVoiceAudioCapture":["startRecording:","stopRecording","setMode:"],
"CBVoiceSTTAppleOnDeviceProvider":["startSessionWithInputFormat:error:","consumeAudioBuffer:","stopSession"],
"CBVoiceSTTCloudStreamingProvider":["startSessionWithInputFormat:error:","consumeAudioBuffer:","stopSession"],
"CBVoiceDirectiveDispatcher":["registerHandler:","handlerForDirective:","canDispatchDirective:","dispatchDirective:completion:"],
"CBVoiceSceneDispatcher":["dispatchAppWithBundleID:launchURL:targetSlot:completion:"],
"CBVoiceTransport":["connectWithContext:completion:","sendPCMChunk:","sendTurnEndWithText:","syncCarPlayContextOnce:"],
"CBAIBubbleView":["willMoveToWindow:","setupGestures","handleTap:","setActivated:animated:","setupCoreBubble","setupAuraPulse"],
"CBBridgedUIAppView":["calculateNativeSizeForSlotRect:","setAppScale:","updateLayout","refreshSceneLayout","updateSceneSettingsFrame"],
"CBBridgeManager":["renderSizeForBundleID:","supportsInterfaceOrientation:forBundleID:"],
"CBBridgedSplitApp":["layoutSplitViews"],
}
def sha(data): return hashlib.sha256(data).hexdigest()
def sanitize(s):
    s=re.sub(r"https?://\S+","<URL-REDACTED>",s)
    return re.sub(r"(?i)(bearer|apikey|api_key|secret|token)[=: ]+[^ ]{7,}",r"\1=<REDACTED>",s)[:260]
def main():
    if len(sys.argv)!=4: raise SystemExit("usage: script DEB DYLIB RESULT_JSON")
    deb,dylib,dest=map(Path,sys.argv[1:])
    assert sha(deb.read_bytes())==PKG,"WRONG_ORIGINAL_DEB_SHA"
    raw=dylib.read_bytes()
    assert sha(raw)==DYLIB,"WRONG_ORIGINAL_DYLIB_SHA"
    native=os.getenv("NATIVE_PARSER_DIR")
    assert native and Path(native).is_dir(),"NO_EXISTING_DUOFACE_PARSER"
    sys.path.insert(0,native)
    from audit_native12_license_class_xrefs import MachO,select_arm64
    from audit_native12_carplay_add_app_chain import methods,disassemble
    thin=select_arm64(raw); macho=MachO(thin)
    classes=macho.classes(); bycls={}; parse_errors={}; starts=set()
    for cls in classes:
        try:
            d=methods(macho,cls); bycls[cls]=d
            starts.update(int(v["vm"]) for v in d.values() if v.get("vm"))
        except (ValueError,KeyError,AssertionError,IndexError) as e:
            parse_errors[cls]=type(e).__name__
    starts=sorted(starts)
    report={"kind":"HL31_DUONAVI104_ORIGINAL_READONLY","deb_sha256":PKG,
        "dashboard_sha256":DYLIB,"thin_sha256":sha(thin),
        "classes":len(classes),"parsed_classes":len(bycls),
        "total_methods":sum(map(len,bycls.values())),
        "selector_inventory":{},"methods":[],"missing":[],"parser_errors":parse_errors,
        "limits":"static metadata only; no proof of PID, live touch or TCC owner"}
    for cls,items in sorted(bycls.items()):
        if cls.startswith(("CBVoice","CBAI","CBBridged","CBBridge")) or re.search("keyboard|keyplane|input",cls,re.I):
            report["selector_inventory"][cls]=[
                {"selector":k,"imp":hex(int(v["vm"]))}
                for k,v in items.items() if v.get("vm")]
    for cls,sels in TARGETS.items():
        d=bycls.get(cls)
        if not d: report["missing"].append("class:"+cls);continue
        for sel in sels:
            method=d.get("-"+sel) or d.get("+"+sel)
            if not method: report["missing"].append(cls+"."+sel);continue
            vm=int(method["vm"]);p=bisect.bisect_right(starts,vm)
            hi=starts[p] if p<len(starts) else vm+0x3000
            end=min(hi,vm+0x6000)
            if end<=vm: report["missing"].append("bound:"+cls+"."+sel);continue
            ins=disassemble(macho,vm,end)
            deep=cls.startswith(("CBVoice","CBAI","CBBridgedUIAppView"))
            report["methods"].append({"class":cls,"selector":sel,"imp":hex(vm),
                "next_imp":hex(hi),"bound":hex(end),"instruction_count":len(ins),
                "selector_refs":[sanitize(x) for x in ins if "SEL_OR_LITERAL" in x][:120],
                "bl_sites":[sanitize(x) for x in ins if re.search(r"\bbl\s+(?:#|0x)",x)][:110],
                "bounded_arm64_trace":[sanitize(x) for x in ins[:900 if deep else 120]],
                "trace_truncated":len(ins)>(900 if deep else 120),
                "not_runtime_proven":True})
    assert any(m["class"]=="CBVoiceSessionManager" for m in report["methods"])
    assert any(m["class"]=="CBBridgedUIAppView" for m in report["methods"])
    dest.parent.mkdir(parents=True,exist_ok=True)
    dest.write_text(json.dumps(report,ensure_ascii=False,indent=2)+"\n")
    report_text=["HL31_DUONAVI104_ORIGINAL_ARM64_AUDIT_OK",f"DEB_SHA256={PKG}",
        f"DYLIB_SHA256={DYLIB}",f"CLASSES={len(classes)}",f"METHODS={report['total_methods']}",
        f"FOCUSED={len(report['methods'])} MISSING={len(report['missing'])}"]
    report_text += [f"{m['class']} {m['selector']} {m['imp']} INS={m['instruction_count']} REFS={len(m['selector_refs'])}" for m in report["methods"]]
    dest.with_suffix(".txt").write_text("\n".join(report_text)+"\n")
    print("\n".join(report_text[:6]))
if __name__=="__main__": main()
