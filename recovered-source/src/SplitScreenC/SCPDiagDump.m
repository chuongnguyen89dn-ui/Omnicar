// SCPDiagDump.m — SplitScreen-C: the one-shot library/class diagnostic
// dump (SCPDumpAppLibraryOnce and its formatters).
//
// Purely diagnostic: the first time SplitScreen-A's restore path asks for
// it, this walks the shared application library, the first app info and
// its CarPlay declaration, dumps the runtime layout (classes, methods,
// ivars) of the seven dashboard-related classes it depends on, and walks
// the connected scenes. It changes no state besides its once-guard byte.

#import "SCPHomeCommon.h"

NS_ASSUME_NONNULL_BEGIN

// 0xd6ec — VERIFIED: "name(type)" ivar list of a class, joined with " ".
static NSString *SCPDiagIvarList(Class cls) {
    NSMutableArray<NSString *> *parts = [NSMutableArray array];
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(cls, &count);
    for (unsigned int i = 0; i < count; i++) {
        const char *name = ivar_getName(ivars[i]);
        const char *type = ivar_getTypeEncoding(ivars[i]);
        [parts addObject:[NSString stringWithFormat:@"%s(%s)",
                          name ?: "?", type ?: "?"]];
    }
    free(ivars);
    return [parts componentsJoinedByString:@" "];
}

// 0xd830 — VERIFIED: sorted method-name list of a class, joined with " ".
static NSString *SCPDiagMethodList(Class cls, BOOL classMethods) {
    NSMutableArray<NSString *> *parts = [NSMutableArray array];
    unsigned int count = 0;
    Method *methods = class_copyMethodList(classMethods ? object_getClass(cls) : cls,
                                           &count);
    for (unsigned int i = 0; i < count; i++)
        [parts addObject:NSStringFromSelector(method_getName(methods[i]))];
    free(methods);
    return [[parts sortedArrayUsingSelector:@selector(compare:)]
        componentsJoinedByString:@" "];
}

// 0xcfa4 — VERIFIED structure: log a class, its superclass chain, methods
// and ivars ("DIAG %@ (lop cha %@): ivars %@ | -%@" style lines).
static void SCPDiagDumpClass(NSString *label, Class cls) {
    if (!cls) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"DIAG %@: khong co lop", label]);
        return;
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"DIAG %@: %@ | ivars: %@", label, cls, SCPDiagIvarList(cls)]);
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"DIAG %@: -%@", label, SCPDiagMethodList(cls, NO)]);
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"DIAG %@: +%@", label, SCPDiagMethodList(cls, YES)]);
    Class sup = class_getSuperclass(cls);
    if (sup) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"DIAG %@ (lop cha %@): ivars %@ | -%@", label, sup,
            SCPDiagIvarList(sup), SCPDiagMethodList(sup, NO)]);
    }
}

// 0xcde0 — VERIFIED: describe one object and dump its class layout.
static void SCPDiagDescribe(NSString *label, id _Nullable obj) {
    if (!obj) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"DIAG %@: nil", label]);
        return;
    }
    NSString *desc;
    @try { desc = [obj description]; }
    @catch (NSException *e) { desc = @"(description loi)"; }
    // 0xce50: descriptions of 1501+ chars are truncated to 1500 before
    // logging (cmp x0, #0x5dd; b.lo skip; mov w2, #0x5dc;
    // substringToIndex:) — limit decoded by verifier #5.
    if (desc.length > 1500) desc = [desc substringToIndex:1500];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"DIAG %@ description: %@", label, desc]);
    SCPDiagDumpClass(label, [obj class]);
}

// 0xd324 — VERIFIED (final closure — line-read end to end, dump
// src/SplitScreenC/disasm/sub_d324.txt; the old body was a
// STUB-UNRECOVERED placeholder with the wrong signature — the binary
// function RETURNS the found icon). Depth-capped (14) DFS for the first
// icon: a node whose class name ends in "IconListView" resolves its
// icons through model -> folder -> lists (when lists is a non-empty
// NSArray, the icons of its first object), else through the model's own
// "icons", and yields the first icon when that is a non-empty NSArray;
// any other node — and an IconListView whose icons do not resolve —
// recurses into its subviews.
static id SCPDiagWalkIcons(id node, NSInteger depth) {
    if (!node || depth > 14) return nil;
    if ([NSStringFromClass([node class]) hasSuffix:@"IconListView"]) {
        id model = SCPHomeSafeGet(node, @"model");
        id folder = SCPHomeSafeGet(model, @"folder");
        id lists = SCPHomeSafeGet(folder, @"lists");
        id icons = nil;
        if ([lists isKindOfClass:[NSArray class]] && [lists count] > 0)
            icons = SCPHomeSafeGet([lists firstObject], @"icons");
        else
            icons = SCPHomeSafeGet(model, @"icons");
        if ([icons isKindOfClass:[NSArray class]] && [icons count] > 0) {
            SCPDiagDescribe(@"icon list view", node);
            SCPDiagDescribe(@"icon model", model);
            return [icons firstObject];
        }
    }
    for (id subview in [node subviews]) {
        id found = SCPDiagWalkIcons(subview, depth + 1);
        if (found) return found;
    }
    return nil;
}

// 0xc624 (_SCPDumpAppLibraryOnce) — VERIFIED at call-sequence level
// (once-guard byte 0x880100).
void SCPDumpAppLibraryOnce(void) {
    static BOOL done; // 0x880100
    if (done) return;
    done = YES;
    id library = SCPHomeSafeGet([UIApplication sharedApplication],
                                @"sharedApplicationLibrary");
    SCPDiagDescribe(@"thu vien app (sharedApplicationLibrary)", library);
    SCPDiagDescribe(@"cau hinh thu vien",
                    SCPHomeSafeKVCGet(library, @"_configuration"));
    NSArray *all = SCPHomeSafeGet(library, @"allInstalledApplications");
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"DIAG allInstalledApplications: %lu muc", (unsigned long)all.count]);
    id first = all.firstObject;
    SCPDiagDescribe(@"app info", first);
    SCPDiagDescribe(@"declaration", SCPHomeSafeGet(first, @"carPlayDeclaration"));
    // Constant class list at 0x80368 — VERIFIED contents.
    for (NSString *name in @[@"DashBoard", @"DBDashboardHomeViewController",
                             @"DBIconModel", @"DBIconView", @"DBApplicationIcon",
                             @"SBApplicationIcon",
                             @"FBSApplicationLibraryConfiguration"]) {
        Class cls = objc_getClass(name.UTF8String);
        if (cls) SCPDiagDumpClass([@"lop " stringByAppendingString:name], cls);
        else OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"DIAG lop %@: khong co", name]);
    }
    // Tail VERIFIED (final closure): the icon hunt walks WINDOWS, not
    // scenes — connectedScenes, skipping non-UIWindowScene scenes, then
    // each scene's windows in order; the first window whose tree yields
    // an icon stops both loops. (The old tail looped the walker over the
    // scenes themselves and discarded the result.)
    id icon = nil;
    UIApplication *app = [UIApplication sharedApplication];
    for (UIScene *scene in app.connectedScenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) continue;
        for (UIWindow *window in [(UIWindowScene *)scene windows]) {
            icon = SCPDiagWalkIcons(window, 0);
            if (icon) break;
        }
        if (icon) break;
    }
    SCPDiagDescribe(@"icon man chinh", icon);
    SCPDiagDescribe(@"icon.application", SCPHomeSafeGet(icon, @"application"));
    SCPDiagDescribe(@"dashboard", SCPHomeSafeGet(app, @"_currentDashboard"));
}

NS_ASSUME_NONNULL_END
