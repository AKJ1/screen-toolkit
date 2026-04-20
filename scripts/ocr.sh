#!/bin/bash
# ocr.sh — capture a region and run OCR on it
# Args: $1=gx $2=gy $3=gw $4=gh $5=lang $6=upscale_flag $7=psm
GX="$1"; GY="$2"; GW="$3"; GH="$4"
LANG="${5:-eng}"; UPSCALE="$6"; PSM="${7:-3}"
FILE="/tmp/screen-toolkit-ocr.png"
TMP="/tmp/screen-toolkit-ocr-work-$$.pnm"

[ -z "$GX" ] || [ -z "$GY" ] || [ -z "$GW" ] || [ -z "$GH" ] && exit 1

grim -g "${GX},${GY} ${GW}x${GH}" "$FILE" 2>/dev/null || exit 1

magick "$FILE" $UPSCALE \
  -colorspace Gray -normalize -contrast-stretch 2%x1% -sharpen 0x1.5 +repage \
  "$TMP" 2>/dev/null || exit 1

MEAN=$(magick "$TMP" -format '%[fx:mean]' info: 2>/dev/null)
if awk "BEGIN{exit !($MEAN < 0.4)}"; then
  magick "$TMP" -negate "$TMP" 2>/dev/null
fi

TEXT=$(tesseract "$TMP" stdout -l "$LANG" --psm "$PSM" --oem 1 2>/dev/null)
TLEN=$(printf '%s' "$TEXT" | tr -d '[:space:]' | wc -c)

if [ "$TLEN" -lt 4 ]; then
  TEXT2=$(magick "$TMP" -threshold 85% stdout 2>/dev/null \
          | tesseract - stdout -l "$LANG" --psm "$PSM" --oem 1 2>/dev/null)
  T2LEN=$(printf '%s' "$TEXT2" | tr -d '[:space:]' | wc -c)
  [ "$T2LEN" -gt "$TLEN" ] && TEXT="$TEXT2"
fi

printf '%s' "$TEXT"
rm -f "$TMP"
