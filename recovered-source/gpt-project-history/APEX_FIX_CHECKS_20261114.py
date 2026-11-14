#!/usr/bin/env python3
# Kiem tinh APEX — nham dung cac lop loi GPT da chi (6875732000, 6875837461).
# Day la kiem tinh tren source, KHONG phai bang chung build/device.
# Chay tu thu muc recovered-source/:  python3 gpt-project-history/APEX_FIX_CHECKS_20261114.py
import filecmp, sys
S = open('project/OmniCarApp/OMCNativeSettings.m').read()
ok = []
def chk(name, cond): ok.append((name, bool(cond)))
dash = S[S.index('@implementation OMCNativeDashboardPage'):S.index('UIViewController *OMCNativeSettingsRootController')]
# 4 loi cu — giu khong tai pham
chk("Dashboard khong con initWithKind:2 cho startup", 'initWithKind:2' not in dash)
chk("Dashboard dung OMCNativeStartupController()", 'OMCNativeStartupController()' in dash)
chk("Nhan app ghim refresh o viewWillAppear", 'layoutPreviewLabel.text=[self omcPinnedCaptionText]' in S)
chk("Dashboard co preview + nhan Minh hoa", 'omcInstallSplitPreview' in dash and 'Minh họa' in dash)
for f in ['project/OmniCarSplitScreen/SCPCarSplit+Chrome.m','project/OmniCarAppBridge/ABHostBMethods.m','project/OmniCarAppBridge/ABKeyboard.m']:
    t = open(f).read()
    chk(f"{f.split('/')[-1]}: cap Create/Release CGColorSpace", t.count('CGColorSpaceCreateDeviceRGB') == t.count('CGColorSpaceRelease(cs)') == 1)
# Loi locale moi (6875837461)
vw = dash[dash.index('- (void)viewWillAppear'):]
chk("Dashboard viewWillAppear dat lai title theo OMCText", 'self.title=OMCText(@"Bảng điều khiển",@"Dashboard");' in vw)
chk("Dashboard viewWillAppear lam moi nhan xem truoc", 'previewTitleLabel.text=OMCText(@"Xem trước chia màn",@"Split preview");' in vw)
chk("Dashboard viewWillAppear lam moi chip Minh hoa", 'previewChipLabel.text=OMCText(@"Minh họa",@"Illustration");' in vw)
chk("Hai nhan preview duoc giu tham chieu", 'self.previewTitleLabel=t;' in dash and 'self.previewChipLabel=chip;' in dash)
cl = S[S.index('- (void)chooseLanguage'):]
cl = cl[:cl.index('- (void)confirmRescue')]
chk("chooseLanguage goi refreshMasterCard ngay sau khi doi", '[self refreshMasterCard];' in cl)
# Guong
for a,b in [('project/OmniCarApp/OMCNativeSettings.m','src/App/OMCNativeSettings.m'),
            ('project/OmniCarSplitScreen/SCPCarSplit+Chrome.m','src/SplitScreenA/SCPCarSplit+Chrome.m'),
            ('project/OmniCarAppBridge/ABHostBMethods.m','src/AppBridgeB/ABHostBMethods.m'),
            ('project/OmniCarAppBridge/ABKeyboard.m','src/AppBridgeB/ABKeyboard.m')]:
    chk(f"guong khop {b}", filecmp.cmp(a,b,shallow=False))
bad = [n for n,c in ok if not c]
for n,c in ok: print(('PASS' if c else 'FAIL'), '-', n)
print(f"\nTONG: {len(ok)-len(bad)}/{len(ok)} PASS")
sys.exit(1 if bad else 0)
