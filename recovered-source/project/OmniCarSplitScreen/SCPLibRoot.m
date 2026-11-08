// SCPLibRoot.m — SplitScreen-C: libroot dynamic binding.
//
// The home wallpaper lives under /var/mobile/Library/OmniCar inside the
// jailbreak root, so paths must be rewritten with libroot's jbrootpath.
// This cluster dlopens @rpath/libroot.dylib once, binds its five entry
// points, and installs pure-C fallbacks (rootless layout: root prefix "",
// jbroot prefix "/var/jb", zero UUID) when the library or a symbol is
// missing. The same bootstrap pattern exists in the OMC core; this copy
// serves the SplitScreen home family (SCPHomeApply is its caller here).

#import <Foundation/Foundation.h>
#import <dlfcn.h>
#import <string.h>
#import <stdlib.h>

NS_ASSUME_NONNULL_BEGIN

typedef char *_Nullable (*SCPPathFn)(const char *, char *_Nullable);
typedef const char *_Nullable (*SCPPrefixFn)(void);

static SCPPrefixFn SCPFnRootPrefix;    // slot 0x87f80 (libroot_get_root_prefix)
static SCPPrefixFn SCPFnJBPrefix;      // slot 0x87f88 (libroot_get_jbroot_prefix)
static SCPPrefixFn SCPFnBootUUID;      // slot 0x87f90 (libroot_get_boot_uuid)
static SCPPathFn SCPFnJBRootPath;      // slot 0x87fa0 (libroot_jbrootpath)
static SCPPathFn SCPFnRootFSPath;      // slot 0x87f98 (libroot_rootfspath)

// ---- fallbacks (VERIFIED bodies) --------------------------------------------

// 0x42ac — VERIFIED
static const char *SCPFallbackRootPrefix(void) { return ""; }
// 0x42b8 — VERIFIED
static const char *SCPFallbackJBPrefix(void) { return "/var/jb"; }
// 0x42c4 — VERIFIED
static const char *SCPFallbackBootUUID(void) {
    return "00000000-0000-0000-0000-000000000000";
}

// 0x42d0 — VERIFIED
static char *SCPFallbackJBRootPath(const char *path, char *_Nullable buf) {
    if (!path) return NULL;
    if (!buf) buf = malloc(0x400);
    const char *prefix = SCPFnJBPrefix ? SCPFnJBPrefix() : "";
    if (path[0] == '/') {
        strlcpy(buf, prefix, 0x400);
        strlcat(buf, path, 0x400);
    } else {
        strlcpy(buf, path, 0x400);
    }
    return buf;
}

// 0x4384 — VERIFIED
static char *SCPFallbackRootFSPath(const char *path, char *_Nullable buf) {
    if (!path) return NULL;
    if (!buf) buf = malloc(0x400);
    const char *root = SCPFnRootPrefix ? SCPFnRootPrefix() : "";
    const char *jb = SCPFnJBPrefix ? SCPFnJBPrefix() : "";
    size_t jbLen = strlen(jb);
    if (path[0] == '/' && strncmp(path, jb, jbLen) == 0) {
        strlcpy(buf, path + jbLen, 0x400); // strip the jbroot prefix
    } else if (path[0] == '/') {
        strlcpy(buf, root, 0x400);
        strlcat(buf, path, 0x400);
    } else {
        strlcpy(buf, path, 0x400);
    }
    return buf;
}

// ---- bootstrap ---------------------------------------------------------------

// 0x4170 — VERIFIED: dispatch_once body (token 0x87fa8, block literal
// 0x786e0) binding libroot, with the fallbacks above as defaults.
static void SCPBindLibRoot(void) {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        void *h = dlopen("@rpath/libroot.dylib", RTLD_LAZY);
        SCPFnRootPrefix = h ? dlsym(h, "libroot_get_root_prefix") : NULL;
        if (!SCPFnRootPrefix) SCPFnRootPrefix = SCPFallbackRootPrefix;
        SCPFnJBPrefix = h ? dlsym(h, "libroot_get_jbroot_prefix") : NULL;
        if (!SCPFnJBPrefix) SCPFnJBPrefix = SCPFallbackJBPrefix;
        SCPFnBootUUID = h ? dlsym(h, "libroot_get_boot_uuid") : NULL;
        if (!SCPFnBootUUID) SCPFnBootUUID = SCPFallbackBootUUID;
        SCPFnJBRootPath = h ? dlsym(h, "libroot_jbrootpath") : NULL;
        if (!SCPFnJBRootPath) SCPFnJBRootPath = SCPFallbackJBRootPath;
        SCPFnRootFSPath = h ? dlsym(h, "libroot_rootfspath") : NULL;
        if (!SCPFnRootFSPath) SCPFnRootFSPath = SCPFallbackRootFSPath;
    });
}

// 0x4118 — VERIFIED: trampoline used by SCPHomeApply for wallpaper paths.
char *SCPJBRootPath(const char *path, char *_Nullable buf) {
    SCPBindLibRoot();
    return SCPFnJBRootPath(path, buf);
}

NS_ASSUME_NONNULL_END
