# S1 — KHUNG PHIEN YTZ5HL1 (chi-doc tren log)

Nguon: `OmniCar.log.old` (2.102.266 B, 9.204 dong, 17:40:49.361–20:36:45.417)
va `OmniCar.log` (965.241 B, 5.112 dong, 20:36:45.744–20:52:18.322).
Tong 14.316 dong. Moi so dem bang grep/awk tren file goc, ngay 2026-11-09.
Nhan: LOG-CONFIRMED = log chung minh; LOG-CONTRADICTS = log phu nhan;
NO-DATA = log khong co du lieu.

## 1. BANG MOC THE HE (khung cho 4 strand khac)

| Doan | File:dong | PID chinh | Tu – Den | Dong |
|---|---|---|---|---|
| A: phien cu (ytz4, theo de bai) | old 1–2477 | SB 36056/36137/36167/36240, CP 36057/36136/36168 | 17:40:49.361 – 17:49:22.802 | 2.477 |
| B: ytz5hl1 pha 1 | old 2478–9204 + log 1–1016 | SB 36658, CP 36683 | 20:18:10.158 – 20:39:50.929 | 6.727 + 1.016 |
| C: ytz5hl1 pha 2 (sau doi PID) | log 1017–5112 | SB 36711, CP 36712 | 20:39:56.347 – 20:52:18.322 | 4.096 |

Ranh gioi A|B nam GIUA old:2477 va old:2478, kem khoang trong log
2:28:48 (xem muc 6). Ranh gioi B|C nam tai log:1017.

### Moc bat dau the he ytz5hl1 (theo thu tu thoi gian)

- `20:18:10.158 [SpringBoard:36658] AppBridge: loaded into SpringBoard`
  (old:2478) — dong dau tien cua the he moi.
- `20:18:14.716 [SpringBoard:36658] AppBridge: build 1.0.3 (fbebb21)
  loaded into SpringBoard [fixround7]` (old:2486).
- `20:18:43.414 [CarPlay:36683] SpeedBubble: loaded into CarPlay`
  (old:2499) — CarPlay cua the he moi.
- `20:18:43.421 [CarPlay:36683] SplitScreen: [home-launch]
  phase=tap-gate ...` (old:2500) — [home-launch] DAU TIEN; doan A co 0.
- `20:18:50.650 [CarPlay:36683] [pinch1] recognizer attached`
  (old:2766) — [pinch1] dau tien cua B.
- `20:24:44.418 [CarPlay:36683] [kbstate] accept slot=0 ... gen=3
  session=2089400554 seq=1` (old:3415) — [kbstate] DAU TIEN; doan A co 0.
- `20:27:39.611 [SpringBoard:36658] [ytz5-k5] cong ban phim doi:
  native (prefschanged)` (old:5097) — tag ytz5 dau tien.

### Diem can luu y ve dinh danh the he

- LOG-CONTRADICTS gia thuyet "dong [pinch1] migration": grep
  `migration` = 0 o ca hai file; khong co dong nao chua chu nay.
  [pinch1] cung KHONG phai dau rieng cua ytz5hl1: doan A da co 5 dong
  [pinch1], dau tien `17:42:54.249 [CarPlay:36136]` (old:698).
- LOG-CONFIRMED dau rieng cua B so voi A: [home-launch] (A=0, B+C=121),
  [kbstate] (A=0, B+C=1.430), [ytz5-k5] (A=0, B+C=7).
- NO-DATA dinh danh binary bang chuoi build: ca A va B/C deu ghi
  `build 1.0.3 (fbebb21) [fixround7]` (old:493, old:2486, log:1113).
  Chuoi build KHONG phan biet duoc hai the he; chi PID + moc thoi
  gian + cac tag rieng tren moi phan biet duoc.
- NO-DATA SHA deb: grep `e28883` = 0 hai file; SHA e28883b9 chi co
  trong de bai, khong co trong log.

## 2. BAN DO PID (dong dem theo tien trinh:PID, chi dong co tien to)

Dong khong tien to (dong tiep cua dump DIAG nhieu dong): old 541,
log 110 — khong thuoc PID nao, cac strand khac dung dem theo tien to
thi phai cong phan nay vao tong dong cua file.

### Doan A — phien cu (old 1–2477)

| Tien trinh:PID | Tu – Den | Dong |
|---|---|---|
| SpringBoard:36056 | 17:40:49.361 – 17:41:11.019 | 26 |
| CarPlay:36057 | 17:40:49.364 – 17:42:27.226 | 312 |
| GOFA:36100 | 17:40:54.652 – 17:42:19.750 | 16 |
| YouTube:36097 | 17:40:56.376 – 17:41:11.113 | 14 |
| Preferences:36132 | 17:42:31.757 (1 dong) | 1 |
| CarPlay:36136 | 17:42:36.800 – 17:43:37.731 | 501 |
| SpringBoard:36137 | 17:42:37.128 – 17:43:04.011 | 46 |
| YouTube:36159 | 17:43:00.664 – 17:43:04.043 | 10 |
| GOFA:36161 | 17:43:08.547 – 17:43:35.130 | 10 |
| Preferences:36165 | 17:43:21.034 (1 dong) | 1 |
| CarPlay:36168 | 17:43:40.691 – 17:48:47.457 | 1.135 |
| SpringBoard:36167 | 17:43:41.063 – 17:48:58.229 | 48 |
| YouTube:36189 | 17:44:02.217 – 17:44:20.379 | 10 |
| GOFA:36191 | 17:44:22.964 – 17:44:27.372 | 8 |
| GOFA:36226 | 17:46:22.905 – 17:48:47.975 | 22 |
| SpringBoard:36240 | 17:49:06.537 – 17:49:22.802 | 21 |

Log mo dau GIUA phien A: dong 1 la MILESTONE cua SB:36056, khong co
dong "loaded into" cho cap SB:36056/CP:36057. Trong A, CarPlay doi
PID 2 lan (36057→36136→36168), SpringBoard doi 3 lan
(36056→36137→36167→36240); SB:36240 chay mot minh 17:49:06–17:49:22
sau khi CP:36168 da ngung o dong `screen disconnected` 17:48:47.457
(old:2452).

### Doan B — ytz5hl1 pha 1 (old 2478–9204 + log 1–1016)

| Tien trinh:PID | Tu – Den | Dong (old + log) |
|---|---|---|
| SpringBoard:36658 | 20:18:10.158 – 20:39:44.852 | 252 + 34 |
| CarPlay:36683 | 20:18:43.414 – 20:39:50.871 | 5.943 + 899 |
| GOFA:36690 | 20:18:55.764 – 20:34:25.700 | 100 + 0 |
| YouTube:36693 | 20:24:40.417 – 20:39:50.929 | 169 + 58 |
| Preferences:36698 | 20:27:35.401 va 20:36:01.088 | 2 + 0 |
| GOFA:36704 | 20:34:59.476 – 20:39:46.644 | 16 + 20 |

### Doan C — ytz5hl1 pha 2 (log 1017–5112)

| Tien trinh:PID | Tu – Den | Dong |
|---|---|---|
| CarPlay:36712 | 20:39:56.347 – 20:52:18.322 | 3.860 |
| SpringBoard:36711 | 20:39:57.027 – 20:51:37.041 | 39 |
| GOFA:36734 | 20:40:22.062 – 20:51:29.678 | 74 |
| YouTube:36733 | 20:40:23.850 – 20:40:24.585 | 8 |
| GOFA:36742 | 20:51:41.831 – 20:52:06.271 | 10 |

## 3. DO DAI HIEU DUNG CUA PHIEN TEST YTZ5HL1

- LOG-CONFIRMED: tu SB load 20:18:10.158 den dong cuoi 20:52:18.322
  = 34 phut 08 giay. Tu CarPlay load 20:18:43.414 = 33 phut 35 giay.
- Pha 1 (CP:36683): 20:18:43.414–20:39:50.871 = 21 phut 07 giay.
- Pha 2 (CP:36712): 20:39:56.347–20:52:18.322 = 12 phut 22 giay.
- Moc verdict tai xe 20:34 (theo de bai) nam trong PHA 1, truoc su
  kien ngat/ket noi lai man hinh 20:34:19–20:34:56 (muc 4). Log con
  chay 18 phut 18 giay sau 20:34:00. Noi dung verdict khong nam
  trong pham vi S1 → NO-DATA cho doi chieu tung muc verdict; cac
  strand khac phai gan verdict vao pha 1 / truoc 20:39:56.

## 4. DOI PID / SU KIEN TRONG PHIEN YTZ5HL1

### 4.1. Doi PID toan cuc mot lan — 20:39:51–20:39:57 (ranh B|C)

- LOG-CONFIRMED: CarPlay doi PID DUNG 1 lan trong ytz5hl1:
  36683 → 36712. Dong cuoi CP:36683: `20:39:50.871 [CarPlay:36683]
  [touchset] t=308190.532 ... active=0 (empty)` (log:1014). Dong dau
  CP:36712: `20:39:56.347 [CarPlay:36712] SpeedBubble: loaded into
  CarPlay` (log:1017). Chenh 5,476 giay.
- Cung luc: SpringBoard 36658 → 36711 (`20:39:57.027 [SpringBoard:
  36711] AppBridge: loaded into SpringBoard`, log:1105; dong cuoi
  SB:36658 la `20:39:44.852 [ytz5-k5] ...`, log:979). YouTube:36693
  dung o 20:39:50.929 (log:1016), GOFA:36704 dung o 20:39:46.644
  (log:994); app moi xuat hien 20:40:22 (GOFA:36734) va 20:40:23
  (YouTube:36733).
- Ca SB va CP deu co dong "loaded into" + "build 1.0.3 (fbebb21)"
  moi (log:1113–1117, log:1228–1231) → mau hinh giong khoi dong lai
  ca hai tien trinh (respring-like). Chu "respring": grep = 0.
- NO-DATA nguyen nhan: quanh 20:39:44–20:39:57 khong co dong crash,
  exception, SIG*, fatal, "screen disconnected" nao (file log:
  `screen disconnected` = 0 dong). Dong cuoi cua CP:36683 la hoat
  dong cham binh thuong (probe seq=229 hoan tat 20:39:50.871),
  khong co dong bao loi ngay truoc khi dung.

### 4.2. Ngat/ket noi man hinh nhung KHONG doi PID (pha 1)

- `20:27:43.334 [CarPlay:36683] screen disconnected` (old:5148) →
  `20:27:45.754 ... screen connected` (old:5179), cung PID 36683.
- `20:34:19.506 [CarPlay:36683] screen disconnected` (old:8059) →
  `20:34:56.043 ... screen connected` (old:8076), cung PID 36683.
  Trong cua so nay GOFA doi PID: 36690 dung 20:34:25.700, GOFA:36704
  bat dau `20:34:59.476 loaded into GOFA` (old:8149).
- Tong file old: `screen disconnected` = 7, `screen connected` = 7
  (gom ca doan A: 17:44:26, 17:46:18 ×2 cap, 17:48:47); file log = 0.

## 5. NOI LIEU HAI FILE TAI 20:36:45 — LOG-CONFIRMED LIEN TUC

- Dong cuoi file old: `20:36:45.417 [CarPlay:36683] [kb-sync] emit
  ... gen=20 seq=1976` (old:9204).
- Dong dau file log: `20:36:45.744 [GOFA:36704] SpeedBubble: chan
  doan UIWindow ...` (log:1) — sau 0,327 giay.
- Dong CarPlay dau file log: `20:36:46.120 [CarPlay:36683] [wake1]
  bw emit ... gen=20 seq=1977` (log:3) — seq LIEN TIEP 1976→1977,
  cung gen=20.
- [kbstate] cung lien tuc: old seq=626 (20:36:45.416, old:9203) →
  log seq=627 (20:36:46.413, log:6), cung session=2089400554,
  cung hash d3b4e0d.
- Ket luan: rotation file xay ra GIUA phien ytz5hl1 (pha 1), khong
  ho, khong trung lap, khong doi PID tai diem noi.

## 6. LOI TOAN CUC (grep tren ca hai file)

- LOG-CONFIRMED khong co crash that: `exception` (khong phan biet
  hoa thuong) = 0/0 dong; `SIGBUS|SIGSEGV|SIGABRT|SIGKILL` = 0/0;
  `fatal` = 0/0 (thu tu: file old / file log).
- `crash` (khong phan biet hoa thuong) = 3/1 dong nhung ca 4 deu la
  dong DIAG liet ke selector cua dashboard (old:825, old:1539,
  old:2874, log:1402) — duong tinh gia do dump API, khong phai bao
  cao su co.
- `error` = 31/10 dong: phan lon la dump DIAG chua ten selector
  NSError va dong weather `updated in 1.1s (http 200, no error)`
  (old:2497, log:1257). Khong dong nao la loi nghiem trong.
- `fail`/`fault`/`abort`: chu yeu la bo dem `setfail=0 postfail=0`
  (khong co dong nao setfail/postfail khac 0) va chu "default"/ten
  selector trong dump DIAG. Duy nhat 1 dong chua tu khoa cat ngan
  la bao cao phien pinch: `20:27:43.258 [CarPlay:36683] [pinch1]
  session end pairs split complete=0 ... =0 | expanded
  complete=0 ... =0` (old:5143) — ca hai chi so deu 0, tuc khong
  mat du lieu pinch trong phien do.
- Ket luan S1: trong toan bo 14.316 dong khong co bang chung log
  ve crash/exception/fatal o bat ky the he nao.

## 7. SUC KHOE SCENEVIS

Dem grep `[scenevis]`: file old 125 = doan A 56 + doan B 69;
file log 10. Tong ytz5hl1 (B+C) = 79 dong.

- Phan loai B (69, file old): verify 14, going-home 14, detach-bg
  14, attach 10, host-attach 8, host-state-ready 7, invalidate 2.
- Phan loai file log (10): verify 3, detach-bg 2, attach 1,
  host-attach 1, host-state-ready 1, going-home 1, pane-remove 1.
- Bundle (B+C): com.google.Maps 43, com.google.ios.youtube 32,
  com.apple.mobilecal 4.
- Ca bat thuong (dinh nghia: attached=0 / hidden=1 / alpha khac
  1.00): attached=0 co 32/79 dong (B: 28, file log: 4), tat ca deu
  la bundle YouTube o cac su kien host-attach / host-state-ready /
  going-home / detach-bg / invalidate voi scene=nil, vi du:
  `20:24:33.120 [CarPlay:36683] [scenevis] host-attach bundle=
  com.google.ios.youtube slot=0 scene=nil attached=0 inHost=1
  hidden=0 alpha=1.00 window=1`.
- hidden=1: 0/79. alpha khac 1.00: 0/79. Maps va mobilecal: moi
  dong scenevis deu attached=1 (41/41 o doan B file old; file log
  Maps 6/6 attached=1).
- Dong scenevis dau cua B: `20:18:51.433 [CarPlay:36683] [scenevis]
  attach bundle=com.google.Maps slot=0 ... attached=1`; dong cuoi
  cua toan phien: `20:40:17.055 [CarPlay:36712] [scenevis]
  host-state-ready bundle=com.google.ios.youtube slot=1 scene=nil
  attached=0 ...` (log, pha 2). Sau 20:40:17 khong con dong
  scenevis nao du log chay den 20:52:18.

## 8. DO PHU THOI GIAN / KHOANG TRONG >60 GIAY

- LOG-CONFIRMED: ben trong phien ytz5hl1 (20:18:10.158–20:52:18.322,
  xuyen ca hai file) KHONG co khoang trong nao >60 giay giua hai
  dong co timestamp lien tiep.
- Khoang lon nhat trong phien: 27,652 giay luc 20:34:28.333 →
  20:34:55.985 (trong cua so ngat man hinh muc 4.2); cac khoang
  ~20 giay dau phien la chu ky poll 20 giay cua GOFA:36690
  (20:19:00–20:24:21); khoang doi PID 5,476 giay (muc 4.1).
- Khoang trong >60 giay duy nhat o doan A: 107 giay,
  17:44:31.969 → 17:46:18.327, trung su kien `screen disconnected`
  17:44:26.376 (old:1672) va `screen connected` 17:46:18.327
  (old:1679).
- Khoang giua hai the he: 17:49:22.802 → 20:18:10.158 = 2:28:48
  khong co log. Viec cai dat/khoi chay ban moi (neu co) nam trong
  khoang nay → NO-DATA trong log; log chi thay the he moi da chay
  tu 20:18:10.158.
