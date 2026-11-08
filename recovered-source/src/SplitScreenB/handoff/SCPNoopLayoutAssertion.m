//  SCPNoopLayoutAssertion.m
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib (reconstructed, module B)
//  Evidence: disasm/SCPNoopLayoutAssertion__invalidate.txt

#import "SCPNoopLayoutAssertion.h"

@implementation SCPNoopLayoutAssertion

// VERIFIED: the IMP at 0x58b0 is a single `ret` — an empty override so the
// object can stand in wherever a real layout assertion is expected without
// ever affecting SpringBoard layout.
- (void)invalidate
{
}

@end
