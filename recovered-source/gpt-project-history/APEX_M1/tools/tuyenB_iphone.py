# -*- coding: utf-8 -*-
"""
tuyenB_iphone.py — Tuyến B (iPhone) mốc M1 DuoCar APEX, design-only.
Vẽ 6 màn x 2 (TRƯỚC skin cũ / SAU APEX), canvas 390x844.
Chỉ dùng token/helper từ apex_style.py dùng chung.
"""
import sys, os
sys.path.insert(0, os.path.expanduser("~/workspace/apex-m1"))
import apex_style as A
from PIL import Image, ImageDraw, ImageFilter

W, H = 390, 844
OUT = os.path.expanduser("~/workspace/apex-m1")
OLD, APEX = A.OLD, A.APEX
BLACK = (0, 0, 0)
DARKTXT = (28, 28, 30)

# ---------------- helpers chung ----------------

def wrap(d, s, f, maxw):
    words, lines, cur = s.split(), [], ""
    for w_ in words:
        t = (cur + " " + w_).strip()
        if d.textlength(t, font=f) <= maxw or not cur:
            cur = t
        else:
            lines.append(cur); cur = w_
    if cur:
        lines.append(cur)
    return lines

def text_wrap(d, x, y, s, f, fill, maxw, lh=None):
    lh = lh or int(f.size * 1.35)
    for ln in wrap(d, s, f, maxw):
        d.text((x, y), ln, font=f, fill=fill)
        y += lh
    return y

def status_old(d):
    d.text((18, 14), "9:41", font=A.font(13, True), fill=BLACK)
    # pin + sóng (vẽ đơn giản)
    d.rounded_rectangle([330, 15, 358, 27], radius=3, outline=BLACK, width=1)
    d.rectangle([332, 17, 352, 25], fill=BLACK)
    d.rectangle([360, 19, 363, 23], fill=BLACK)
    for i in range(4):
        d.rectangle([298 + i * 6, 24 - i * 3, 301 + i * 6, 27], fill=BLACK)

def status_apex(d):
    d.text((18, 14), "9:41", font=A.font(13, True), fill=APEX['ink'])
    d.rounded_rectangle([330, 15, 358, 27], radius=3, outline=APEX['ink'], width=1)
    d.rectangle([332, 17, 352, 25], fill=APEX['accent'])
    d.rectangle([360, 19, 363, 23], fill=APEX['ink'])
    for i in range(4):
        d.rectangle([298 + i * 6, 24 - i * 3, 301 + i * 6, 27], fill=APEX['ink'])

def header_old(img, title, back=False):
    d = ImageDraw.Draw(img)
    status_old(d)
    if back:
        d.text((16, 52), "‹", font=A.font(26, True), fill=OLD['ios_blue'])
        d.text((36, 58), "Cài đặt", font=A.font(13), fill=OLD['ios_blue'])
    d.text((16, 84), title, font=A.font(30, True), fill=BLACK)
    return 128

def header_apex(img, title, subtitle=None):
    d = ImageDraw.Draw(img, 'RGBA')
    status_apex(d)
    # logo APEX nhỏ
    A.draw_logo_apex(d, 52, 66, 17)
    d.text((96, 52), title, font=A.font(21, True), fill=APEX['ink'])
    d.text((96, 76), subtitle or "DuoCar APEX", font=A.font(11), fill=APEX['sub'])
    d.line([16, 100, W - 16, 100], fill=APEX['line'], width=1)
    return 112

NAV_Y = H - 16 - 64  # chừa 16px caption ở đáy

def tabbar_old(img, selected):
    d = ImageDraw.Draw(img, 'RGBA')
    d.rectangle([0, NAV_Y, W, NAV_Y + 64], fill=(249, 249, 249))
    d.line([0, NAV_Y, W, NAV_Y], fill=OLD['ios_line'], width=1)
    items = [("Ứng dụng", 'apps'), ("Chia màn", 'split'), ("Cài đặt", 'gear')]
    for i, (label, g) in enumerate(items):
        cx = W * (i + 0.5) / 3
        col = OLD['ios_blue'] if i == selected else OLD['ios_gray']
        A.glyph(d, g, cx, NAV_Y + 22, 11, col, 2)
        A.text_c(d, cx, NAV_Y + 40, label, A.font(10, i == selected), col)

def navbar_apex(img, selected):
    d = ImageDraw.Draw(img, 'RGBA')
    d.rectangle([0, NAV_Y, W, NAV_Y + 64], fill=APEX['surface'])
    d.line([0, NAV_Y, W, NAV_Y], fill=APEX['line'], width=1)
    items = [("Bảng điều khiển", 'gauge'), ("Bố cục", 'split'), ("Ứng dụng", 'apps'),
             ("Thiết bị", 'phone'), ("Tùy chỉnh", 'gear')]
    for i, (label, g) in enumerate(items):
        cx = W * (i + 0.5) / 5
        col = APEX['accent'] if i == selected else APEX['sub']
        A.glyph(d, g, cx, NAV_Y + 20, 10, col, 2)
        # nhãn 9pt; riêng nhãn dài tự giảm cỡ để không tràn ô 78px
        sz = 9
        while sz > 7 and d.textlength(label, font=A.font(sz, i == selected)) > 74:
            sz -= 1
        A.text_c(d, cx, NAV_Y + 36, label, A.font(sz, i == selected), col)
        if i == selected:
            d.ellipse([cx - 3, NAV_Y + 54, cx + 3, NAV_Y + 60], fill=APEX['accent'])

def card_old(d, box):
    A.rr(d, box, 12, fill=(255, 255, 255))
    return box

def card_apex(d, box, sel=False):
    A.rr(d, box, 14, fill=APEX['surface'],
         outline=APEX['accent'] if sel else APEX['line'], width=2 if sel else 1)
    return box

def section_old(d, x, y, s):
    d.text((x, y), s.upper(), font=A.font(11, True), fill=OLD['ios_gray'])
    return y + 20

def section_apex(d, x, y, s):
    d.text((x, y), s, font=A.font(13, True), fill=APEX['ink'])
    return y + 22

def row_old(d, x0, x1, y, label, value=None, chevron=True, last=False, lab_size=15):
    d.text((x0 + 14, y + 13), label, font=A.font(lab_size), fill=DARKTXT)
    if value is not None:
        A.text_r(d, x1 - 26, y + 13, value, A.font(15), OLD['ios_gray'])
    if chevron:
        A.text_r(d, x1 - 8, y + 11, "›", A.font(17), OLD['ios_gray'])
    if not last:
        d.line([x0 + 14, y + 44, x1, y + 44], fill=(232, 232, 235), width=1)
    return y + 44

def row_apex(d, x0, x1, y, label, value=None, last=False, lab_size=14):
    d.text((x0 + 14, y + 13), label, font=A.font(lab_size), fill=APEX['ink'])
    if value is not None:
        A.text_r(d, x1 - 14, y + 13, value, A.font(13), APEX['accent'])
    if not last:
        d.line([x0 + 14, y + 44, x1 - 14, y + 44], fill=APEX['line'], width=1)
    return y + 44

def new_before(title, tab=2, back=False):
    img = Image.new('RGB', (W, H), OLD['ios_bg'])
    y = header_old(img, title, back=back)
    return img, y

def new_after(title, nav=0, subtitle=None):
    img = Image.new('RGB', (W, H), APEX['bg'])
    y = header_apex(img, title, subtitle)
    return img, y

def finish(img, after, nav):
    if after:
        navbar_apex(img, nav)
        A.caption(img, A.CAPTION_AFTER)
    else:
        tabbar_old(img, nav)
        A.caption(img, A.CAPTION_BEFORE)
    return img

def save(img, name):
    p = os.path.join(OUT, name)
    img.save(p)
    print(name, os.path.getsize(p))
    return p

MX = 16           # lề ngang
X1 = W - 16

# ================================================================
# 1) BẢNG ĐIỀU KHIỂN
# ================================================================
def man1_truoc():
    img, y = new_before("Cài đặt", tab=2)
    d = ImageDraw.Draw(img)
    y = section_old(d, MX + 2, y + 4, "Chung")
    card_old(d, [MX, y, X1, y + 3 * 44]); yy = y
    yy = row_old(d, MX, X1, yy, "Ứng dụng hiển thị trên xe")
    yy = row_old(d, MX, X1, yy, "Chia màn hình")
    yy = row_old(d, MX, X1, yy, "Màn hình khởi động", last=True)
    y += 3 * 44 + 18
    y = section_old(d, MX + 2, y, "Tiện ích")
    card_old(d, [MX, y, X1, y + 2 * 44]); yy = y
    yy = row_old(d, MX, X1, yy, "Bong bóng tốc độ")
    yy = row_old(d, MX, X1, yy, "Thông tin thiết bị", last=True)
    y += 2 * 44 + 18
    y = section_old(d, MX + 2, y, "Khác")
    card_old(d, [MX, y, X1, y + 44])
    row_old(d, MX, X1, y, "Giới thiệu", last=True)
    save(finish(img, False, 2), "iphone-bang-dieu-khien-truoc.png")

def man1_sau():
    img, y = new_after("Bảng điều khiển", nav=0)
    d = ImageDraw.Draw(img)
    # thẻ trạng thái lớn + preview chia màn thu nhỏ
    card_apex(d, [MX, y + 6, X1, y + 226])
    d.text((MX + 14, y + 18), "Xem trước màn hình xe", font=A.font(13, True), fill=APEX['ink'])
    bx0, by0, bx1, by1 = MX + 14, y + 46, X1 - 14, y + 176
    mid = (bx0 + bx1) // 2
    A.draw_map_pane(img, (bx0, by0, mid - 3, by1))
    A.draw_video_pane(img, (mid + 3, by0, bx1, by1))
    d = ImageDraw.Draw(img, 'RGBA')
    A.rr(d, [bx0, by0, bx1, by1], 10, outline=APEX['line'], width=1)
    A.draw_knob(img, mid, (by0 + by1) // 2, 'apex', scale=1)
    d = ImageDraw.Draw(img)
    text_wrap(d, MX + 14, y + 188, "Đang chia màn · Ô trái: Bản đồ · Ô phải: YouTube",
              A.font(12, True), APEX['accent'], X1 - MX - 28)
    y += 226 + 16
    # thẻ chỉ số
    card_apex(d, [MX, y, X1, y + 78])
    cols = [("Pin", "82%"), ("Nhiệt độ", "34°C"), ("Trạng thái", "Ổn định")]
    cw = (X1 - MX) / 3
    for i, (k, v) in enumerate(cols):
        cx = MX + cw * i + cw / 2
        A.text_c(d, cx, y + 12, k, A.font(11), APEX['sub'])
        A.text_c(d, cx, y + 34, v, A.font(17, True), APEX['ink'] if i < 2 else APEX['green'])
        if i:
            d.line([MX + cw * i, y + 14, MX + cw * i, y + 64], fill=APEX['line'], width=1)
    y += 78 + 16
    # chip hành động nhanh
    d.text((MX + 2, y), "Hành động nhanh", font=A.font(13, True), fill=APEX['ink'])
    y += 26
    chips = ["Đổi ứng dụng", "Toàn màn hình", "Hiện thanh lệnh"]
    # tự giảm cỡ chữ chip cho vừa 1 hàng trong khung 358px
    sz = 12
    while sz > 9:
        f = A.font(sz, True)
        widths = [d.textlength(c, font=f) + 24 for c in chips]
        if sum(widths) + 8 * (len(chips) - 1) <= X1 - MX:
            break
        sz -= 1
    f = A.font(sz, True)
    widths = [d.textlength(c, font=f) + 24 for c in chips]
    total = sum(widths) + 8 * (len(chips) - 1)
    cx = MX + max(0, (X1 - MX - total) / 2)
    for c, wd in zip(chips, widths):
        A.rr(d, [cx, y, cx + wd, y + 38], 19, fill=APEX['surface2'], outline=APEX['accent'], width=1)
        A.text_c(d, cx + wd / 2, y + (38 - sz) / 2 - 1, c, f, APEX['accent'])
        cx += wd + 8
    save(finish(img, True, 0), "iphone-bang-dieu-khien-sau.png")

# ================================================================
# 2) BỐ CỤC
# ================================================================
def man2_truoc():
    img, y = new_before("Chia màn", tab=1)
    d = ImageDraw.Draw(img)
    # tiêu đề nhỏ trong trang (tab Chia màn dùng tiêu đề trang riêng)
    y = section_old(d, MX + 2, y + 4, "Chia màn hình")
    card_old(d, [MX, y, X1, y + 4 * 44]); yy = y
    d.text((MX + 14, yy + 13), "Bật chia màn hình", font=A.font(15), fill=DARKTXT)
    A.draw_switch(d, X1 - 65, yy + 7, True, 'old')
    d.line([MX + 14, yy + 44, X1, yy + 44], fill=(232, 232, 235), width=1)
    yy += 44
    yy = row_old(d, MX, X1, yy, "Tỉ lệ mặc định", value="50 : 50")
    yy = row_old(d, MX, X1, yy, "Vị trí núm chia", value="Giữa")
    d.text((MX + 14, yy + 13), "Tự ẩn thanh lệnh", font=A.font(15), fill=DARKTXT)
    A.draw_switch(d, X1 - 65, yy + 7, False, 'old')
    save(finish(img, False, 1), "iphone-bo-cuc-truoc.png")

def ratio_preview(img, box, left_ratio):
    x0, y0, x1, y1 = box
    mid = x0 + (x1 - x0) * left_ratio
    d = ImageDraw.Draw(img)
    d.rectangle([x0, y0, mid, y1], fill=(197, 228, 187))
    d.rectangle([mid, y0, x1, y1], fill=(38, 40, 58))
    d.line([x0 + 6, y0 + (y1 - y0) * 0.6, mid - 6, y0 + (y1 - y0) * 0.35],
           fill=(26, 115, 232), width=3)
    A.glyph(d, 'play', (mid + x1) / 2, (y0 + y1) / 2, 9, (255, 255, 255), 2)
    A.rr(d, [x0, y0, x1, y1], 8, outline=APEX['line'], width=1)
    d.ellipse([mid - 4, (y0 + y1) / 2 - 4, mid + 4, (y0 + y1) / 2 + 4], fill=APEX['accent'])

def man2_sau():
    img, y = new_after("Bố cục", nav=1)
    d = ImageDraw.Draw(img)
    presets = [("50 : 50", 0.50, True), ("60 : 40", 0.60, False), ("40 : 60", 0.40, False)]
    for label, r, sel in presets:
        card_apex(d, [MX, y + 4, X1, y + 92], sel=sel)
        ratio_preview(img, (MX + 14, y + 16, MX + 150, y + 80), r)
        d = ImageDraw.Draw(img)
        d.text((MX + 166, y + 24), "Tỉ lệ " + label, font=A.font(16, True), fill=APEX['ink'])
        if sel:
            A.rr(d, [MX + 166, y + 52, MX + 166 + 92, y + 52 + 24], 12, fill=APEX['glow'])
            A.text_c(d, MX + 166 + 46, y + 57, "Đang chọn", A.font(11, True), (255, 255, 255))
        else:
            d.text((MX + 166, y + 54), "Chạm để áp dụng", font=A.font(11), fill=APEX['sub'])
        y += 92 + 12
    # thẻ toàn màn hình
    card_apex(d, [MX, y + 4, X1, y + 64]); yy = y + 4
    A.glyph(d, 'full', MX + 30, yy + 32, 11, APEX['accent'], 2)
    d.text((MX + 52, yy + 13), "Toàn màn hình", font=A.font(15, True), fill=APEX['ink'])
    d.text((MX + 52, yy + 36), "Một ứng dụng chiếm trọn màn hình xe", font=A.font(11), fill=APEX['sub'])
    y += 64 + 16
    # slider tỉ lệ ô trái
    card_apex(d, [MX, y, X1, y + 96])
    d.text((MX + 14, y + 12), "Tỉ lệ ô trái", font=A.font(14, True), fill=APEX['ink'])
    A.text_r(d, X1 - 14, y + 12, "50%", A.font(14, True), APEX['accent'])
    A.draw_slider(d, MX + 14, y + 44, X1 - MX - 28, 50, 20, 80, 'apex', fmt="{:.0f}%")
    d.text((MX + 14, y + 72), "20%", font=A.font(10), fill=APEX['sub'])
    A.text_r(d, X1 - 14, y + 72, "80%", A.font(10), APEX['sub'])
    save(finish(img, True, 1), "iphone-bo-cuc-sau.png")

# ================================================================
# 3) ỨNG DỤNG
# ================================================================
def man3_truoc():
    img, y = new_before("Ứng dụng", tab=0)
    d = ImageDraw.Draw(img)
    y = section_old(d, MX + 2, y + 4, "Ứng dụng hiển thị trên xe")
    apps = [("Bản đồ", True), ("YouTube", True), ("Nhạc", True),
            ("Điện thoại", False), ("Tin nhắn", False), ("Trình duyệt", False)]
    card_old(d, [MX, y, X1, y + 6 * 44]); yy = y
    for i, (name, on) in enumerate(apps):
        d.text((MX + 14, yy + 13), name, font=A.font(15), fill=DARKTXT)
        if on:
            A.glyph(d, 'check', X1 - 24, yy + 22, 9, OLD['ios_blue'], 2)
        if i < 5:
            d.line([MX + 14, yy + 44, X1, yy + 44], fill=(232, 232, 235), width=1)
        yy += 44
    save(finish(img, False, 0), "iphone-ung-dung-truoc.png")

def glyph_extra(d, name, cx, cy, s, color):
    """Glyph bổ sung ngoài apex_style: tin nhắn (bong bóng thoại) + trình duyệt (quả cầu)."""
    if name == 'msg':
        A.rr(d, [cx - s * 0.9, cy - s * 0.75, cx + s * 0.9, cy + s * 0.45], s * 0.4, outline=color, width=2)
        d.polygon([(cx - s * 0.4, cy + s * 0.45), (cx - s * 0.4, cy + s * 0.9), (cx + s * 0.15, cy + s * 0.45)], outline=color, width=2)
    elif name == 'web':
        d.ellipse([cx - s * 0.85, cy - s * 0.85, cx + s * 0.85, cy + s * 0.85], outline=color, width=2)
        d.line([cx - s * 0.85, cy, cx + s * 0.85, cy], fill=color, width=2)
        d.ellipse([cx - s * 0.35, cy - s * 0.85, cx + s * 0.35, cy + s * 0.85], outline=color, width=2)
    else:
        A.glyph(d, name, cx, cy, s, color, 2)

def man3_sau():
    img, y = new_after("Ứng dụng", nav=2)
    d = ImageDraw.Draw(img)
    # ô tìm kiếm
    A.rr(d, [MX, y + 6, X1, y + 48], 12, fill=APEX['surface'], outline=APEX['line'], width=1)
    d.text((MX + 14, y + 19), "⌕  Tìm ứng dụng", font=A.font(14), fill=APEX['sub'])
    y += 62
    apps = [("Bản đồ", 'pin', "Ô TRÁI", APEX['accent'], True),
            ("YouTube", 'play', "Ô PHẢI", APEX['glow'], True),
            ("Nhạc", 'music', None, None, True),
            ("Điện thoại", 'phone', None, None, False),
            ("Tin nhắn", 'msg', None, None, False),
            ("Trình duyệt", 'web', None, None, False)]
    cw = (X1 - MX - 12) / 2
    chh = 128
    for i, (name, g, badge, bcol, chosen) in enumerate(apps):
        col, row = i % 2, i // 2
        x0 = MX + col * (cw + 12); x1 = x0 + cw
        y0 = y + row * (chh + 12); y1 = y0 + chh
        card_apex(d, [x0, y0, x1, y1], sel=False)
        glyph_extra(d, g, x0 + cw / 2, y0 + 44, 17, APEX['accent'] if g in ('pin', 'play') else APEX['ink'])
        A.text_c(d, x0 + cw / 2, y0 + 72, name, A.font(14, True), APEX['ink'])
        if badge:
            bw = d.textlength(badge, font=A.font(10, True)) + 16
            A.rr(d, [x0 + cw / 2 - bw / 2, y0 + 98, x0 + cw / 2 + bw / 2, y0 + 120], 11, fill=bcol)
            A.text_c(d, x0 + cw / 2, y0 + 103, badge, A.font(10, True), APEX['bg'] if bcol == APEX['accent'] else (255, 255, 255))
        if chosen:
            d.ellipse([x1 - 30, y0 + 8, x1 - 8, y0 + 30], fill=APEX['accent'])
            A.glyph(d, 'check', x1 - 19, y0 + 19, 6, APEX['bg'], 2)
    save(finish(img, True, 2), "iphone-ung-dung-sau.png")

# ================================================================
# 4) THIẾT BỊ
# ================================================================
def man4_truoc():
    img, y = new_before("Cài đặt", tab=2)
    d = ImageDraw.Draw(img)
    y = section_old(d, MX + 2, y + 4, "Thiết bị")
    card_old(d, [MX, y, X1, y + 2 * 44]); yy = y
    yy = row_old(d, MX, X1, yy, "Pin", value="82%", chevron=False)
    yy = row_old(d, MX, X1, yy, "Nhiệt độ", value="34°C", chevron=False, last=True)
    y += 2 * 44 + 18
    y = section_old(d, MX + 2, y, "Bong bóng Lề")
    card_old(d, [MX, y, X1, y + 2 * 52]); yy = y
    d.text((MX + 14, yy + 17), "Hiện bong bóng", font=A.font(15), fill=DARKTXT)
    A.draw_switch(d, X1 - 65, yy + 10, True, 'old')
    d.line([MX + 14, yy + 52, X1, yy + 52], fill=(232, 232, 235), width=1)
    yy += 52
    d.text((MX + 14, yy + 6), "Độ lệch GPS", font=A.font(15), fill=DARKTXT)
    A.text_r(d, X1 - 14, yy + 6, "+3", A.font(15), OLD['ios_gray'])
    A.draw_slider(d, MX + 14, yy + 24, X1 - MX - 28, 3, -10, 10, 'old', fmt="{:+.0f}")
    y += 2 * 52 + 18
    y = section_old(d, MX + 2, y, "Cảnh báo nhiệt")
    card_old(d, [MX, y, X1, y + 52])
    d.text((MX + 14, y + 17), "Giả lập cảnh báo nhiệt 37°C", font=A.font(14), fill=DARKTXT)
    A.draw_switch(d, X1 - 65, y + 10, False, 'old')
    save(finish(img, False, 2), "iphone-thiet-bi-truoc.png")

def man4_sau():
    img, y = new_after("Thiết bị", nav=3)
    d = ImageDraw.Draw(img)
    y = section_apex(d, MX + 2, y + 6, "Sức khỏe thiết bị")
    card_apex(d, [MX, y, X1, y + 108])
    hw = (X1 - MX - 30) / 2
    for i, (k, v) in enumerate([("Pin", "82%"), ("Nhiệt độ", "34°C")]):
        x0 = MX + 10 + i * (hw + 10)
        A.rr(d, [x0, y + 12, x0 + hw, y + 68], 10, fill=APEX['surface2'])
        A.text_c(d, x0 + hw / 2, y + 20, k, A.font(11), APEX['sub'])
        A.text_c(d, x0 + hw / 2, y + 40, v, A.font(20, True), APEX['ink'])
    d.text((MX + 14, y + 80), "Cập nhật 3 giây/lần", font=A.font(11), fill=APEX['sub'])
    y += 108 + 16
    y = section_apex(d, MX + 2, y, "Bong bóng Lề (gói hãng cài riêng)")
    card_apex(d, [MX, y, X1, y + 168]); yy = y
    d.text((MX + 14, yy + 14), "Hiện bong bóng tốc độ", font=A.font(14), fill=APEX['ink'])
    A.draw_switch(d, X1 - 65, yy + 8, True, 'apex')
    d.line([MX + 14, yy + 52, X1 - 14, yy + 52], fill=APEX['line'], width=1)
    yy += 52
    d.text((MX + 14, yy + 10), "Độ lệch GPS", font=A.font(14), fill=APEX['ink'])
    A.text_r(d, X1 - 14, yy + 10, "+3", A.font(14, True), APEX['accent'])
    A.draw_slider(d, MX + 14, yy + 34, X1 - MX - 28, 3, -10, 10, 'apex', fmt="{:+.0f}")
    text_wrap(d, MX + 14, yy + 66, "Chỉ 2 điều khiển này — giao thức Lề giữ nguyên (F9)",
              A.font(10), APEX['sub'], X1 - MX - 28)
    y += 168 + 16
    y = section_apex(d, MX + 2, y, "Cảnh báo nhiệt")
    card_apex(d, [MX, y, X1, y + 118]); yy = y
    d.text((MX + 14, yy + 14), "Giả lập cảnh báo nhiệt 37°C", font=A.font(13), fill=APEX['ink'])
    A.draw_switch(d, X1 - 65, yy + 8, False, 'apex')
    text_wrap(d, MX + 14, yy + 56, "Hàng thuộc D5 — logic cổng 37°C (A2) KHÓA CỨNG, chỉ đổi hình thức",
              A.font(10), APEX['sub'], X1 - MX - 28)
    save(finish(img, True, 3), "iphone-thiet-bi-sau.png")

# ================================================================
# 5) TÙY CHỈNH
# ================================================================
def man5_truoc():
    img, y = new_before("Cài đặt", tab=2)
    d = ImageDraw.Draw(img)
    y = section_old(d, MX + 2, y + 4, "Tùy chỉnh")
    rows = ["Biểu tượng ứng dụng", "Logo khởi động", "Giao diện", "Âm thanh"]
    card_old(d, [MX, y, X1, y + 4 * 44]); yy = y
    for i, r in enumerate(rows):
        yy = row_old(d, MX, X1, yy, r, last=(i == 3))
    save(finish(img, False, 2), "iphone-tuy-chinh-truoc.png")

def man5_sau():
    img, y = new_after("Tùy chỉnh", nav=4)
    d = ImageDraw.Draw(img)
    y = section_apex(d, MX + 2, y + 6, "Biểu tượng ứng dụng")
    card_apex(d, [MX, y, X1, y + 128])
    ic_a = A.home_icon_apex(72)
    ic_o = A.home_icon_old(72)
    # làm mờ icon cũ: trộn về xám
    grey = Image.new('RGB', (72, 72), (120, 120, 128))
    ic_o = Image.blend(ic_o, grey, 0.55)
    # dán icon với mặt nạ bo góc như icon Home thật
    mask = Image.new('L', (72, 72), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, 72, 72], radius=16, fill=255)
    img.paste(ic_a, (MX + 34, y + 16), mask)
    img.paste(ic_o, (X1 - 34 - 72, y + 16), mask)
    d = ImageDraw.Draw(img)
    A.text_c(d, MX + 34 + 36, y + 94, "APEX — chờ duyệt", A.font(11, True), APEX['accent'])
    A.text_c(d, X1 - 34 - 36, y + 94, "Cũ", A.font(11), APEX['sub'])
    y += 128 + 16
    y = section_apex(d, MX + 2, y, "Màu nhấn")
    card_apex(d, [MX, y, X1, y + 104])
    cols = [(APEX['accent'], "Cyan APEX"), (APEX['glow'], "Teal"), (APEX['surface2'], "Slate"), (APEX['sub'], "Xám khói")]
    cw = (X1 - MX) / 4
    for i, (c, name) in enumerate(cols):
        cx = MX + cw * i + cw / 2
        if i == 0:
            d.ellipse([cx - 23, y + 13, cx + 23, y + 59], outline=APEX['accent'], width=3)
        d.ellipse([cx - 17, y + 19, cx + 17, y + 53], fill=c,
                  outline=APEX['line'], width=1)
        A.text_c(d, cx, y + 64, name, A.font(9), APEX['ink'] if i == 0 else APEX['sub'])
    d.text((MX + 14, y + 84), "Đã khóa theo tông APEX", font=A.font(10), fill=APEX['sub'])
    y += 104 + 16
    card_apex(d, [MX, y, X1, y + 2 * 44]); yy = y
    yy = row_apex(d, MX, X1, yy, "Logo khởi động", value="Mặc định APEX")
    d.text((MX + 14, yy + 13), "Hiệu ứng phát sáng", font=A.font(14), fill=APEX['ink'])
    A.draw_switch(d, X1 - 65, yy + 7, True, 'apex')
    save(finish(img, True, 4), "iphone-tuy-chinh-sau.png")

# ================================================================
# 6) KHỞI ĐỘNG
# ================================================================
def thumb_old_scene(size=(86, 56)):
    t = A.vgrad(size, OLD['deep1'], OLD['deep2'])
    m = A.mesh((28, 28))
    mask = Image.new('L', (28, 28), 0)
    ImageDraw.Draw(mask).ellipse([0, 0, 28, 28], fill=255)
    t.paste(m, (size[0] // 2 - 14, size[1] // 2 - 14), mask)
    dd = ImageDraw.Draw(t)
    A.glyph(dd, 'play', size[0] // 2 + 1, size[1] // 2, 8, (255, 255, 255), 2)
    return t

def man6_truoc():
    img, y = new_before("Màn hình khởi động", tab=2, back=True)
    d = ImageDraw.Draw(img)
    y = section_old(d, MX + 2, y + 4, "Phong cách khởi động")
    names = ["Cảnh tím cổ điển", "Cảnh vòng sáng", "Logo của tôi"]
    card_old(d, [MX, y, X1, y + 3 * 72]); yy = y
    for i, nm in enumerate(names):
        img.paste(thumb_old_scene(), (MX + 12, yy + 8))
        d = ImageDraw.Draw(img)
        d.text((MX + 110, yy + 26), nm, font=A.font(15), fill=DARKTXT)
        if i == 0:
            A.glyph(d, 'check', X1 - 24, yy + 36, 9, OLD['ios_blue'], 2)
        if i < 2:
            d.line([MX + 110, yy + 72, X1, yy + 72], fill=(232, 232, 235), width=1)
        yy += 72
    save(finish(img, False, 2), "iphone-startup-truoc.png")

def dashed_rr(d, box, r, color, dash=7, gap=5, width=2):
    x0, y0, x1, y1 = box
    # vẽ 4 cạnh nét đứt (xấp xỉ, bỏ qua bo góc)
    x = x0
    while x < x1:
        d.line([x, y0, min(x + dash, x1), y0], fill=color, width=width)
        d.line([x, y1, min(x + dash, x1), y1], fill=color, width=width)
        x += dash + gap
    yy = y0
    while yy < y1:
        d.line([x0, yy, x0, min(yy + dash, y1)], fill=color, width=width)
        d.line([x1, yy, x1, min(yy + dash, y1)], fill=color, width=width)
        yy += dash + gap

def man6_sau():
    img, y = new_after("Khởi động", nav=4, subtitle="Trong mục Tùy chỉnh")
    d = ImageDraw.Draw(img)
    cw = (X1 - MX - 12) / 2
    chh = 168
    styles = ["APEX Graphite", "Tím cổ điển", "Tối giản", "Logo của tôi"]
    for i, name in enumerate(styles):
        col, row = i % 2, i // 2
        x0 = MX + col * (cw + 12); x1 = x0 + cw
        y0 = y + 6 + row * (chh + 12); y1 = y0 + chh
        sel = (i == 0)
        card_apex(d, [x0, y0, x1, y1], sel=sel)
        tx0, ty0, tx1, ty1 = x0 + 12, y0 + 12, x1 - 12, y0 + 104
        if i == 0:
            thumb = Image.new('RGB', (int(tx1 - tx0), int(ty1 - ty0)), APEX['bg'])
            td = ImageDraw.Draw(thumb, 'RGBA')
            td.ellipse([thumb.width // 2 - 30, thumb.height // 2 - 30,
                        thumb.width // 2 + 30, thumb.height // 2 + 30], outline=APEX['glow'], width=3)
            A.draw_logo_apex(td, thumb.width // 2, thumb.height // 2, 15)
            img.paste(thumb, (int(tx0), int(ty0)))
            d = ImageDraw.Draw(img)
        elif i == 1:
            img.paste(thumb_old_scene((int(tx1 - tx0), int(ty1 - ty0))), (int(tx0), int(ty0)))
            d = ImageDraw.Draw(img)
        elif i == 2:
            d.rectangle([tx0, ty0, tx1, ty1], fill=(0, 0, 0))
            A.text_c(d, (tx0 + tx1) / 2, (ty0 + ty1) / 2 - 8, "DUOCAR", A.font(15, True), (255, 255, 255))
        else:
            dashed_rr(d, [tx0, ty0, tx1, ty1], 8, APEX['sub'])
            A.text_c(d, (tx0 + tx1) / 2, (ty0 + ty1) / 2 - 14, "+", A.font(26, True), APEX['sub'])
        A.text_c(d, x0 + cw / 2, y0 + 122, name, A.font(13, True), APEX['ink'])
        if sel:
            A.rr(d, [x0 + cw / 2 - 40, y0 + 144, x0 + cw / 2 + 40, y0 + 162], 9, fill=APEX['glow'])
            A.text_c(d, x0 + cw / 2, y0 + 147, "Đang chọn", A.font(10, True), (255, 255, 255))
    y += 6 + 2 * chh + 12 + 14
    text_wrap(d, MX + 2, y, "Logo/video người dùng nạp lúc chạy nằm ngoài phạm vi thiết kế APEX (D6).",
              A.font(11), APEX['sub'], X1 - MX - 4)
    save(finish(img, True, 4), "iphone-startup-sau.png")

if __name__ == "__main__":
    man1_truoc(); man1_sau()
    man2_truoc(); man2_sau()
    man3_truoc(); man3_sau()
    man4_truoc(); man4_sau()
    man5_truoc(); man5_sau()
    man6_truoc(); man6_sau()
    print("DONE 12 files")
