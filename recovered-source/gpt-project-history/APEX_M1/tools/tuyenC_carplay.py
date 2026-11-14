# -*- coding: utf-8 -*-
"""
tuyenC_carplay.py — Tuyến CarPlay, mốc M1 DuoCar APEX (design-only).
render(state, skin, S): cùng một hàm vẽ ra bản 1x (640x360, S=1) và 2x (1280x720, S=2).
Mọi tọa độ / cỡ chữ nhân S. Nội dung app bên thứ ba (bản đồ / video qua apex_style)
giữ nguyên cả 2 skin — chỉ chrome DuoCar đổi theo skin.
skin: 'old' (truoc) | 'apex' (sau)
"""
import os
import sys
import math

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))

from PIL import Image, ImageDraw

import apex_style as A

BASE_W, BASE_H = 640, 360
OUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
STATES = ["split", "hosted", "picker-native", "picker-hosted",
          "fullscreen", "keyboard", "home", "startup"]


def sc(v, S):
    return int(round(v * S))


def box(b, S):
    return [sc(b[0], S), sc(b[1], S), sc(b[2], S), sc(b[3], S)]


# ---------------------------------------------------------------- glyph mở rộng
def glyph_any(d, name, cx, cy, s, color, wdt=2):
    """Dùng A.glyph khi có; tự vẽ cho msg/calendar/photo (apex_style chưa có)."""
    if name in ("apps", "full", "float", "min", "close", "split", "play",
                "music", "pin", "gear", "clock", "phone", "check", "gauge"):
        A.glyph(d, name, cx, cy, s, color, wdt)
    elif name == "msg":
        # bong bóng chat: hộp bo góc + đuôi
        A.rr(d, [cx - s * 0.85, cy - s * 0.70, cx + s * 0.85, cy + s * 0.45],
             s * 0.30, outline=color, width=wdt)
        d.polygon([(cx - s * 0.35, cy + s * 0.45), (cx - s * 0.05, cy + s * 0.45),
                   (cx - s * 0.35, cy + s * 0.90)], outline=color, width=wdt)
        for dx in (-0.42, 0.0, 0.42):
            r = s * 0.09
            d.ellipse([cx + dx * s - r, cy - s * 0.12 - r,
                       cx + dx * s + r, cy - s * 0.12 + r], fill=color)
    elif name == "calendar":
        A.rr(d, [cx - s * 0.80, cy - s * 0.75, cx + s * 0.80, cy + s * 0.80],
             s * 0.18, outline=color, width=wdt)
        d.line([cx - s * 0.80, cy - s * 0.30, cx + s * 0.80, cy - s * 0.30],
               fill=color, width=wdt)
        for dx in (-0.45, 0.45):
            d.line([cx + dx * s, cy - s * 0.95, cx + dx * s, cy - s * 0.55],
                   fill=color, width=wdt + 1)
        r = s * 0.11
        for dx in (-0.40, 0.0, 0.40):
            for dy in (0.05, 0.45):
                d.ellipse([cx + dx * s - r, cy + dy * s - r,
                           cx + dx * s + r, cy + dy * s + r], fill=color)
    elif name == "photo":
        A.rr(d, [cx - s * 0.85, cy - s * 0.80, cx + s * 0.85, cy + s * 0.80],
             s * 0.16, outline=color, width=wdt)
        r = s * 0.18
        d.ellipse([cx + s * 0.28 - r, cy - s * 0.52 - r,
                   cx + s * 0.28 + r, cy - s * 0.52 + r], fill=color)
        d.polygon([(cx - s * 0.85, cy + s * 0.80), (cx - s * 0.15, cy - s * 0.05),
                   (cx + s * 0.25, cy + s * 0.42), (cx + s * 0.50, cy + s * 0.05),
                   (cx + s * 0.85, cy + s * 0.80)], outline=color, width=wdt)
    elif name == "video":
        A.rr(d, [cx - s * 0.90, cy - s * 0.65, cx + s * 0.90, cy + s * 0.65],
             s * 0.18, outline=color, width=wdt)
        A.glyph(d, "play", cx + s * 0.05, cy, s * 0.42, color, wdt)
    else:
        A.glyph(d, "apps", cx, cy, s, color, wdt)


# ---------------------------------------------------------------- dữ liệu app
APPS_PICKER = [
    ("Bản đồ", "pin", (52, 199, 89)),
    ("YouTube", "play", (255, 0, 51)),
    ("Nhạc", "music", (250, 45, 85)),
    ("Điện thoại", "phone", (0, 190, 90)),
    ("Tin nhắn", "msg", (0, 200, 120)),
    ("Lịch", "calendar", (255, 149, 0)),
    ("Ảnh", "photo", (0, 170, 255)),
    ("Cài đặt", "gear", (142, 142, 147)),
]

APPS_HOME = [
    ("Bản đồ", "pin", (52, 199, 89)),
    ("Nhạc", "music", (250, 45, 85)),
    ("Điện thoại", "phone", (0, 190, 90)),
    ("Tin nhắn", "msg", (0, 200, 120)),
    ("__DUOCAR__", None, None),
    ("Đồng hồ", "clock", (32, 32, 36)),
    ("Ảnh", "photo", (0, 170, 255)),
    ("Cài đặt", "gear", (142, 142, 147)),
    ("Lịch", "calendar", (255, 149, 0)),
    ("Video", "video", (28, 28, 34)),
]


# ---------------------------------------------------------------- chrome chung
def draw_home_button(img, skin, S):
    """Nút home (logo) tròn Ø44 ở góc dưới trái màn split/hosted. Tâm (34,316) suy ra từ Ø44 + lề 12."""
    cx, cy, r = sc(34, S), sc(316, S), sc(22, S)
    d = ImageDraw.Draw(img, "RGBA")
    if skin == "old":
        m = A.mesh((int(2 * r), int(2 * r)))
        mask = Image.new("L", (int(2 * r), int(2 * r)), 0)
        ImageDraw.Draw(mask).ellipse([0, 0, 2 * r, 2 * r], fill=255)
        img.paste(m, (int(cx - r), int(cy - r)), mask)
        d = ImageDraw.Draw(img, "RGBA")
        d.ellipse([cx - r, cy - r, cx + r, cy + r], outline=(255, 255, 255), width=max(1, S))
        A.glyph(d, "play", cx + sc(1, S), cy, sc(10, S), (255, 255, 255), max(2, 2 * S))
    else:
        d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=A.APEX["surface"] + (255,),
                  outline=A.APEX["line"] + (255,), width=max(1, S))
        A.draw_logo_apex(d, cx, cy, sc(11, S))


def draw_app_tile(img, cx, cy, size_pt, app, glyph_color=(255, 255, 255)):
    """Ô app vuông bo góc, màu riêng của app + glyph trắng. size_pt theo pt (chưa nhân S ở đây ngoài glyph)."""
    d = ImageDraw.Draw(img, "RGBA")
    name, gname, col = app
    x0, y0 = cx - size_pt / 2, cy - size_pt / 2
    A.rr(d, [x0, y0, x0 + size_pt, y0 + size_pt], size_pt * 0.24, fill=col + (255,))
    glyph_any(d, gname, cx, cy, size_pt * 0.30, glyph_color, 2)
    return [x0, y0, x0 + size_pt, y0 + size_pt]


# ---------------------------------------------------------------- 1) split
def render_split(skin, S):
    img = Image.new("RGB", (BASE_W * S, BASE_H * S), (20, 20, 24))
    # ô trái 318pt bản đồ native, ô phải video hosted, khe chia 4pt giữa
    A.draw_map_pane(img, box([0, 0, 318, 360], S))
    A.draw_video_pane(img, box([322, 0, 640, 360], S))
    d = ImageDraw.Draw(img, "RGBA")
    d.rectangle(box([318, 0, 322, 360], S), fill=(18, 18, 22))
    # handle pill trên ô phải
    A.draw_handle(d, sc(480, S), sc(26, S), skin, S)
    # thanh lệnh trên ô phải sát đáy
    A.draw_bar(img, sc(330, S), sc(292, S), sc(300, S), skin, S, selected=0)
    d = ImageDraw.Draw(img, "RGBA")
    # menu tỉ lệ mở cạnh knob
    kx, ky = sc(320, S), sc(170, S)
    if skin == "old":
        # vòng tròn conic 4 cung màu quanh knob
        R = sc(52, S)
        cols = [A.C("#A78BFA"), A.C("#5DB4F6"), A.C("#34C759"), A.C("#FFD65A")]
        for i, col in enumerate(cols):
            d.pieslice([kx - R, ky - R, kx + R, ky + R],
                       start=-90 + i * 90, end=-90 + (i + 1) * 90,
                       fill=col + (235,), outline=(255, 255, 255), width=max(1, 2 * S))
        d.ellipse([kx - sc(30, S), ky - sc(30, S), kx + sc(30, S), ky + sc(30, S)],
                  fill=(255, 255, 255, 235))
    else:
        # thẻ nhỏ slate cạnh knob chứa 3 chip tỉ lệ
        card = box([342, 116, 482, 224], S)
        A.rr(d, card, sc(12, S), fill=A.APEX["surface"] + (248,),
             outline=A.APEX["line"] + (255,), width=max(1, S))
        chips = ["50:50  ●", "60:40", "40:60"]
        for i, label in enumerate(chips):
            cy0 = 126 + i * 32
            cb = box([354, cy0, 470, cy0 + 26], S)
            kw = dict(fill=A.APEX["surface2"] + (255,))
            if i == 0:
                kw["outline"] = A.APEX["accent"] + (255,)
                kw["width"] = max(1, 2 * S)
            A.rr(d, cb, sc(8, S), **kw)
            col = A.APEX["accent"] if i == 0 and "●" in label else A.APEX["ink"]
            A.text_c(d, sc(412, S), sc(cy0 + 5, S), label, A.font(11 * S, True),
                     A.APEX["ink"] if i else A.APEX["ink"])
            if i == 0:
                r = sc(3, S)
                d.ellipse([sc(452, S) - r, sc(cy0 + 13, S) - r,
                           sc(452, S) + r, sc(cy0 + 13, S) + r], fill=A.APEX["accent"])
    # knob tại khe chia (vẽ sau menu để nằm trên)
    A.draw_knob(img, sc(320, S), sc(170, S), skin, S)
    draw_home_button(img, skin, S)
    return img


# ---------------------------------------------------------------- 2) hosted
def render_hosted(skin, S):
    img = Image.new("RGB", (BASE_W * S, BASE_H * S), (12, 12, 20))
    A.draw_video_pane(img, box([0, 0, 640, 360], S))
    d = ImageDraw.Draw(img, "RGBA")
    A.draw_handle(d, sc(320, S), sc(26, S), skin, S)
    # thanh lệnh giữa đáy, rộng 259 (bản hosted theo source)
    A.draw_bar(img, sc(190, S), sc(292, S), sc(259, S), skin, S, selected=0)
    draw_home_button(img, skin, S)
    return img


# ---------------------------------------------------------------- picker dùng chung
def draw_picker_sheet(img, skin, S, sheet_box_pt):
    sx0, sy0, sx1, sy1 = sheet_box_pt
    d = ImageDraw.Draw(img, "RGBA")
    sb = box(sheet_box_pt, S)
    if skin == "old":
        A.rr(d, sb, sc(16, S), fill=(255, 255, 255, 248),
             outline=A.OLD["g1"] + (255,), width=max(1, 2 * S))
        # dải mesh trên đầu sheet
        hdr = Image.new("RGB", (sc(sx1 - sx0, S), sc(34, S)))
        hdr.paste(A.mesh(hdr.size), (0, 0))
        mask = Image.new("L", hdr.size, 0)
        md = ImageDraw.Draw(mask)
        md.rounded_rectangle([0, 0, hdr.size[0], hdr.size[1] + sc(16, S)],
                             radius=sc(16, S), fill=255)
        img.paste(hdr, (sc(sx0, S), sc(sy0, S)), mask)
        d = ImageDraw.Draw(img, "RGBA")
        title_c, label_c, sub_c = (255, 255, 255), A.OLD["ink"], A.OLD["sub"]
        ring_c = A.OLD["g1"]
        dot_on, dot_off = A.OLD["g1"], A.OLD["line"]
    else:
        A.rr(d, sb, sc(16, S), fill=A.APEX["surface"] + (250,),
             outline=A.APEX["line"] + (255,), width=max(1, S))
        d.line([sc(sx0 + 16, S), sc(sy0 + 36, S), sc(sx1 - 16, S), sc(sy0 + 36, S)],
               fill=A.APEX["accent"] + (255,), width=max(1, 2 * S))
        title_c, label_c, sub_c = A.APEX["ink"], A.APEX["ink"], A.APEX["sub"]
        ring_c = A.APEX["accent"]
        dot_on, dot_off = A.APEX["accent"], A.APEX["line"]
    # Tiêu đề: APEX = ice trên nền slate; CŨ = mực tím trên dải mesh pastel
    # (chữ trắng trên mesh pastel không đọc được — đã kiểm ảnh vòng 1)
    A.text_c(d, sc((sx0 + sx1) / 2, S), sc(sy0 + 8, S), "Chọn ứng dụng",
             A.font(14 * S, True), A.APEX["ink"] if skin == "apex" else A.OLD["ink"])
    # lưới 4 cột x 2 hàng, ô Ø52
    tile = 52
    pitch_x = 84 if (sx1 - sx0) >= 400 else 80
    pitch_y = 80
    grid_w = 3 * pitch_x + tile
    gx0 = sx0 + ((sx1 - sx0) - grid_w) / 2
    gy0 = sy0 + 48
    for idx, app in enumerate(APPS_PICKER):
        r, c = divmod(idx, 4)
        cx = gx0 + c * pitch_x + tile / 2
        cy = gy0 + r * pitch_y + tile / 2
        tb = draw_app_tile(img, sc(cx, S), sc(cy, S), sc(tile, S), app)
        d = ImageDraw.Draw(img, "RGBA")
        if idx == 0:  # ô đang chọn (Bản đồ): vòng nhấn theo skin
            pad = sc(5, S)
            d.rounded_rectangle([tb[0] - pad, tb[1] - pad, tb[2] + pad, tb[3] + pad],
                                radius=sc(16, S), outline=ring_c + (255,),
                                width=max(2, 3 * S))
        A.text_c(d, sc(cx, S), sc(cy + tile / 2 + 5, S), app[0],
                 A.font(10 * S), label_c)
    # 3 chấm trang, chấm đầu active theo skin
    py = sy1 - 20
    for i in range(3):
        cx = (sx0 + sx1) / 2 + (i - 1) * 18
        r = sc(4, S) if i == 0 else sc(3, S)
        d.ellipse([sc(cx, S) - r, sc(py, S) - r, sc(cx, S) + r, sc(py, S) + r],
                  fill=(dot_on if i == 0 else dot_off) + (255,))


# ---------------------------------------------------------------- 3) picker-native
def render_picker_native(skin, S):
    img = Image.new("RGB", (BASE_W * S, BASE_H * S))
    A.draw_map_pane(img, box([0, 0, 640, 360], S))
    draw_picker_sheet(img, skin, S, [120, 56, 520, 304])  # sheet 400x248 giữa màn
    return img


# ---------------------------------------------------------------- 4) picker-hosted
def render_picker_hosted(skin, S):
    img = Image.new("RGB", (BASE_W * S, BASE_H * S))
    # nền video toàn màn — nội dung ô (kể cả thanh tiến trình đỏ ở đáy) giữ nguyên
    A.draw_video_pane(img, box([0, 0, 640, 360], S))
    # phủ mờ đen 25%
    overlay = Image.new("RGBA", img.size, (0, 0, 0, 64))
    img = Image.alpha_composite(img.convert("RGBA"), overlay).convert("RGB")
    draw_picker_sheet(img, skin, S, [130, 60, 510, 300])  # sheet 380x240 giữa màn
    d = ImageDraw.Draw(img, "RGBA")
    # ghi chú trực tiếp trong ảnh, góc trên trái, chữ nhỏ
    note = "Ô bên dưới còn nguyên khi picker mở"
    f = A.font(10 * S, True)
    tw = d.textlength(note, font=f)
    A.rr(d, [sc(8, S), sc(6, S), sc(8, S) + tw + sc(14, S), sc(28, S)],
         sc(6, S), fill=(0, 0, 0, 150))
    d.text((sc(15, S), sc(11, S)), note, font=f, fill=(255, 255, 255))
    return img


# ---------------------------------------------------------------- 5) fullscreen
def render_fullscreen(skin, S):
    img = Image.new("RGB", (BASE_W * S, BASE_H * S))
    A.draw_map_pane(img, box([0, 0, 640, 360], S))
    d = ImageDraw.Draw(img, "RGBA")
    # HUD góc trái trên: pill chứa giờ – pin – nhiệt
    hud = "21:47 · Pin 82% · 34°C"
    f = A.font(12 * S, True)
    tw = d.textlength(hud, font=f)
    pill = [sc(12, S), sc(12, S), sc(12, S) + tw + sc(24, S), sc(40, S)]
    if skin == "old":
        A.rr(d, pill, sc(14, S), fill=(255, 255, 255, 235))
        d.text((sc(24, S), sc(19, S)), hud, font=f, fill=A.OLD["ink"])
    else:
        A.rr(d, pill, sc(14, S), fill=A.APEX["surface"] + (215,),
             outline=A.APEX["line"] + (255,), width=max(1, S))
        # vẽ từng đoạn để số nhiệt mang màu cyan
        parts = [("21:47 · Pin 82% · ", A.APEX["ink"]), ("34°C", A.APEX["accent"])]
        x = sc(24, S)
        for txt, col in parts:
            d.text((x, sc(19, S)), txt, font=f, fill=col)
            x += d.textlength(txt, font=f)
    # handle pill tại (320,20), mờ 50% (controls đang ẩn một phần)
    layer = Image.new("RGBA", img.size, (0, 0, 0, 0))
    ld = ImageDraw.Draw(layer, "RGBA")
    A.draw_handle(ld, sc(320, S), sc(20, S), skin, S)
    alpha = layer.getchannel("A").point(lambda a: int(a * 0.5))
    layer.putalpha(alpha)
    img.paste(Image.alpha_composite(img.convert("RGBA"), layer).convert("RGB"), (0, 0))
    if skin == "old":
        # Handle cũ trắng alpha 90 (số của source) mờ thêm 50% trên nền bản đồ sáng
        # thì gần như vô hình; thêm viền xám mờ nhẹ để vị trí còn nhận ra trong mockup.
        d = ImageDraw.Draw(img, "RGBA")
        A.rr(d, box([303, 14, 337, 26], S), sc(6, S),
             outline=(110, 114, 140, 110), width=max(1, S))
    # KHÔNG có thanh lệnh (đang fullscreen)
    return img


# ---------------------------------------------------------------- 6) keyboard
KB_SUB = {"e": "ê", "a": "ă â", "o": "ô ơ", "u": "ư"}


def _key_old(img, kb, S):
    """Phím gradient tím vgrad g1->g2, chữ trắng (skin cũ)."""
    x0, y0, x1, y1 = [int(v) for v in kb]
    w, h = x1 - x0, y1 - y0
    if w <= 0 or h <= 0:
        return
    g = A.vgrad((w, h), A.OLD["g1"], A.OLD["g2"])
    mask = Image.new("L", (w, h), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, w, h], radius=sc(7, S), fill=255)
    img.paste(g, (x0, y0), mask)


def render_keyboard(skin, S):
    img = Image.new("RGB", (BASE_W * S, BASE_H * S), (26, 26, 34))
    d = ImageDraw.Draw(img, "RGBA")
    # nửa trên: ô app hosted nền tối
    d.rectangle(box([0, 0, 640, 196], S), fill=(26, 26, 34))
    A.text_c(d, sc(320, S), sc(26, S), "Tìm kiếm địa điểm", A.font(13 * S, True),
             (200, 204, 220))
    # ô nhập: chữ đã gõ + con trỏ (nội dung app, giữ nguyên cả 2 skin)
    fld = box([70, 52, 570, 102], S)
    A.rr(d, fld, sc(12, S), fill=(255, 255, 255, 255))
    d.text((sc(88, S), sc(66, S)), "quan an", font=A.font(17 * S), fill=(30, 30, 40))
    tw = d.textlength("quan an", font=A.font(17 * S))
    cx_cur = sc(88, S) + tw + sc(3, S)
    d.rectangle([cx_cur, sc(64, S), cx_cur + max(1, 2 * S), sc(90, S)], fill=(26, 115, 232))
    A.text_c(d, sc(320, S), sc(122, S), "Ứng dụng hosted — kết quả tìm kiếm",
             A.font(11 * S), (150, 154, 175))
    # nửa dưới từ y=196: panel bàn phím
    if skin == "old":
        panel = A.mesh((BASE_W * S, sc(164, S)))
        img.paste(panel, (0, sc(196, S)))
    else:
        d = ImageDraw.Draw(img, "RGBA")
        d.rectangle(box([0, 196, 640, 360], S), fill=A.APEX["bg"])
    d = ImageDraw.Draw(img, "RGBA")

    rows = [
        list("qwertyuiop"),
        list("asdfghjkl"),
        ["⇧"] + list("zxcvbnm") + ["⌫"],
        ["123", "SPACE", "⏎"],
    ]
    row_y = [202, 237, 272, 307]
    key_h = 30
    for ri, row in enumerate(rows):
        y0 = row_y[ri]
        if ri == 3:
            layout = [("123", 70, True), ("Khoảng", 640 - 16 - 70 - 70 - 2 * 6 - 70, False),
                      ("⏎", 70, True)]
            # tính lại: lề 8 hai bên, gap 6: [123]=70, [⏎]=70, space = 640-16-70-70-12=472
            layout = [("123", 70, True), ("Khoảng", 472, False), ("⏎", 70, True)]
            x = 8
            items = []
            for label, wpt, is_func in layout:
                items.append((label, x, wpt, is_func))
                x += wpt + 6
        elif ri == 2:
            # ⇧ và ⌫ rộng 58, phím chữ rộng theo hàng 1
            gap = 6
            func_w = 58
            letter_w = (640 - 16 - 2 * func_w - 8 * gap) / 7
            x = 8
            items = []
            for label in row:
                if label in ("⇧", "⌫"):
                    items.append((label, x, func_w, True))
                    x += func_w + gap
                else:
                    items.append((label, x, letter_w, False))
                    x += letter_w + gap
        else:
            n = len(row)
            gap = 6
            margin = 8 if ri == 0 else 8 + (640 - 16 - (9 * 57 + 8 * gap)) / 2
            if ri == 0:
                kw = (640 - 16 - (n - 1) * gap) / n
            else:
                kw = 57
                margin = (640 - (n * kw + (n - 1) * gap)) / 2
            x = margin
            items = []
            for label in row:
                items.append((label, x, kw, False))
                x += kw + gap
        for label, xpt, wpt, is_func in items:
            kb = box([xpt, y0, xpt + wpt, y0 + key_h], S)
            if skin == "old":
                _key_old(img, kb, S)
                d = ImageDraw.Draw(img, "RGBA")
                tc = (255, 255, 255)
            else:
                kw2 = dict(fill=A.APEX["surface2"] + (255,))
                if is_func:
                    kw2["outline"] = A.APEX["accent"] + (255,)
                    kw2["width"] = max(1, S)
                else:
                    kw2["outline"] = A.APEX["line"] + (255,)
                    kw2["width"] = max(1, S)
                A.rr(d, kb, sc(7, S), **kw2)
                tc = A.APEX["ink"]
            fs = 15 if len(label) == 1 else 12
            A.text_c(d, sc(xpt + wpt / 2, S), sc(y0 + 6, S), label,
                     A.font(fs * S, True), tc)
            # nhãn phụ góc phải trên của vài phím nguyên âm
            if label in KB_SUB:
                sub = KB_SUB[label]
                sf = A.font(8 * S)
                sw = d.textlength(sub, font=sf)
                d.text((sc(xpt + wpt, S) - sw - sc(4, S), sc(y0 + 2, S)), sub,
                       font=sf, fill=tc)
    return img


# ---------------------------------------------------------------- 7) home
def render_home(skin, S):
    if skin == "old":
        img = A.mesh((BASE_W * S, BASE_H * S))
        label_c = A.OLD["ink"]
        clock_c = A.OLD["ink"]
    else:
        img = Image.new("RGB", (BASE_W * S, BASE_H * S), A.APEX["bg"])
        A.glow_under(img, box([430, -30, 680, 170], S), A.APEX["glow"],
                     blur=28 * S, alpha=70)
        label_c = A.APEX["ink"]
        clock_c = A.APEX["ink"]
    d = ImageDraw.Draw(img, "RGBA")
    # đồng hồ góc phải trên
    A.text_r(d, sc(628, S), sc(12, S), "21:47", A.font(16 * S, True), clock_c)
    # lưới icon 5 cột x 2 hàng, ô 76 (pitch), icon 52
    icon = 52
    pitch_x, pitch_y = 100, 118
    total_w = 4 * pitch_x + icon
    gx0 = (640 - total_w) / 2
    gy0 = 58
    for idx, app in enumerate(APPS_HOME):
        r, c = divmod(idx, 5)
        cx = gx0 + c * pitch_x + icon / 2
        cy = gy0 + r * pitch_y + icon / 2
        if app[1] is None:  # ô DuoCar / OmniCar
            sz = sc(icon, S)
            icon_img = A.home_icon_old(sz) if skin == "old" else A.home_icon_apex(sz)
            mask = Image.new("L", (sz, sz), 0)
            ImageDraw.Draw(mask).rounded_rectangle([0, 0, sz, sz],
                                                   radius=int(sz * 0.24), fill=255)
            img.paste(icon_img, (int(sc(cx, S) - sz / 2), int(sc(cy, S) - sz / 2)), mask)
            d = ImageDraw.Draw(img, "RGBA")
            name = "OmniCar" if skin == "old" else "DuoCar"
        else:
            draw_app_tile(img, sc(cx, S), sc(cy, S), sc(icon, S), app)
            d = ImageDraw.Draw(img, "RGBA")
            name = app[0]
        A.text_c(d, sc(cx, S), sc(cy + icon / 2 + 6, S), name, A.font(11 * S), label_c)
    return img


# ---------------------------------------------------------------- 8) startup
def render_startup(skin, S):
    if skin == "old":
        img = A.vgrad((BASE_W * S, BASE_H * S), A.OLD["deep1"], A.OLD["deep2"])
        d = ImageDraw.Draw(img, "RGBA")
        A.draw_logo_old(d, sc(320, S), sc(132, S), sc(54, S))
        d = ImageDraw.Draw(img, "RGBA")
        A.text_c(d, sc(320, S), sc(204, S), "OmniCar", A.font(28 * S, True), (255, 255, 255))
        # 3 chấm tải
        for i in range(3):
            cx = 320 + (i - 1) * 22
            r = sc(5, S)
            col = (255, 255, 255, 255) if i == 1 else (255, 255, 255, 110)
            d.ellipse([sc(cx, S) - r, sc(272, S) - r, sc(cx, S) + r, sc(272, S) + r], fill=col)
    else:
        img = Image.new("RGB", (BASE_W * S, BASE_H * S), A.APEX["bg"])
        A.glow_under(img, box([190, 42, 450, 222], S), A.APEX["glow"],
                     blur=26 * S, alpha=110)
        d = ImageDraw.Draw(img, "RGBA")
        A.draw_logo_apex(d, sc(320, S), sc(132, S), sc(54, S))
        A.text_c(d, sc(320, S), sc(200, S), "DUOCAR", A.font(30 * S, True), A.APEX["ink"])
        A.text_c(d, sc(320, S), sc(238, S), "A P E X", A.font(13 * S, True), A.APEX["accent"])
        # thanh tiến trình mảnh cyan 40%
        bar = box([240, 272, 400, 276], S)
        A.rr(d, bar, sc(2, S), fill=A.APEX["line"] + (255,))
        fill_w = 240 + 160 * 0.40
        A.rr(d, box([240, 272, fill_w, 276], S), sc(2, S), fill=A.APEX["accent"] + (255,))
    return img


# ---------------------------------------------------------------- điều phối
RENDERERS = {
    "split": render_split,
    "hosted": render_hosted,
    "picker-native": render_picker_native,
    "picker-hosted": render_picker_hosted,
    "fullscreen": render_fullscreen,
    "keyboard": render_keyboard,
    "home": render_home,
    "startup": render_startup,
}


def render(state, skin, S):
    img = RENDERERS[state](skin, S)
    A.caption(img, A.CAPTION_BEFORE if skin == "old" else A.CAPTION_AFTER)
    return img


def main():
    out = os.path.abspath(OUT_DIR)
    made = []
    for state in STATES:
        for skin, suffix in (("old", "truoc"), ("apex", "sau")):
            for S, stag in ((1, ""), (2, "-2x")):
                fn = f"carplay-{state}-{suffix}{stag}.png"
                path = os.path.join(out, fn)
                render(state, skin, S).save(path)
                made.append(path)
                print(f"{fn}  {os.path.getsize(path)} bytes")
    print(f"TOTAL {len(made)} files -> {out}")


if __name__ == "__main__":
    main()
