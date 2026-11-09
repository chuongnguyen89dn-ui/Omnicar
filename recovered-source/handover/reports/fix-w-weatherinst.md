# FIX-W-WEATHERINST — Instrument đường Weather request → answer → display (WO GPT mục 4b)

Mức đạt: **source complete / build PASS / static PASS** (chưa có bằng chứng xe — instrument này chính là thứ tạo ra bằng chứng đó ở phiên sau).
Phạm vi: chỉ cộng log có id tương quan, **không đổi bất kỳ hành vi nào**. Module duy nhất bị đụng: `OmniCarStartupScreen` (cả hai đầu của đường thời tiết đều sống trong module này).

## 0. File đã đụng (project/ + mirror src/StartupScreen/, cmp identical sau sửa)

| File | Vai trò trên đường thời tiết |
|---|---|
| `OmniCarStartupScreen/SSSplash.m` | Đầu YÊU CẦU + đầu ÁP KẾT QUẢ (process CarPlayApp): `-refreshWeather`, ready-handler, apply block, cache khởi tạo |
| `OmniCarStartupScreen/SSStartupScreen.m` | Đầu TRẢ LỜI (process SpringBoard): Darwin callback, `SSAnswerWeatherRequest`, `SSFetchAndAnswer`, `SSNotifyWeatherReady`, warming lúc khởi động |
| `OmniCarStartupScreen/SSStartupView.m` | Điểm HIỂN THỊ thật: `-reload` — nơi dict thời tiết biến thành category + gradient trên màn |

## 1. SỰ THẬT VỀ ID QUA KÊNH (kết luận cốt lõi của vòng này)

**Kênh `com.anlai.omnicar/startupscreen.weather.request` KHÔNG mang id.**
- Phía phát (SSSplash.m, bản gốc): `notify_post("com.anlai.omnicar/startupscreen.weather.request")` — notify thuần, không payload, không notify state.
- Phía nhận (SSStartupScreen.m, bản gốc): `CFNotificationCenterAddObserver` trên Darwin center; callback `SSWeatherRequestDarwinCallback` chỉ `dispatch_async` gọi `SSAnswerWeatherRequest()` — không có bất kỳ dữ kiện nào về requester.
- Phía CarPlay vốn đã có một bộ đếm tương quan nội bộ: `SSWeatherGeneration` (SSSplash.m, `@0x3b19c`) — tăng mỗi lần ask, dùng cho guard retry/timeout. **Nó không bao giờ được truyền qua kênh.**

Hệ quả: vòng này KHÔNG gắn được id đầu-cuối thật (muốn vậy phải đổi giao thức — ngoài phạm vi). Thay vào đó, instrument dùng **hai bộ đếm log-only độc lập theo process**, tương quan bằng **thứ tự + timestamp** (mọi dòng OMCLogWrite đều có timestamp của log writer):
- `req#` — phía CarPlayApp (`SSWeatherReqLogSeq`, SSSplash.m:348): tăng mỗi lần `-refreshWeather` chạy.
- `ans#` — phía SpringBoard (`SSWeatherAnsLogSeq`/`SSWeatherCurAnsSeq`, SSStartupScreen.m:708–709): tăng mỗi lần `SSAnswerWeatherRequest` được vào (kể cả lần bị loại vì in-flight).
Cả hai bộ đếm **chỉ** được đọc bởi các dòng log cộng thêm; không logic nào đọc chúng, không guard nào phụ thuộc chúng (đã kiểm bằng diff: xem §5).

## 2. BẢN ĐỒ ĐƯỜNG ĐI + ĐIỂM LOG ĐÃ CỘNG (file:line theo cây sau sửa)

### 2.1 Đầu yêu cầu — CarPlayApp (SSSplash.m, `-refreshWeather`)
| Điểm | Dòng | Log cộng |
|---|---|---|
| Vào refreshWeather (mọi nhánh) | :352–353 | `[weather] req#%d begin t=%.3f` (t = CACurrentMediaTime) |
| Nhánh ask-SpringBoard (status ∉ {3,4}) | :410, :412 | mirror log-only `SSWeatherPendingReqLogSeq = wxReq`; `[weather] req#%d gen=%d ask-springboard (darwin post; channel carries no id)` ngay trước `notify_post` |
| Retry +2s/+5s (guard generation + pending còn nguyên) | :426 | `[weather] req#%d gen=%d retry-post (+%@s, same ask re-posted)` — retry là CÙNG một ask phát lại, không phải ask mới |
| Timeout 10s | :438 | `[weather] req#%d gen=%d timeout-no-answer` |
| Ready-handler (đăng ký 1 lần, sub_8aa4) | :401 | `[weather] answer-received for req#%d gen=%d cacheTemp=%@` — nêu đích danh req# đã lưu pending completion + temp đọc được từ cache |
| Nhánh direct-fix (status ∈ {3,4}, có fix) | :446 | `[weather] req#%d source=direct-fix (self-answered in-process, no SpringBoard ask)` — request tự trả lời trong CarPlayApp, SpringBoard không tham gia |
| Nhánh không có fix | :450 | `[weather] req#%d source=none (no last fix; nothing fresh applied)` |

### 2.2 Đầu trả lời — SpringBoard (SSStartupScreen.m)
| Điểm | Dòng | Log cộng |
|---|---|---|
| Darwin callback nhận request | :859 | `[weather] request received via darwin notify (channel carries no request id)` |
| Warming lúc khởi động (+15s, constructor) | :402 | `[weather] source=warming-cache (internal startup call, NOT a CarPlay request)` — đặt cạnh dòng gốc `weather: warming the cache at startup` |
| Vào `SSAnswerWeatherRequest` | :744, :752 | `ans#%d begin` (sau khi qua in-flight guard; `SSWeatherCurAnsSeq` được gán tại đây) |
| Bị loại vì đang trả lời dở | :747 | `[weather] ans#%d dropped reason=in-flight (…correlation by order/time only)` |
| `SSFetchAndAnswer` (mọi nhánh fetch: last fix / fresh one-shot / stored nav / IP) | :724 | `[weather] ans#%d fetch-begin source=%@` — source là nhãn vị trí gốc của code (`last CoreLocation`, `fresh CoreLocation`, `nav app's (… min old)`, `IP (…)`) |
| Nhánh không có vị trí nào | :848 | `[weather] ans#%d answered-without-weather (ready posted with no fresh temp/gradient)` |
| `SSNotifyWeatherReady` (điểm phát ready duy nhất) | :719 | `[weather] ans#%d ready-posted` |
| Hoàn tất fetch | (dòng gốc, không sửa) | `weather: updated/failed in %.1fs (http %ld, …)` của `SSWeatherFetch` nằm giữa `fetch-begin` và `ready-posted` của cùng ans# — tương quan theo thứ tự |

### 2.3 Điểm hiển thị — CarPlayApp (SSSplash.m + SSStartupView.m)
| Điểm | Dòng | Log cộng |
|---|---|---|
| Apply block (mọi completion chạm tới đường hiển thị, kể cả nil) | :360 | `[weather] applied req#%d temp=%@ code=%@ isDay=%@ dataAge=%.0fs` — temp=`none` ⇒ không có nhiệt độ thật được áp; dataAge = tuổi của dict theo trường `date` (−1 nếu không có) |
| `-reload` của SSStartupView, ngay sau khi tính `_sky` (style 3) | :271 | `[weather] display category=%ld isDay=%d temp=%@ code=%@ (gradient re-selected from category)` — đây là nơi dict biến thành category ngày/đêm + gradient thật trên màn |
| Cache lúc khởi tạo splash (KHÔNG phải answer) | SSSplash.m:164 | `[weather] display source=initial-cache (startup cache load, NOT a request answer)` |

### 2.4 Chuỗi bằng chứng một request thật sẽ để lại trong log phiên sau
`req#N begin` → `req#N gen=G ask-springboard` → (SB) `request received via darwin notify` → `ans#M begin` → `ans#M fetch-begin source=…` → `weather: updated in … (http 200…)` → `ans#M ready-posted` → (CP) `answer-received for req#N gen=G cacheTemp=…` → `applied req#N temp=… isDay=… dataAge=…` → `display category=… isDay=…`.
Chuỗi warming **không có** các dòng `req#` — nó bắt đầu bằng `source=warming-cache` → `ans#M begin` → … Đây chính là cách phân biệt hai loại transaction trong log, thay cho nhãn "warming cache" nhập nhằng trước đây.

## 3. PHÂN BIỆT NGUỒN — ĐƯỢC VÀ CHƯA ĐƯỢC

**Phân biệt được (từ vòng này):**
- Warming-cache vs request-thật-từ-CarPlay: warming có nhãn `source=warming-cache` và không có `req#` đi kèm; request thật luôn mở đầu bằng `req# begin` phía CarPlayApp. (Trước vòng này, hai loại chỉ phân biệt được nhờ đúng một dòng chữ "warming the cache at startup" ở constructor, còn thân transaction thì giống hệt nhau — đúng như GPT hiệu chỉnh về 5 transaction trong log ytz2.)
- Ask-SpringBoard vs direct-fix vs none: nhãn `source=` ngay tại `req#`.
- Answer có nhiệt độ thật vs answer rỗng: `fetch-begin` + dòng fetch gốc (http) + `ready-posted` phía SB; `applied … temp=` phía CP; `answered-without-weather` khi SB không có vị trí nào.

**Chưa phân biệt được (giới hạn cấu trúc của kênh, ghi rõ):**
- Phía SpringBoard **không** phân biệt được post gốc của một ask với **retry-post** (+2s/+5s) của cùng ask đó: cả hai đều là notify trần giống hệt nhau. Mỗi post vào `SSAnswerWeatherRequest` đều ăn một ans#; post đến trong lúc in-flight sẽ hiện `dropped reason=in-flight`. Vì vậy ánh xạ req#↔ans# là **theo thứ tự thời gian**, không phải 1-1 tuyệt đối: N ask có thể sinh nhiều hơn N ans# (do retry), và nhiều ask chồng nhau có thể gộp còn một answer (in-flight guard + single pending slot — đều là thiết kế gốc, không đổi).
- `SSWeatherGeneration` (gen=) chỉ có nghĩa phía CarPlayApp; phía SpringBoard không thấy nó.

## 4. ĐỀ XUẤT GẮN ID TỐI THIỂU CHO VÒNG SAU (chưa làm — chờ GPT duyệt, vì đây là đổi giao thức)

Mang generation qua **notify state** của chính kênh request — mẫu này đã có sẵn trong cùng file: kênh `com.anlai.omnicar/location` dùng `notify_register_dispatch` + `notify_get_state` để chở dữ kiện (SSStartupScreen.m, constructor SpringBoard).
- Phía phát: trước `notify_post`, `notify_set_state(token, generation)` trên kênh weather.request (cần một notify token đăng ký một lần phía CarPlayApp).
- Phía nhận: đổi Darwin-center observer thành `notify_register_dispatch` trên cùng tên kênh, đọc `notify_get_state` trong handler rồi truyền gen vào `SSAnswerWeatherRequest` (thêm một tham số nội bộ).
- Không thêm kênh mới, không đổi định dạng dữ kiện nào khác; tương quan req#↔ans# thành tuyệt đối theo gen.

## 5. CỔNG ĐÃ CHẠY

- **Diff thuần cộng:** đối chiếu với bản gốc chụp trước khi sửa — cả 3 file: **0 dòng bị xoá/sửa**; chỉ cộng 18 (SSStartupScreen.m) + 26 (SSSplash.m) + 7 (SSStartupView.m) dòng. Mọi dòng cộng là: `OMCLogWrite` [weather], comment đánh dấu `[weatherinst]`, khai báo 4 static counter log-only, và 3 phép gán/increment **chỉ** trên các counter đó (`++SSWeatherReqLogSeq`, `++SSWeatherAnsLogSeq`, `SSWeatherCurAnsSeq = ansSeq`, `SSWeatherPendingReqLogSeq = wxReq`). Không một dòng logic/guard/notify/fetch nào thay đổi — toàn bộ guard generation, in-flight, timeout 6s/10s, TTL và nhánh W1–W8 giữ nguyên từng chữ.
- **Build:** module `OmniCarStartupScreen` `make clean && make` exit 0, link + ký xong; warning còn lại đều là pre-existing (deprecated `authorizationStatus`/`setScreen:`, incomplete-implementation đã được demote trong Makefile module) — không warning nào rơi trên dòng cộng thêm.
- **Binary:** dylib sau build chứa đủ **17/17** format string `[weather] …` đã cộng.
- **Mirror:** 3 file ở `src/StartupScreen/` identical với `project/` sau sửa (cmp).

## 6. GIỚI HẠN CÒN LẠI

1. req#/ans# reset khi process khởi động lại — tương quan xuyên respring chỉ còn dựa vào timestamp.
2. Dòng hoàn tất fetch gốc (`weather: updated/failed …`) cố ý KHÔNG gắn id: `SSWeatherFetch` là code dùng chung hai process (gắn ans# vào đó sẽ sai process ở nhánh direct-fix). Nó được kẹp giữa `fetch-begin` và `ready-posted` của cùng ans# nên vẫn truy được.
3. `applied` ghi tại apply block của SSSplash — nếu splash đã finished, block vẫn log `applied` rồi mới bail ở guard gốc (log nói "completion chạm tới đường hiển thị", việc render thật được xác nhận bởi dòng `display category=` của view ngay sau đó; đọc cặp đôi này cùng nhau).
4. Câu hỏi gốc của GPT — "request từ CarPlay đã nhận answer và hiển thị nhiệt độ/gradient chưa" — chỉ trả lời được ở **phiên xe sau** khi log có các dòng [weather] mới; vòng này chỉ tạo ra khả năng trả lời đó.
