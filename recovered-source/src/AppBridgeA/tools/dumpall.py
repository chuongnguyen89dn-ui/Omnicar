import sys, os, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from abdis import *

os.makedirs(os.path.expanduser("~/workspace/omnicar-re/src/AppBridgeA/disasm"), exist_ok=True)
summary = {}
for start in FUNC_STARTS:
    end = FUNC_END[start]
    name = LABELS.get(start, f"sub_{start:x}")
    safe = re.sub(r'[^A-Za-z0-9_.-]', '_', name)
    outp = os.path.expanduser(f"~/workspace/omnicar-re/src/AppBridgeA/disasm/{start:06x}_{safe}.s")
    txt, refs = disasm_func(start, end, outp)
    summary[hex(start)] = {"name": name, "size": end-start,
        "calls": sorted(set(refs["calls"])), "strings": sorted(set(refs["strings"])),
        "sels": sorted(set(refs["sels"])), "classes": sorted(set(refs["classes"]))}
json.dump(summary, open(os.path.expanduser("~/workspace/omnicar-re/src/AppBridgeA/disasm/summary.json"), "w"), indent=1)
print("dumped", len(summary))
# interesting queries
def who(key, field="calls"):
    return [(a, v["name"]) for a, v in summary.items() if any(key in c for c in v[field])]
for probe in ["MSHookMessageEx", "MSHookFunction", "notify_register_dispatch", "notify_post",
              "notify_set_state", "notify_get_state", "CFPreferencesCopyAppValue",
              "CFPreferencesSetAppValue", "dlopen", "objc_getClass", "NSClassFromString",
              "class_addMethod", "imp_implementationWithBlock"]:
    print(probe, "->", who(probe))
