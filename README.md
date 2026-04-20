# Screen Toolkit

A unified collection of screen utilities for the **Noctalia Shell**, designed to streamline screenshotting, annotation, recording, and visual inspection workflows.

---

## Overview

![Preview](preview.png)

Screen Toolkit provides a single integrated panel for advanced screen interaction tools, including capture, annotation, OCR, recording, and color analysis.

---

## Included Tools


**Color Picker**
Inspect any pixel and retrieve HEX, RGB, HSV, and HSL values instantly.
![Color Picker](color.png)

**Annotate**
Draw on screenshots using pens, highlights, arrows, shapes, text, and blur effects.
![Annotate](annotate.png)

**Measure**
Measure precise pixel distances using on-screen line tools.
![Measure](measure.png)

**Pin**
Pin screenshots or local media as floating overlays on the screen.
![Pin](pin.png)
**Palette Extraction**
Extract dominant color palettes from selected regions.
![Palette](palette.png)
**OCR**
Extract text from images with multilingual support and translation.
![OCR](ocr.png)

**QR Scanner**
Detect and decode QR codes and barcodes from screen regions.
![QR Scanner](qr.png)

**Google Lens** 
Send a selected region to Google Lens for reverse image search.
                   
**Screen Recorder** 
Record fullscreen or selected regions as MP4 or GIF (with optional audio). 
![Screen Recorder](Record.png)
**Webcam Mirror**
Floating webcam preview with resizing, flipping, and capture support.

---

## Requirements

### Core Dependencies

* `grim` — screenshots
* `slurp` — region selection
* `wl-clipboard` — clipboard integration
* `tesseract` — OCR engine
* `imagemagick` — image processing
* `zbar` — QR/barcode scanning
* `curl` — network requests
* `ffmpeg` — video processing
* `jq` — JSON parsing
* `wl-screenrec` (preferred) or `wf-recorder` (fallback)
* `python3` + PyGObject (system file picker support)
* `xdg-desktop-portal` (File picker for Pin Image/Video)

### Optional Features

* `translate-shell` — OCR translation
* `gifski` — high-quality GIF encoding
* `zenity` / `kdialog` — fallback Pin Image/Video

---

## Installation

### Arch Linux

```bash
sudo pacman -S grim slurp wl-clipboard tesseract tesseract-data-eng imagemagick zbar curl translate-shell ffmpeg jq wl-screenrec python python-gobject xdg-desktop-portal
yay -S gifski
```

### Debian / Ubuntu

```bash
sudo apt install grim slurp wl-clipboard tesseract-ocr tesseract-ocr-eng imagemagick zbar-tools curl translate-shell ffmpeg jq python3 python3-gi xdg-desktop-portal
cargo install gifski
```

### Fedora

```bash
sudo dnf install grim slurp wl-clipboard tesseract tesseract-langpack-eng ImageMagick zbar curl translate-shell ffmpeg jq wl-screenrec python3 python3-gobject xdg-desktop-portal
cargo install gifski
```

### NixOS

```nix
environment.systemPackages = with pkgs; [
  grim slurp wl-clipboard tesseract imagemagick zbar curl
  translate-shell wl-screenrec ffmpeg gifski jq
  python3 python3Packages.pygobject xdg-desktop-portal
];
```

Optional languages for OCR:

```nix
# programs.tesseract.languages = [ "eng" "deu" "fra" ];
```

---

## Compatibility

| Compositor                    | Status          | Notes                         |
| ----------------------------- | --------------- | ----------------------------- |
| **Hyprland**                  | Fully supported | All features enabled          |
| **Niri**                      | Fully supported | Window annotation is disabled |
| **Other Wayland compositors** | Partial support | Feature availability may vary |

---

## Configuration

All settings are configurable via the plugin settings panel.

| Setting                     | Description                               | Default                  |
| --------------------------- | ----------------------------------------- | ------------------------ |
| Screenshot Path             | Directory for screenshots and annotations | `~/Pictures/Screenshots` |
| Video Path                  | Directory for recordings                  | `~/Videos`               |
| Filename Format             | Timestamp template for generated files    | `%Y-%m-%d_%H-%M-%S`      |
| Skip Recording Confirmation | Start recording immediately               | `false`                  |
| Copy Recording to Clipboard | Copy output after recording               | `false`                  |
| GIF Max Seconds             | Maximum GIF duration                      | `30`                     |

Files automatically receive appropriate extensions (`.png`, `.mp4`, `.gif`).

---

## IPC Commands

Control Screen Toolkit via scripts or keybindings:

```bash
qs -c noctalia-shell ipc call plugin:screen-toolkit <command>
```

Replace `<command>` with any of the following:

---

### General

| Command  | Description                  |
| -------- | ---------------------------- |
| `toggle` | Open or close the main panel |

---

### Annotation

| Command              | Description                            |
| -------------------- | -------------------------------------- |
| `annotate`           | Annotate a selected region             |
| `annotateFullscreen` | Annotate full screen                   |
| `annotateWindow`     | Annotate active window (Hyprland only) |

---

### Pin

| Command    | Description                    |
| ---------- | ------------------------------ |
| `pin`      | Pin a selected region          |
| `pinImage` | Pin an existing image or video |

---

### Recording

| Command               | Description              |
| --------------------- | ------------------------ |
| `record`              | Record region as GIF     |
| `recordMp4`           | Record region as MP4     |
| `recordFullscreen`    | Record fullscreen as GIF |
| `recordFullscreenMp4` | Record fullscreen as MP4 |
| `recordStop`          | Stop recording           |

---

### Utilities

| Command       | Description                  |
| ------------- | ---------------------------- |
| `mirror`      | Toggle webcam mirror overlay |
| `colorPicker` | Pick pixel color             |
| `ocr`         | Extract text via OCR         |
| `qr`          | Scan QR/barcodes             |
| `palette`     | Extract color palette        |
| `lens`        | Send region to Google Lens   |
| `measure`     | Measure screen distances     |

---

## Troubleshooting

### File picker does not open (Pin Image/Video)

Ensure:

* `xdg-desktop-portal` is installed and running
* A fallback picker is available (`zenity` or `kdialog`)

---

### Recording does not work

Check:

* `wl-screenrec` or `wf-recorder` is installed
* Your compositor supports screen capture

---

### OCR not working

Ensure:

* `tesseract` is installed
* Language packs are installed (e.g. `tesseract-data-eng`)

---

### GIF issues

Install:

* `gifski` for improved encoding quality

---

### QR scanner not detecting codes

Ensure:

* `zbar` is installed
* The region has sufficient contrast and clarity

---

## License

MIT License

---

## Contributing

Contributions, issues, and feature requests are welcome.

Repository: [https://github.com/noctalia-dev/noctalia-plugins](https://github.com/noctalia-dev/noctalia-plugins)


