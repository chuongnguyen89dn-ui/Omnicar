# -*- coding: utf-8 -*-
"""Tuyến A — Nhận diện + Cảnh báo nhiệt — M1 DuoCar APEX (design-only).
Sản phẩm: bang-nhan-dien.png (1680x1300), canh-bao-nhiet.png (1360x1040).
Chỉ dùng apex_style dùng chung. Không sửa apex-wt.
"""
import sys, os
sys.path.insert(0, os.path.expanduser("~/workspace/apex-m1"))
import apex_style as A
from PIL import Image, ImageDraw, ImageFilter

OUT_DIR = os.path.expanduser("~/workspace/apex-m1")
APEX = A.APEX
OLD = A.OLD
INK = APEX['ink']
SUB = APEX['sub']
LINE = APEX['line']
SURF = APEX['surface']
SURF2 = APEX['surface2']
ACCENT = APEX['accent']
GLOWC = APEX['glow']
RED_APEX = A.C('#FF4757')
RED_SRC = (255, 6, 16)
WHITE = (255, 255, 255)

def hexcol(h):
    return A.C(h)

def section_title(d, x, y, text):
    d.text((x, y), text, font=A.font(20, bold=True), fill=INK)
    d.line([x, y + 30, 1640, y + 30], fill=LINE, width=1)

# ============================================================
# SẢN PHẨM 1 — BẢNG NHẬN DIỆN 1680x1300
# ============================================================
def build_brand():
    W, H = 1680, 1300
    img = Image.new('RGB', (W, H), APEX['bg'])
    d = ImageDraw.Draw(img, 'RGBA')

    # ---- 1) Header ----
    # logo APEX lớn bên trái
    A.draw_logo_apex(d, 210, 64, 44)
    d.text((400, 28), "DUOCAR APEX", font=A.font(44, bold=True), fill=INK)
    d.text((402, 84), "BẢNG NHẬN DIỆN · MOCKUP M1 — CHỜ NGUYEN DUYỆT",
           font=A.font(17, bold=True), fill=ACCENT)
    d.line([40, 128, 1640, 128], fill=LINE, width=2)

    # ---- 2) LOGO TRƯỚC / SAU ----
    section_title(d, 40, 136, "LOGO")
    # hộp trái (trước) / phải (sau)
    for (bx0, bx1, tag) in [(40, 820, "TRƯỚC"), (860, 1640, "SAU")]:
        A.rr(d, [bx0, 174, bx1, 296], 14, fill=SURF, outline=LINE, width=1)
        d.text((bx0 + 16, 182), tag, font=A.font(13, bold=True), fill=SUB)
    # TRƯỚC: vòng mesh + play + OmniCar
    A.draw_logo_old(d, 180, 240, 40)
    d.text((248, 216), "OmniCar", font=A.font(30, bold=True), fill=INK)
    d.text((248, 256), "Vòng mesh cầu vồng + tam giác play", font=A.font(14), fill=SUB)
    # SAU: biểu tượng APEX + DUOCAR
    A.draw_logo_apex(d, 1010, 236, 40)
    d.text((1168, 202), "DUOCAR", font=A.font(30, bold=True), fill=INK)
    d.text((1168, 240), "APEX · DIGITAL COCKPIT", font=A.font(15, bold=True), fill=ACCENT)
    d.text((1168, 268), "Biểu tượng hai ô + núm khe chia", font=A.font(13), fill=SUB)
    d.text((40, 302),
           "Chú thích: Biểu tượng = hai ô chia màn + núm ở khe chia — đúng bản chất DuoCar "
           "(luật: logo phải có biểu tượng thật kèm chữ). Đây là ĐỀ XUẤT, chưa chốt.",
           font=A.font(12), fill=SUB)

    # ---- 3) HOME ICON ----
    section_title(d, 40, 326, "HOME ICON — 3 CỠ 150 / 100 / 64")
    # nhãn TRƯỚC / SAU
    d.text((40, 364), "TRƯỚC", font=A.font(15, bold=True), fill=SUB)
    d.text((860, 364), "SAU", font=A.font(15, bold=True), fill=ACCENT)
    # hàng icon: cỡ 150/100/64 canh đáy chung 536 (dán kèm mặt nạ bo góc để không lộ nền đen)
    base_y = 536
    x = 120
    for sz in (150, 100, 64):
        ic = A.home_icon_old(sz)
        mask = Image.new('L', (sz, sz), 0)
        ImageDraw.Draw(mask).rounded_rectangle([0, 0, sz, sz], radius=sz * 0.22, fill=255)
        img.paste(ic, (x, base_y - sz), mask)
        d = ImageDraw.Draw(img, 'RGBA')
        d.text((x, base_y + 6), f"{sz}px", font=A.font(12), fill=SUB)
        x += sz + 70
    x = 940
    for sz in (150, 100, 64):
        ic = A.home_icon_apex(sz)
        img.paste(ic, (x, base_y - sz))
        # vẽ lại nhãn trên draw mới sau paste
        d2 = ImageDraw.Draw(img, 'RGBA')
        d2.text((x, base_y + 6), f"{sz}px", font=A.font(12), fill=SUB)
        x += sz + 70
    d = ImageDraw.Draw(img, 'RGBA')

    # ---- 4) PALETTE ----
    section_title(d, 40, 566, "PALETTE")
    rows = [
        ("Nền chính",        ("solid", "#EEF0FB", "#EEF0FB"),      ("solid", "#101820", "#101820 Graphite")),
        ("Bề mặt / thẻ",     ("solid", "#FFFFFF", "#FFFFFF"),      ("solid", "#1F303D", "#1F303D Slate")),
        ("Bề mặt phụ",       ("dash",  None,     "—"),             ("solid", "#27394A", "#27394A*")),
        ("Nhấn / đang chọn", ("grad",  None,     "#9B87F8 → #5DB4F6"), ("solid", "#61D9F2", "#61D9F2 Electric cyan")),
        ("Phát sáng / shadow", ("solid", "#9B87F8", "tím #9B87F8"), ("solid", "#2EA6BB", "#2EA6BB Teal")),
        ("Chữ chính",        ("solid", "#4A4F80", "#4A4F80"),      ("solid", "#EAF6FB", "#EAF6FB Ice white")),
        ("Chữ phụ",          ("solid", "#7A7EA5", "#7A7EA5"),      ("solid", "#8FA6B3", "#8FA6B3*")),
        ("Viền / đường kẻ",  ("solid", "#CECFE9", "#CECFE9"),      ("solid", "#2C4356", "#2C4356*")),
        ("Nút đóng",         ("solid", "#FF5A5F", "#FF5A5F"),      ("solid", "#FF4757", "#FF4757")),
        ("Đỏ cảnh báo nhiệt", ("solid", "#FF0610", "#FF0610 (≈ trong source)"), ("solid", "#FF4757", "#FF4757 (CHỜ NGUYEN CHỌN — xem canh-bao-nhiet.png)")),
    ]
    # cột: vai trò x40 w300 | cũ x360 w600 | apex x980 w660
    ry = 632
    rh = 25
    d.text((40, ry - 26), "Vai trò", font=A.font(13, bold=True), fill=SUB)
    d.text((360, ry - 26), "CŨ (ô màu + HEX)", font=A.font(13, bold=True), fill=SUB)
    d.text((980, ry - 26), "APEX (ô màu + HEX)", font=A.font(13, bold=True), fill=ACCENT)
    for i, (role, oldc, apexc) in enumerate(rows):
        y0 = ry + i * rh
        if i % 2 == 0:
            A.rr(d, [36, y0 - 2, 1644, y0 + rh - 2], 6, fill=(255, 255, 255, 10))
        d.text((40, y0 + 4), role, font=A.font(14, bold=True), fill=INK)
        for (cx, cell) in [(360, oldc), (980, apexc)]:
            kind, hexv, label = cell
            sw = [cx, y0 + 3, cx + 52, y0 + 21]
            if kind == "solid":
                A.rr(d, sw, 4, fill=hexcol(hexv), outline=LINE, width=1)
            elif kind == "grad":
                g = A.hgrad((52, 18), OLD['g1'], OLD['g2'])
                img.paste(g, (cx, y0 + 3))
                d.rounded_rectangle(sw, radius=4, outline=LINE, width=1)
            else:  # dash
                A.rr(d, sw, 4, outline=SUB, width=1)
                A.text_c(d, cx + 26, y0 + 4, "—", A.font(13, bold=True), SUB)
            d.text((cx + 62, y0 + 3), label, font=A.font(13), fill=INK)
        d = ImageDraw.Draw(img, 'RGBA')
    py_end = ry + len(rows) * rh + 2
    d.text((40, py_end), "* sắc phối suy ra từ token gốc đã khóa", font=A.font(12), fill=SUB)

    # ---- 5) TYPOGRAPHY (trái) + 6) THÔNG SỐ (phải) — hai cột để vừa canvas ----
    ty = py_end + 26
    section_title(d, 40, ty, "TYPOGRAPHY")
    d.text((860, ty), "THÔNG SỐ", font=A.font(20, bold=True), fill=INK)
    d.line([860, ty + 30, 1640, ty + 30], fill=LINE, width=1)
    samples = [
        ("Tiêu đề — 28 Bold", 28, True),
        ("Tiêu đề mục — 22 Bold", 22, True),
        ("Nội dung — 17", 17, False),
        ("Chú thích — 13", 13, False),
        ("Nhãn nhỏ — 11", 11, False),
    ]
    sy = ty + 42
    for label, size, bold in samples:
        d.text((40, sy + 2), label, font=A.font(12, bold=True), fill=SUB)
        d.text((300, sy), "DuoCar APEX chia màn", font=A.font(size, bold=bold), fill=INK)
        sy += max(28, size + 8)
    # Thông số: các chip bên phải
    chips = [
        "Bo góc 15 (cảnh báo) / 14 (thẻ, thanh lệnh) / 12 (ô app)",
        "Stroke 7pt viền ngoài nhiệt · 1.5pt viền trong",
        "Glow teal blur 12 · nhịp pulse 0.75s (0.45 → 1.0)",
        "Khoảng cách 4 / 8 / 12 / 16 / 24",
        "Nút thanh lệnh Ø36 trong thanh 52pt · vùng chạm tối thiểu 44",
        "Handle 34×12, vùng chạm 44×24 (giữ nguyên số đo xe)",
    ]
    cy2 = ty + 42
    for c in chips:
        tw = d.textlength(c, font=A.font(13)) + 28
        A.rr(d, [860, cy2, 860 + tw, cy2 + 28], 14, fill=SURF2, outline=LINE, width=1)
        d.text((874, cy2 + 6), c, font=A.font(13), fill=INK)
        cy2 += 34

    # ---- 7) TRẠNG THÁI COMPONENT ----
    sty = max(sy, cy2) + 8
    section_title(d, 40, sty, "TRẠNG THÁI COMPONENT (phong cách APEX)")
    by = sty + 40
    bw, bh, gap = 296, 54, 24
    bx = 40
    # Mặc định
    A.rr(d, [bx, by, bx + bw, by + bh], 14, fill=SURF2, outline=LINE, width=1)
    A.text_c(d, bx + bw / 2, by + 17, "Mặc định", A.font(17, bold=True), INK)
    bx += bw + gap
    # Đang chọn (glow teal + viền cyan)
    A.glow_under(img, [bx, by, bx + bw, by + bh], GLOWC, blur=12, alpha=130)
    d = ImageDraw.Draw(img, 'RGBA')
    A.rr(d, [bx, by, bx + bw, by + bh], 14, fill=SURF, outline=ACCENT, width=2)
    A.text_c(d, bx + bw / 2, by + 17, "Đang chọn", A.font(17, bold=True), ACCENT)
    bx += bw + gap
    # Đang nhấn (surface tối hơn + thu nhỏ cảm giác: lùi vào 4px)
    A.rr(d, [bx + 4, by + 4, bx + bw - 4, by + bh - 4], 12, fill=A.C('#16222B'), outline=LINE, width=1)
    A.text_c(d, bx + bw / 2, by + 19, "Đang nhấn", A.font(16, bold=True), SUB)
    bx += bw + gap
    # Bị tắt (mờ 40%, chữ xám)
    A.rr(d, [bx, by, bx + bw, by + bh], 14, fill=SURF + (255,))
    # phủ lớp mờ 40%: vẽ lại bằng màu trộn nền
    dim_fill = tuple(int(SURF2[i] * 0.6 + APEX['bg'][i] * 0.4) for i in range(3))
    A.rr(d, [bx, by, bx + bw, by + bh], 14, fill=dim_fill, outline=LINE, width=1)
    A.text_c(d, bx + bw / 2, by + 17, "Bị tắt", A.font(17, bold=True), (120, 135, 145))
    bx += bw + gap
    # Lỗi (viền đỏ, chữ đỏ)
    A.rr(d, [bx, by, bx + bw, by + bh], 14, fill=SURF, outline=RED_APEX, width=2)
    A.text_c(d, bx + bw / 2, by + 17, "Lỗi", A.font(17, bold=True), RED_APEX)

    # ---- 8) Footer ----
    fy = H - 34
    d.line([40, fy - 8, 1640, fy - 8], fill=LINE, width=1)
    A.text_c(d, W / 2, fy, "Mockup M1 — đề xuất thiết kế chờ duyệt, không phải runtime/device. Tông APEX khóa theo Issue #1 mục B.",
             A.font(12), SUB)
    img.save(os.path.join(OUT_DIR, "bang-nhan-dien.png"))
    print("bang-nhan-dien.png OK", img.size)

# ============================================================
# SẢN PHẨM 2 — CẢNH BÁO NHIỆT 1360x1040
# ============================================================
def draw_split_scene(img, x, y, w=640, h=360):
    A.draw_map_pane(img, [x, y, x + w // 2, y + h])
    A.draw_video_pane(img, [x + w // 2, y, x + w, y + h])

def double_frame(img, box, color, glow=True):
    """Viền đôi HL61: ngoài inset 5 dày 7 + glow; trong inset 12 dày 1.5 alpha 65%."""
    x0, y0, x1, y1 = box
    # LƯU Ý: glow phải vẽ TRƯỚC cảnh (glow_under tô cả vùng sẽ nhuộm hồng nội dung).
    # Hàm này chỉ vẽ 2 viền; nơi gọi tự vẽ glow_under trước khi vẽ cảnh.
    d = ImageDraw.Draw(img, 'RGBA')
    A.rr(d, [x0 + 5, y0 + 5, x1 - 5, y1 - 5], 15, outline=color + (255,), width=7)
    # viền trong trên lớp riêng để giữ alpha
    layer = Image.new('RGBA', img.size, (0, 0, 0, 0))
    ld = ImageDraw.Draw(layer)
    ld.rounded_rectangle([x0 + 12, y0 + 12, x1 - 12, y1 - 12], radius=12,
                         outline=color + (166,), width=2)
    img.paste(Image.alpha_composite(img.convert('RGBA'), layer).convert('RGB'), (0, 0))

def center_warn_text(img, box, text, size=28):
    x0, y0, x1, y1 = box
    d = ImageDraw.Draw(img, 'RGBA')
    f = A.font(size, bold=True)
    tw = d.textlength(text, font=f)
    tx, tyy = (x0 + x1) / 2 - tw / 2, (y0 + y1) / 2 - size / 2
    d.text((tx + 2, tyy + 2), text, font=f, fill=(0, 0, 0, 200))
    d.text((tx, tyy), text, font=f, fill=WHITE)

def build_thermal():
    W, H = 1360, 1040
    img = Image.new('RGB', (W, H), APEX['bg'])
    d = ImageDraw.Draw(img, 'RGBA')
    A.text_c(d, W / 2, 22, "CẢNH BÁO NHIỆT (A1) — TRƯỚC / SAU", A.font(30, bold=True), INK)
    A.text_c(d, W / 2, 64,
             "Giữa màn chỉ có MỘT dòng chữ. Không chữ 'giả lập', không số nhiệt độ trên lớp cảnh báo.",
             A.font(15), SUB)

    LX, RX, PY, PW, PH = 20, 700, 138, 640, 360
    # nhãn panel trên
    d.text((LX, 106), "TRƯỚC — DC60CL (bị FAIL trên xe)", font=A.font(16, bold=True), fill=RED_APEX)
    d.text((RX, 106), "SAU — dạng viền HL61 theo tông APEX", font=A.font(16, bold=True), fill=ACCENT)

    # --- Panel TRÁI (fail): cảnh + rèm đỏ 87% + chữ thừa ---
    draw_split_scene(img, LX, PY, PW, PH)
    d = ImageDraw.Draw(img, 'RGBA')
    overlay = Image.new('RGBA', (PW, PH), RED_SRC + (222,))  # alpha ≈87%
    img.paste(Image.alpha_composite(
        img.crop((LX, PY, LX + PW, PY + PH)).convert('RGBA'), overlay).convert('RGB'), (LX, PY))
    d = ImageDraw.Draw(img, 'RGBA')
    A.text_c(d, LX + PW / 2, PY + 118, "NHIỆT ĐỘ THIẾT BỊ CAO", A.font(30, bold=True), WHITE)
    A.text_c(d, LX + PW / 2, PY + 168, "37°C", A.font(24, bold=True), WHITE)
    A.text_c(d, LX + PW / 2, PY + 204, "(Đang giả lập)", A.font(16), WHITE)
    d.text((LX, PY + PH + 10), "Ghi chú: Rèm đỏ đục 87%, che mất hai ô, chữ thừa.",
           font=A.font(14), fill=SUB)

    # --- Panel PHẢI (sau): glow trước, cảnh rõ, viền đôi + 1 dòng chữ ---
    A.glow_under(img, [RX - 2, PY - 2, RX + PW + 2, PY + PH + 2], RED_APEX, blur=14, alpha=110)
    draw_split_scene(img, RX, PY, PW, PH)
    double_frame(img, [RX, PY, RX + PW, PY + PH], RED_APEX, glow=False)
    center_warn_text(img, [RX, PY, RX + PW, PY + PH], "LÀM MÁT THIẾT BỊ CỦA BẠN", size=28)
    d = ImageDraw.Draw(img, 'RGBA')
    note_r = ("Ghi chú: Chỉ viền phát sáng nhấp nháy (pulse 0.75s), hai ô vẫn thấy và bấm được\n"
              "(xuyên chạm giữ nguyên). Màu viền tạm dùng #FF4757 — lựa chọn cuối ở dưới.")
    for i, ln in enumerate(note_r.split("\n")):
        d.text((RX, PY + PH + 10 + i * 20), ln, font=A.font(14), fill=SUB)

    # --- Hàng dưới: so màu 2 lựa chọn, panel 640x300 ---
    BY = 604
    d.text((LX, BY - 46), "Lựa chọn 1 — Đỏ đang có trong source HL61 ≈ #FF0610 (RGB 1.0 · 0.025 · 0.065)",
           font=A.font(13, bold=True), fill=INK)
    d.text((RX, BY - 46), "Lựa chọn 2 — Đỏ APEX #FF4757", font=A.font(13, bold=True), fill=INK)
    for (px, col) in [(LX, RED_SRC), (RX, RED_APEX)]:
        # glow vẽ trước cảnh để không nhuộm nội dung
        A.glow_under(img, [px - 2, BY - 2, px + PW + 2, BY + 302], col, blur=14, alpha=110)
        d = ImageDraw.Draw(img, 'RGBA')
        # cảnh tối đơn giản: nền graphite + 2 ô mờ
        d.rectangle([px, BY, px + PW, BY + 300], fill=APEX['bg'])
        d.rounded_rectangle([px + 24, BY + 30, px + PW // 2 - 8, BY + 270], radius=12,
                            fill=SURF, outline=LINE, width=1)
        d.rounded_rectangle([px + PW // 2 + 8, BY + 30, px + PW - 24, BY + 270], radius=12,
                            fill=SURF2, outline=LINE, width=1)
        double_frame(img, [px, BY, px + PW, BY + 300], col, glow=False)
        center_warn_text(img, [px, BY, px + PW, BY + 300], "LÀM MÁT THIẾT BỊ CỦA BẠN", size=20)
        d = ImageDraw.Draw(img, 'RGBA')

    # --- Dòng chốt ---
    fy = BY + 300 + 34
    A.rr(d, [20, fy - 8, W - 20, fy + 52], 14, fill=SURF, outline=RED_APEX, width=2)
    A.text_c(d, W / 2, fy + 8, "CẦN NGUYEN CHỌN: đỏ nào dùng cho A1 và cho nút đóng (D1)?",
             A.font(20, bold=True), INK)
    A.text_c(d, W / 2, fy + 74,
             "Mockup M1 — đề xuất thiết kế chờ duyệt, không phải runtime/device.",
             A.font(13), SUB)
    img.save(os.path.join(OUT_DIR, "canh-bao-nhiet.png"))
    print("canh-bao-nhiet.png OK", img.size)

if __name__ == "__main__":
    build_brand()
    build_thermal()
