#!/bin/bash
# xdg-portal-aware file picker with fallbacks
# Requires python3-gi for portal support
FILTER_GLOB="*.png *.jpg *.jpeg *.webp *.gif *.bmp *.mp4 *.webm *.mkv *.mov"

_pick_portal() {
  python3 - <<'EOF'
import sys, random, string
try:
    import gi
    gi.require_version("Gio", "2.0")
    from gi.repository import Gio, GLib
except Exception:
    sys.exit(1)

loop = GLib.MainLoop()
result = []

def on_response(conn, sender, path, iface, signal, params, *_):
    code, results = params
    if code == 0:
        uris = results.get("uris")
        if uris:
            result.append(uris[0].replace("file://", "").replace("%20", " "))
    loop.quit()

bus = Gio.bus_get_sync(Gio.BusType.SESSION, None)
token = ''.join(random.choices(string.ascii_lowercase, k=8))
uid = bus.get_unique_name()[1:].replace('.', '_')
handle = f"/org/freedesktop/portal/desktop/request/{uid}/{token}"

bus.signal_subscribe(
    "org.freedesktop.portal.Desktop",
    "org.freedesktop.portal.Request",
    "Response", handle, None,
    Gio.DBusSignalFlags.NONE,
    on_response, None
)

opts = GLib.Variant("a{sv}", {
    "handle_token": GLib.Variant("s", token),
    "filters": GLib.Variant("a(sa(us))", [
        ("Images", [(1,"*.png"),(1,"*.jpg"),(1,"*.jpeg"),(1,"*.webp"),(1,"*.gif"),(1,"*.bmp")])
    ])
})

bus.call_sync(
    "org.freedesktop.portal.Desktop",
    "/org/freedesktop/portal/desktop",
    "org.freedesktop.portal.FileChooser",
    "OpenFile",
    GLib.Variant("(ssa{sv})", ("", "Pin image", dict(opts.unpack()))),
    None, Gio.DBusCallFlags.NONE, -1, None
)

loop.run()
if result:
    print(result[0])
    sys.exit(0)
sys.exit(1)
EOF
}

# Try portal first, then GUI fallbacks
if python3 -c "import gi" 2>/dev/null && _pick_portal; then
  exit 0
elif command -v zenity >/dev/null 2>&1; then
  zenity --file-selection --title='Pin image' \
    --file-filter="Images | $FILTER_GLOB" 2>/dev/null
elif command -v kdialog >/dev/null 2>&1; then
  kdialog --getopenfilename '' "Images ($FILTER_GLOB)" 2>/dev/null
else
  echo "no-picker" >&2   # optional, for logging
  exit 2
fi
