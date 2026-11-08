# Style-geometry closure evidence set (wave 3)

Calibrated dumps (post off-by-one regeneration, 2026-11-08) copied from
`../` — the exact instruction streams the per-style reconstruction in
`../SPPBubbleView.m` (buildStyle:/renderStyle) was transcribed from:

- `0000ed04_-[SPPBubbleView_buildStyle_].txt` — part trees per style 0–8
- `000120c8_-[SPPBubbleView_renderStyle].txt` — per-style layout + epilogues
- `00012018_-[SPPBubbleView_stackHeight].txt`, `00011ee8_...stackNumberAt_top_width_.txt`
- `0000eb40_-[SPPBubbleView_addBit_to_].txt`, `0000ebe0_-[SPPBubbleView_shapePart_in_stroke_width_].txt`
- helpers: sub_15268 (place square), sub_152d8 (frame+mask), sub_153bc
  (unit right-of anchor), sub_15534 (animate width), sub_155f8/sub_11150
  (gradient colour sets), sub_10fc8 (gradient ring), sub_112a0 (rounded
  font), sub_e318 (heavy font), sub_e27c (label factory), sub_1138c
  (label shadow)

Raw constants re-extracted from the arm64 slice (file offset 16384,
vmaddr == in-slice offset) during closure: tick radii pair @0x32c20 =
(57.0, 53.0); style-8 gauge block divisor @block+0x20 = 160.0
(st 0x12858, imm 0x4064000000000000); style content sizes at the
0x146c4/0x14f7c epilogue entries (styles 0/2/3).
