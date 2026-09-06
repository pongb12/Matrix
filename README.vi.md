<div align="center">

# Matrix

**Desktop Hyprland nhẹ nhàng, phong cách caelestia — xây dựng cho phần cấu hình thấp.**

*Toàn bộ là dotfiles thuần, không dùng shell framework, không daemon ẩn. Mọi thành phần đang chạy đều là một tiến trình nhỏ, có thể kiểm tra được.*

[![Hyprland](https://img.shields.io/badge/Hyprland-0.56%2B-7ab3f5)](https://hypr.land)
[![Branch](https://img.shields.io/badge/branch-dev-blue)](../../tree/dev)
[![Installer](https://img.shields.io/badge/install-bash%20%2B%20pacman-green)](install.sh)
[![Idle RAM](https://img.shields.io/badge/RAM%20ch%E1%BB%9D-%E2%89%88500%E2%80%93900%20MB-important)](#hi%E1%BB%87u-n%C4%83ng)

[English](README.md) · **Tiếng Việt**

</div>

---

## Tổng quan

Matrix là một phiên làm việc Hyprland hoàn chỉnh được ghép từ một tập hợp
thành phần C/C++/Rust cố tình giữ ở mức tối giản. Nó tuân theo ba nguyên tắc:

1. **Không có gì nặng nề.** Không blur, không đổ bóng, không shell Qt/QML,
   không Electron. Compositor và thanh trạng thái là hai tiến trình đồ họa
   duy nhất chạy lâu dài.
2. **Không có gì ẩn giấu.** Toàn bộ desktop gồm 14 tệp cấu hình thuần và một
   script bash, được triển khai vào `~/.config/`. Bạn đọc gì là thứ đó chạy.
3. **Không phá hỏng phiên làm việc.** Trình cài đặt không bao giờ xóa hay ghi
   đè bất kỳ thứ gì ngoài 14 tệp do Matrix quản lý, và mọi mục autostart đều
   giảm cấp an toàn nếu chương trình tương ứng không có mặt.

## Tính năng

- **Hyprland** với cấu hình mô-đun (`hyprland.conf` chỉ `source` các tệp trong
  `configs/`), bo góc, viền 2 px màu nhấn, hiệu ứng chuyển động ngắn được tinh
  chỉnh cho iGPU yếu.
- **Chuyển đổi đa màn hình (`Super+P`)** — menu chọn chế độ kiểu Windows với
  4 chế độ: *Chỉ màn hình máy tính*, *Nhân bản*, *Mở rộng*, *Chỉ màn hình
  thứ hai*. Viết bằng bash thuần + `hyprctl`; chế độ được chọn được lưu lại
  và tự khôi phục ở lần đăng nhập sau.
- **Waybar** — thanh trạng thái dạng "viên nổi" với khay hệ thống, vùng làm
  việc, đồng hồ, RAM/CPU và âm lượng.
- **rofi** — trình khởi chạy ứng dụng và menu chọn chế độ màn hình (rofi ≥ 2.0
  hỗ trợ Wayland chính thức).
- **dunst** — thông báo, đồng thời dùng để phản hồi chế độ màn hình.
- **swaybg** hình nền, `wpctl` âm lượng, `brightnessctl` độ sáng,
  `grim`+`slurp` chụp màn hình.
- Toàn bộ chuỗi hiển thị cho người dùng được bản địa hóa bằng **tiếng Việt**.

## Yêu cầu

| Gói | Vai trò |
|---|---|
| `hyprland` | Compositor Wayland (khuyến nghị ≥ 0.56; cấu hình đã kiểm chứng trên 0.56.2) |
| `waybar` | Thanh trạng thái |
| `rofi` | Trình khởi chạy + menu màn hình (bắt buộc bản Wayland: rofi ≥ 2.0 hoặc `rofi-wayland`) |
| `dunst` | Daemon thông báo |
| `swaybg` | Daemon hình nền |
| `kitty` | Terminal (`foot` nhẹ hơn — sửa `$terminal` trong `keybinds.conf` nếu dùng) |
| `brightnessctl`, `grim`, `slurp`, `wl-clipboard` | Độ sáng, chụp màn hình, clipboard |
| `jq` | Tùy chọn — cải thiện nhận diện chế độ hiện tại trong menu Super+P |
| `pipewire`, `wireplumber` | Âm thanh (`wpctl`) |

Tùy chọn: `thunar`, `pavucontrol`, `network-manager-applet`, phông Nerd Font
(khuyến nghị JetBrainsMono), `noto-fonts`. Thiếu gói tùy chọn chỉ khiến phím
tắt hoặc window rule liên quan không có tác dụng.

Cần GPU hỗ trợ Wayland và một display manager (SDDM, greetd, …).

## Cài đặt

### CachyOS

CachyOS hỗ trợ Hyprland chính thức. Có hai con đường, đều kết thúc bằng cùng
bước triển khai Matrix.

#### Cách A — cài CachyOS mới (khuyến nghị)

1. Khởi động ISO CachyOS và mở trình cài đặt.
2. Ở bước chọn môi trường desktop, chọn một trong hai:
   - chọn **Hyprland** (CachyOS sẽ kèm shell của riêng họ — Matrix sẽ ghi đè
     cấu hình compositor ở bước 4; sau đó có thể gỡ các gói shell của CachyOS
     như `cachyos-hypr-noctalia` bằng `pacman -R cachyos-hypr-noctalia` nếu
     muốn hệ thống chỉ còn Matrix), **hoặc**
   - chọn **No Desktop** để có phiên làm việc Matrix "sạch" nhất.
3. Hoàn tất cài đặt, khởi động lại; nếu chọn "No Desktop", đăng nhập vào TTY
   (`Ctrl+Alt+F2`).
4. Cài đặt các gói của phiên làm việc:

   ```bash
   sudo pacman -S --needed hyprland waybar rofi dunst swaybg kitty \
     brightnessctl grim slurp wl-clipboard jq \
     pipewire wireplumber pipewire-pulse thunar pavucontrol \
     network-manager-applet ttf-jetbrainsmono-nerd noto-fonts
   ```

5. Nếu chọn "No Desktop", bật display manager (bỏ qua nếu CachyOS đã cài
   sẵn):

   ```bash
   sudo pacman -S --needed sddm
   sudo systemctl enable sddm
   ```

6. Triển khai Matrix:

   ```bash
   git clone https://github.com/pongb12/Matrix.git
   cd Matrix
   ./install.sh
   ```

7. Đặt hình nền tại `~/Pictures/wallpaper.jpg` (hoặc sửa đường dẫn trong
   `hypr/configs/autostart.conf`), sau đó khởi động lại — **Hyprland** sẽ
   xuất hiện trong danh sách phiên của SDDM.

#### Cách B — CachyOS đã có desktop khác

```bash
sudo pacman -S --needed hyprland waybar rofi dunst swaybg kitty \
  brightnessctl grim slurp wl-clipboard jq pipewire wireplumber
git clone https://github.com/pongb12/Matrix.git
cd Matrix
./install.sh
```

Đăng xuất và chọn **Hyprland** trong display manager. Desktop hiện tại không
bị ảnh hưởng — Matrix chỉ ghi đúng 14 tệp của mình.

#### Cú pháp một lệnh

Trên mọi hệ dùng pacman (CachyOS, Arch, EndeavourOS), `--deps` sẽ thực hiện
bước 4 tự động trước khi triển khai:

```bash
git clone https://github.com/pongb12/Matrix.git && cd Matrix
./install.sh --deps   # cài gói qua pacman (hỏi mật khẩu sudo)
./install.sh          # triển khai cấu hình
```

### Các phân phối khác nền Arch

Giống Cách B. Giả định riêng của Arch chỉ nằm ở tên gói `pacman`; mọi tệp cấu
hình đều độc lập với phân phối.

### Các phân phối khác (không dùng pacman)

Cài các gói theo mục [Yêu cầu](#yêu-cầu) bằng trình quản lý gói của bạn, sau
đó chạy `./install.sh` (việc triển khai cấu hình chạy được ở mọi nơi; chỉ
`--deps` là dành riêng cho pacman).

### Gỡ cài đặt

Xóa các tệp đã triển khai — không có gì khác từng được ghi:

```bash
rm -rf ~/.config/hypr ~/.config/waybar ~/.config/rofi ~/.config/dunst
rm -rf ~/.local/state/matrix   # trạng thái chế độ màn hình, nếu có
```

## Sử dụng

### Phím tắt

| Phím | Chức năng |
|---|---|
| `SUPER + Enter` | Terminal |
| `SUPER + D` | Trình khởi chạy ứng dụng |
| `SUPER + P` | **Menu chọn chế độ màn hình** |
| `SUPER + E` | Trình quản lý tệp (nếu cài) |
| `SUPER + Q` | Đóng cửa sổ |
| `SUPER + F` | Toàn màn hình |
| `SUPER + Space` | Bật/tắt cửa sổ nổi |
| `SUPER + J` | Bật/tắt chia đôi |
| `SUPER + 1..9` | Chuyển vùng làm việc (`SHIFT` di chuyển cửa sổ đang focus) |
| `SUPER + mũi tên` | Di chuyển focus |
| `SUPER + chuột` | Di chuyển / đổi kích thước cửa sổ |
| `Print` / `Shift + Print` | Chụp màn hình (toàn bộ / vùng chọn) |
| Phím âm lượng / độ sáng | `wpctl` / `brightnessctl` |
| `SUPER + M` | Thoát Hyprland |

### Đa màn hình (Super+P)

| Chế độ | Tác dụng |
|---|---|
| **1 · Chỉ màn hình máy tính** | Tắt màn hình ngoài, chỉ dùng màn hình máy tính |
| **2 · Nhân bản** | Hai màn hình hiển thị nội dung giống nhau (thuyết trình) |
| **3 · Mở rộng** | Màn hình thứ hai thành không gian làm việc bổ sung |
| **4 · Chỉ màn hình thứ hai** | Tắt màn hình laptop, chỉ xuất hình ra màn hình ngoài |

Chế độ đang dùng được đánh dấu `●`. Lựa chọn được áp dụng ngay và lưu vào
`~/.config/hypr/configs/displays.conf`; xóa tệp này để quay về chế độ tự nhận
diện. Nếu chưa cắm màn hình thứ hai, hệ thống sẽ hiện thông báo.

## Hiệu năng

RAM khi rảnh của toàn bộ GUI (compositor + thanh trạng thái + thông báo +
hình nền):

| Thành phần | RAM khoảng |
|---|---|
| Hyprland | 250–450 MB |
| waybar | 30–60 MB |
| swaybg | ~10 MB |
| dunst | ~5 MB |
| **Tổng khi rảnh** | **≈ 500–900 MB** |

Nguyên tắc cứng: tắt `blur` và `shadows`, thời lượng animation 2–3, autostart
tối thiểu. Muốn thấp hơn nữa: dùng `foot` thay `kitty`, bỏ `nm-applet` khỏi
`autostart.conf`, tăng giá trị `interval` của waybar.

## Xử lý sự cố

- **Launcher hoặc menu Super+P không mở** — bản rofi của bạn không hỗ trợ
  Wayland. Kiểm tra bằng `rofi -help | grep -i wayland`; trên Arch/CachyOS
  hãy cài `rofi` (≥ 2.0) hoặc `rofi-wayland`.
- **Log nằm ở đâu?** Hyprland ghi log tại
  `/run/user/$UID/hypr/*/hyprland.log`. Phiên bị crash để lại báo cáo trong
  `~/.cache/hyprland/`.
- **Có dòng cấu hình lỗi sau khi cập nhật Hyprland** — Hyprland vẫn chạy và
  hiển thị lớp báo lỗi thay vì không khởi động được. Xem dòng `ERR` trong log
  và sửa tương ứng; phiên làm việc vẫn dùng được.
- **Chế độ màn hình không được lưu** — kiểm tra
  `~/.config/hypr/configs/displays.conf` có tồn tại không; tệp này được ghi
  lại mỗi lần chọn bằng Super+P.
- **Tên màn hình trong menu sai** — tên được nhận diện lúc chạy từ
  `hyprctl monitors` (`eDP-*` là màn hình rời, mọi thứ không phải `HEADLESS`
  được coi là màn hình ngoài), nên không cần cấu hình gì.

## Nhánh phát triển

| Nhánh | Mục đích |
|---|---|
| [`dev`](../../tree/dev) | Nhánh phát triển chính; cấu hình phát hành (nhánh hiện tại) |
| [`test`](../../tree/test) | Bản chụp lịch sử phiên bản thử nghiệm Mint/MATE đầu tiên — đã đóng băng, không dùng |
