# -*- coding: utf-8 -*-
"""
apex_style.py — Hệ thống vẽ dùng chung cho mockup M1 DuoCar APEX.
Mọi tuyến PHẢI dùng module này (màu, font, bar, handle, knob, icon) để không lệch tông.
Số đo bề mặt cũ lấy từ ma trận M0 (HL61). Ảnh TRƯỚC = dựng lại từ source, không phải ảnh thiết bị.
"""
from PIL import Image, ImageDraw, ImageFont, ImageFilter

FONT_PATH = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
FONTB_PATH = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"

def font(size, bold=False):
    return ImageFont.truetype(FONTB_PATH if bold else FONT_PATH, int(size))

def C(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

# ---------------- TOKEN ----------------
# Tông CŨ (đo từ source HL61)
OLD = dict(
    bg=C('#EEF0FB'), surface=(255, 255, 255), surface2=C('#E3E6F7'),
    ink=C('#4A4F80'), sub=(122, 126, 165), line=(206, 209, 233),
    g1=C('#9B87F8'), g2=C('#5DB4F6'),            # gradient tím cốt lõi
    close=C('#FF5A5F'), red_thermal=(255, 6, 16),  # đỏ nhiệt source ≈ #FF0610
    deep1=C('#1B0B3A'), deep2=C('#3B1A78'),      # nền startup tím đậm
    ios_bg=(242, 242, 247), ios_blue=(0, 122, 255), ios_gray=(142, 142, 147),
    ios_line=(198, 198, 200), green=(52, 199, 89),
)
# Tông APEX (khóa trong Issue #1 mục B; * = sắc phối suy ra từ token gốc, ghi rõ trong SPEC)
APEX = dict(
    bg=C('#101820'), surface=C('#1F303D'), surface2=C('#27394A'),   # surface2* phối
    ink=C('#EAF6FB'), sub=C('#8FA6B3'),                              # sub* phối
    line=C('#2C4356'),                                               # line* phối
    accent=C('#61D9F2'), glow=C('#2EA6BB'),
    close=C('#FF4757'), red_apex=C('#FF4757'), red_src=(255, 6, 16),
    green=(61, 220, 151),
)

def lerp(a, b, t):
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))

def vgrad(size, c1, c2):
    w, h = size
    base = Image.new('RGB', (1, h))
    for y in range(h):
        base.putpixel((0, y), lerp(c1, c2, y / max(1, h - 1)))
    return base.resize((w, h))

def hgrad(size, c1, c2):
    w, h = size
    base = Image.new('RGB', (w, 1))
    for x in range(w):
        base.putpixel((x, 0), lerp(c1, c2, x / max(1, w - 1)))
    return base.resize((w, h))

MESH_STOPS = [(255, 183, 197), (255, 223, 186), (255, 255, 186),
              (186, 255, 201), (186, 225, 255), (216, 186, 255)]

def mesh(size):
    """Mesh pastel cầu vồng của nhận diện OmniCar cũ (diagonal)."""
    w, h = size
    img = Image.new('RGB', size)
    px = img.load()
    n = len(MESH_STOPS) - 1
    for y in range(h):
        for x in range(w):
            t = ((x / max(1, w)) + (y / max(1, h))) / 2 * n
            i = min(n - 1, int(t))
            px[x, y] = lerp(MESH_STOPS[i], MESH_STOPS[i + 1], t - i)
    return img

def paste_grad(img, box, c1, c2, vertical=True):
    x0, y0, x1, y1 = box
    g = vgrad((x1 - x0, y1 - y0), c1, c2) if vertical else hgrad((x1 - x0, y1 - x0), c1, c2)
    img.paste(g, (x0, y0))
    return g

def rr(d, box, r, **kw):
    d.rounded_rectangle(box, radius=r, **kw)

def text_c(d, cx, y, s, f, fill):
    w = d.textlength(s, font=f)
    d.text((cx - w / 2, y), s, font=f, fill=fill)

def text_r(d, x, y, s, f, fill):
    w = d.textlength(s, font=f)
    d.text((x - w, y), s, font=f, fill=fill)

def glow_under(img, box, color, blur=12, alpha=120):
    """Vẽ quầng sáng mờ dưới một vùng (dùng cho glow APEX)."""
    layer = Image.new('RGBA', img.size, (0, 0, 0, 0))
    ld = ImageDraw.Draw(layer)
    ld.rounded_rectangle(box, radius=14, fill=color + (alpha,))
    layer = layer.filter(ImageFilter.GaussianBlur(blur))
    img.paste(Image.alpha_composite(img.convert('RGBA'), layer).convert('RGB'), (0, 0))

CAPTION_BEFORE = "DỰNG LẠI TỪ SOURCE HL61 — KHÔNG PHẢI ẢNH CHỤP THIẾT BỊ"
CAPTION_AFTER = "MOCKUP APEX — ĐỀ XUẤT THIẾT KẾ, CHƯA PHẢI RUNTIME"

def caption(img, msg, dark=True):
    """Dải chú thích nhận diện loại ảnh, vẽ ở cạnh dưới."""
    d = ImageDraw.Draw(img, 'RGBA')
    w, h = img.size
    s = max(1, w // 640)
    ch = 16 * s
    d.rectangle([0, h - ch, w, h], fill=(0, 0, 0, 165))
    f = font(9 * s, bold=True)
    text_c(d, w / 2, h - ch + 3 * s, msg, f, (255, 255, 255))
    return img

# ---------------- ICON GLYPH (vẽ nét, dùng chung 2 thanh lệnh) ----------------
def glyph(d, name, cx, cy, s, color, wdt=2):
    """s = bán kính vùng vẽ. name: apps/full/float/min/close/split/play/music/pin/gear/clock/phone/msg/settings"""
    if name == 'apps':
        r = s * 0.42
        for dx in (-1, 1):
            for dy in (-1, 1):
                x0, y0 = cx + dx * s * 0.48 - r / 1.0, cy + dy * s * 0.48 - r / 1.0
                rr(d, [cx + dx * s * 0.48 - r, cy + dy * s * 0.48 - r,
                       cx + dx * s * 0.48 + r, cy + dy * s * 0.48 + r], r * 0.5, outline=color, width=wdt)
    elif name == 'full':
        L = s * 0.85; k = s * 0.38
        for sx, sy in ((-1, -1), (1, -1), (-1, 1), (1, 1)):
            x, y = cx + sx * L, cy + sy * L
            d.line([x, y, x - sx * k, y], fill=color, width=wdt)
            d.line([x, y, x, y - sy * k], fill=color, width=wdt)
    elif name == 'float':
        rr(d, [cx - s * 0.85, cy - s * 0.55, cx + s * 0.25, cy + s * 0.85], 3, outline=color, width=wdt)
        rr(d, [cx - s * 0.15, cy - s * 0.85, cx + s * 0.85, cy + s * 0.15], 3, outline=color, width=wdt)
    elif name == 'min':
        d.line([cx - s * 0.8, cy, cx + s * 0.8, cy], fill=color, width=max(2, wdt + 1))
    elif name == 'close':
        L = s * 0.62
        d.line([cx - L, cy - L, cx + L, cy + L], fill=color, width=wdt + 1)
        d.line([cx - L, cy + L, cx + L, cy - L], fill=color, width=wdt + 1)
    elif name == 'split':
        rr(d, [cx - s * 0.95, cy - s * 0.7, cx + s * 0.95, cy + s * 0.7], 4, outline=color, width=wdt)
        d.line([cx, cy - s * 0.7, cx, cy + s * 0.7], fill=color, width=wdt)
        d.ellipse([cx - 3, cy - 3, cx + 3, cy + 3], fill=color)
    elif name == 'play':
        d.polygon([(cx - s * 0.5, cy - s * 0.75), (cx - s * 0.5, cy + s * 0.75), (cx + s * 0.75, cy)], fill=color)
    elif name == 'music':
        d.ellipse([cx - s * 0.85, cy + s * 0.15, cx - s * 0.15, cy + s * 0.85], fill=color)
        d.line([cx - s * 0.15, cy + s * 0.5, cx - s * 0.15, cy - s * 0.8], fill=color, width=wdt)
        d.line([cx - s * 0.15, cy - s * 0.8, cx + s * 0.75, cy - s * 0.55], fill=color, width=wdt)
        d.ellipse([cx + s * 0.05, cy + s * 0.15, cx + s * 0.75, cy + s * 0.85], fill=color)
        d.line([cx + s * 0.75, cy + s * 0.5, cx + s * 0.75, cy - s * 0.55], fill=color, width=wdt)
    elif name == 'pin':
        d.ellipse([cx - s * 0.55, cy - s * 0.9, cx + s * 0.55, cy + s * 0.2], outline=color, width=wdt)
        d.polygon([(cx - s * 0.48, cy - s * 0.05), (cx + s * 0.48, cy - s * 0.05), (cx, cy + s * 0.95)], outline=color, width=wdt)
        d.ellipse([cx - s * 0.2, cy - s * 0.55, cx + s * 0.2, cy - s * 0.15], fill=color)
    elif name == 'gear':
        import math
        for i in range(8):
            a = i * math.pi / 4
            d.line([cx + s * 0.62 * math.cos(a), cy + s * 0.62 * math.sin(a),
                    cx + s * 0.95 * math.cos(a), cy + s * 0.95 * math.sin(a)], fill=color, width=wdt)
        d.ellipse([cx - s * 0.62, cy - s * 0.62, cx + s * 0.62, cy + s * 0.62], outline=color, width=wdt)
        d.ellipse([cx - s * 0.25, cy - s * 0.25, cx + s * 0.25, cy + s * 0.25], outline=color, width=wdt)
    elif name == 'clock':
        d.ellipse([cx - s * 0.85, cy - s * 0.85, cx + s * 0.85, cy + s * 0.85], outline=color, width=wdt)
        d.line([cx, cy, cx, cy - s * 0.55], fill=color, width=wdt)
        d.line([cx, cy, cx + s * 0.4, cy + s * 0.2], fill=color, width=wdt)
    elif name == 'phone':
        rr(d, [cx - s * 0.38, cy - s * 0.9, cx + s * 0.38, cy + s * 0.9], 4, outline=color, width=wdt)
        d.line([cx - s * 0.12, cy + s * 0.68, cx + s * 0.12, cy + s * 0.68], fill=color, width=wdt)
    elif name == 'check':
        d.line([cx - s * 0.8, cy, cx - s * 0.25, cy + s * 0.55], fill=color, width=wdt + 1)
        d.line([cx - s * 0.25, cy + s * 0.55, cx + s * 0.85, cy - s * 0.6], fill=color, width=wdt + 1)
    elif name == 'gauge':
        import math
        d.arc([cx - s * 0.9, cy - s * 0.9, cx + s * 0.9, cy + s * 0.9], 180, 360, fill=color, width=wdt)
        a = -0.6
        d.line([cx, cy, cx + s * 0.6 * math.cos(a + 3.14), cy + s * 0.6 * math.sin(a + 3.14)], fill=color, width=wdt)

BAR_ICONS = ['apps', 'full', 'float', 'min', 'close']

def draw_bar(img, x, y, w, skin, scale=1, selected=0):
    """Thanh lệnh 52pt, 5 nút tròn. skin: 'old' | 'apex'. Trả về y đáy."""
    s = scale
    h = 52 * s
    d = ImageDraw.Draw(img, 'RGBA')
    if skin == 'old':
        d.rounded_rectangle([x, y, x + w, y + h], radius=14 * s, fill=(255, 255, 255, 225))
        btn_fill = lambda i: None
        for i, name in enumerate(BAR_ICONS):
            cx = x + w * (i + 0.5) / 5
            cy = y + h / 2
            r = 17 * s
            if i == selected:
                gimg = vgrad((int(2 * r), int(2 * r)), OLD['g1'], OLD['g2'])
                mask = Image.new('L', (int(2 * r), int(2 * r)), 0)
                ImageDraw.Draw(mask).ellipse([0, 0, 2 * r, 2 * r], fill=255)
                img.paste(gimg, (int(cx - r), int(cy - r)), mask)
                gc = (255, 255, 255)
            else:
                d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=(238, 240, 251, 255))
                gc = OLD['ink'] if name != 'close' else OLD['close']
            glyph(d, name, cx, cy, 10 * s, gc, max(2, 2 * s))
    else:
        glow_under(img, [x, y, x + w, y + h], APEX['glow'], blur=10 * s, alpha=60)
        d = ImageDraw.Draw(img, 'RGBA')
        d.rounded_rectangle([x, y, x + w, y + h], radius=14 * s, fill=APEX['surface'] + (242,))
        d.rounded_rectangle([x, y, x + w, y + h], radius=14 * s, outline=APEX['line'] + (255,), width=max(1, s))
        for i, name in enumerate(BAR_ICONS):
            cx = x + w * (i + 0.5) / 5
            cy = y + h / 2
            r = 17 * s
            if i == selected:
                d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=APEX['glow'])
                d.ellipse([cx - r, cy - r, cx + r, cy + r], outline=APEX['accent'], width=max(1, 2 * s))
                gc = (255, 255, 255)
            else:
                d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=APEX['surface2'])
                gc = APEX['ink'] if name != 'close' else APEX['close']
            glyph(d, name, cx, cy, 10 * s, gc, max(2, 2 * s))
    return y + h

def draw_handle(d, cx, cy, skin, scale=1):
    """Handle pill 34x12, 3 chấm cách 8 (x=9/17/25 theo source). Vùng hit thật 44x24 — chỉ vẽ hình."""
    s = scale
    w, h = 34 * s, 12 * s
    if skin == 'old':
        d.rounded_rectangle([cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2], radius=6 * s, fill=(255, 255, 255, 90))
        dot = (255, 255, 255, 235)
    else:
        d.rounded_rectangle([cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2], radius=6 * s,
                            fill=APEX['surface2'] + (235,), outline=APEX['accent'] + (160,), width=max(1, s))
        dot = APEX['accent'] + (255,)
    for dx in (-8 * s, 0, 8 * s):
        r = 1.8 * s
        d.ellipse([cx + dx - r, cy - r, cx + dx + r, cy + r], fill=dot)

def draw_knob(img, cx, cy, skin, scale=1):
    s = scale
    r = 13 * s
    d = ImageDraw.Draw(img, 'RGBA')
    if skin == 'old':
        gimg = vgrad((int(2 * r), int(2 * r)), OLD['g1'], OLD['g2'])
        mask = Image.new('L', (int(2 * r), int(2 * r)), 0)
        ImageDraw.Draw(mask).ellipse([0, 0, 2 * r, 2 * r], fill=255)
        img.paste(gimg, (int(cx - r), int(cy - r)), mask)
        d = ImageDraw.Draw(img, 'RGBA')
    else:
        glow_under(img, [cx - r, cy - r, cx + r, cy + r], APEX['glow'], blur=8 * s, alpha=110)
        d = ImageDraw.Draw(img, 'RGBA')
        d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=APEX['surface'], outline=APEX['accent'], width=max(1, 2 * s))
    gc = (255, 255, 255) if skin == 'old' else APEX['accent']
    for dx in (-4 * s, 0, 4 * s):
        d.line([cx + dx, cy - 5 * s, cx + dx, cy + 5 * s], fill=gc, width=max(1, s))

def draw_switch(d, x, y, on, skin, scale=1):
    s = scale
    w, h = 51 * s, 31 * s
    if skin == 'old':
        col = OLD['ios_blue'] if on else (229, 229, 234)
        rr(d, [x, y, x + w, y + h], h / 2, fill=col)
    else:
        col = APEX['glow'] if on else APEX['surface2']
        rr(d, [x, y, x + w, y + h], h / 2, fill=col, outline=APEX['accent'] if on else APEX['line'], width=max(1, s))
    kx = x + w - h / 2 if on else x + h / 2
    d.ellipse([kx - 13 * s, y + h / 2 - 13 * s, kx + 13 * s, y + h / 2 + 13 * s], fill=(255, 255, 255))
    return (x, y, x + w, y + h)

def draw_slider(d, x, y, w, val, vmin, vmax, skin, fmt="{:+.0f}", scale=1):
    """Slider ngang; val trong [vmin, vmax]. Trả về hộp thanh trượt."""
    s = scale
    t = (val - vmin) / (vmax - vmin)
    cy = y + 10 * s
    if skin == 'old':
        d.rounded_rectangle([x, cy - 2 * s, x + w, cy + 2 * s], radius=2 * s, fill=(220, 220, 228))
        d.rounded_rectangle([x, cy - 2 * s, x + w * t, cy + 2 * s], radius=2 * s, fill=OLD['ios_blue'])
        tc = (255, 255, 255); oc = (200, 200, 205)
    else:
        d.rounded_rectangle([x, cy - 2 * s, x + w, cy + 2 * s], radius=2 * s, fill=APEX['line'])
        d.rounded_rectangle([x, cy - 2 * s, x + w * t, cy + 2 * s], radius=2 * s, fill=APEX['accent'])
        tc = APEX['bg']; oc = APEX['accent']
    kx = x + w * t
    d.ellipse([kx - 11 * s, cy - 11 * s, kx + 11 * s, cy + 11 * s], fill=tc, outline=oc, width=max(1, s))
    return (x, y, x + w, y + 20 * s)

# ---------------- Nội dung app bên thứ ba (GIỮ MÀU GỐC cả 2 skin) ----------------
def draw_map_pane(img, box):
    """Ô bản đồ native — màu của app bản đồ, KHÔNG nhuộm tông DuoCar/APEX."""
    x0, y0, x1, y1 = box
    w, h = x1 - x0, y1 - y0
    img.paste((233, 239, 231), box)
    d = ImageDraw.Draw(img, 'RGBA')
    d.rectangle([x0, y0, x0 + w * 0.30, y0 + h * 0.34], fill=(197, 228, 187))     # công viên
    d.rectangle([x0 + w * 0.62, y0 + h * 0.55, x1, y1], fill=(170, 211, 244))      # hồ nước
    for i in range(5):  # đường ngang
        yy = y0 + h * (0.14 + 0.19 * i)
        d.line([x0, yy, x1, yy - h * 0.05], fill=(255, 255, 255), width=max(3, h // 42))
    for i in range(4):  # đường dọc
        xx = x0 + w * (0.12 + 0.26 * i)
        d.line([xx, y0, xx + w * 0.05, y1], fill=(255, 255, 255), width=max(3, h // 42))
    d.line([x0 + w * 0.06, y0 + h * 0.86, x0 + w * 0.38, y0 + h * 0.55,
            x0 + w * 0.55, y0 + h * 0.58, x0 + w * 0.80, y0 + h * 0.26],
           fill=(255, 214, 90), width=max(4, h // 30))                            # đường lớn
    d.line([x0 + w * 0.10, y0 + h * 0.90, x0 + w * 0.36, y0 + h * 0.60,
            x0 + w * 0.62, y0 + h * 0.62, x0 + w * 0.86, y0 + h * 0.30],
           fill=(26, 115, 232), width=max(4, h // 34))                            # tuyến đường
    px, py = x0 + w * 0.86, y0 + h * 0.30
    d.ellipse([px - 8, py - 8, px + 8, py + 8], fill=(234, 67, 53), outline=(255, 255, 255), width=2)
    sx, sy = x0 + w * 0.10, y0 + h * 0.90
    d.ellipse([sx - 6, sy - 6, sx + 6, sy + 6], fill=(26, 115, 232), outline=(255, 255, 255), width=2)
    d.rounded_rectangle([x0 + 10, y0 + 10, x0 + w * 0.68, y0 + 40], radius=8, fill=(255, 255, 255, 235))
    d.text((x0 + 20, y0 + 21), "Đường Láng · 12 phút", font=font(max(10, h // 30), True), fill=(60, 64, 67))

def draw_video_pane(img, box, title="Video đang phát"):
    """Ô video hosted — giao diện của app video, giữ màu gốc."""
    x0, y0, x1, y1 = box
    w, h = x1 - x0, y1 - y0
    img.paste(vgrad((w, h), (38, 40, 58), (12, 12, 20)), box)
    d = ImageDraw.Draw(img, 'RGBA')
    d.ellipse([x0 + w * 0.70, y0 + h * 0.08, x0 + w * 0.98, y0 + h * 0.50], fill=(70, 76, 110))
    d.polygon([(x0, y1), (x0 + w * 0.35, y0 + h * 0.45), (x0 + w * 0.62, y1)], fill=(24, 26, 38))
    cx, cy = (x0 + x1) / 2, (y0 + y1) / 2
    d.ellipse([cx - 26, cy - 26, cx + 26, cy + 26], fill=(0, 0, 0, 120), outline=(255, 255, 255), width=2)
    glyph(d, 'play', cx + 2, cy, 14, (255, 255, 255), 2)
    d.rectangle([x0, y1 - 6, x1, y1], fill=(60, 60, 70))
    d.rectangle([x0, y1 - 6, x0 + w * 0.42, y1], fill=(255, 0, 51))
    d.text((x0 + 12, y0 + 10), title, font=font(max(11, h // 26), True), fill=(255, 255, 255))

# ---------------- Logo ----------------
def draw_logo_old(d, cx, cy, r):
    """Nhận diện cũ: vòng mesh + tam giác play (theo mô tả assets D12)."""
    img = d._image if hasattr(d, '_image') else None
    m = mesh((int(2 * r), int(2 * r)))
    mask = Image.new('L', (int(2 * r), int(2 * r)), 0)
    ImageDraw.Draw(mask).ellipse([0, 0, 2 * r, 2 * r], fill=255)
    if img is not None:
        img.paste(m, (int(cx - r), int(cy - r)), mask)
    glyph(d, 'play', cx + r * 0.08, cy, r * 0.52, (255, 255, 255), 3)

def draw_logo_apex(d, cx, cy, r, with_glow_img=None):
    """ĐỀ XUẤT logo APEX: BIỂU TƯỢNG hai ô chia màn (bản chất DuoCar) + knob ở khe chia.
    Hai ô bo góc: ô trái viền cyan đặc trưng, ô phải slate; khe chia có núm tròn.
    Đây là đề xuất chờ Nguyen duyệt — không phải chốt."""
    w2 = r * 1.55  # nửa chiều rộng biểu tượng (tỉ lệ ngang của 2 ô)
    h2 = r * 0.95
    x0, y0, x1, y1 = cx - w2, cy - h2, cx + w2, cy + h2
    rr(d, [x0, y0, cx - r * 0.08, y1], r * 0.22, fill=APEX['surface'], outline=APEX['accent'], width=max(2, int(r * 0.07)))
    rr(d, [cx + r * 0.08, y0, x1, y1], r * 0.22, fill=APEX['surface2'], outline=APEX['glow'], width=max(2, int(r * 0.07)))
    # nội dung gợi ý trong 2 ô: ghim bản đồ (trái) + play (phải)
    glyph(d, 'pin', (x0 + cx - r * 0.08) / 2, cy, r * 0.34, APEX['accent'], 2)
    glyph(d, 'play', (cx + r * 0.08 + x1) / 2, cy, r * 0.30, APEX['ink'], 2)
    # knob ở khe chia
    d.ellipse([cx - r * 0.16, cy - r * 0.16, cx + r * 0.16, cy + r * 0.16], fill=APEX['accent'], outline=(255, 255, 255), width=max(1, int(r * 0.04)))
    return (x0, y0, x1, y1)

def home_icon_old(size):
    img = Image.new('RGB', (size, size))
    m = mesh((size, size))
    mask = Image.new('L', (size, size), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, size, size], radius=size * 0.22, fill=255)
    img.paste(m, (0, 0), mask)
    d = ImageDraw.Draw(img)
    glyph(d, 'play', size / 2, size / 2, size * 0.30, (255, 255, 255), 3)
    return img

def home_icon_apex(size):
    img = Image.new('RGB', (size, size), APEX['bg'])
    d = ImageDraw.Draw(img, 'RGBA')
    glow_under(img, [size * 0.10, size * 0.16, size * 0.90, size * 0.84], APEX['glow'], blur=size // 9, alpha=90)
    d = ImageDraw.Draw(img, 'RGBA')
    draw_logo_apex(d, size / 2, size / 2, size * 0.30)
    return img
