#!/bin/sh
# configs + services + branding.
set -eu

TARGET="faustix.apkovl.tar.gz"
WORK=$(mktemp -d)
ROOT="$(dirname "$0")/../overlay-root"

# Copie intégrale de l'arborescence d'overlay
cp -r "$ROOT"/* "$WORK"/

mkdir -p "$WORK"/etc/runlevels/{default,boot} \
         "$WORK"/etc/local.d

# ---- services ----
rc_add() { ln -sf "/etc/init.d/$2" "$WORK/etc/runlevels/$3/$2"; }
rc_add dbus default
rc_add elogind default
rc_add sddm default
rc_add networkmanager default
rc_add crond default

# ---- régénérer le cache ----
cat > "$WORK"/etc/local.d/branding.start <<'EOF'
#!/bin/sh
gtk-update-icon-cache -f /usr/share/icons/hicolor 2>/dev/null || true
EOF
chmod +x "$WORK"/etc/local.d/branding.start
rc_add local default

# ---- Plymouth ----
mkdir -p "$WORK"/etc/plymouth
echo "[Daemon]" > "$WORK"/etc/plymouth/plymouthd.conf
echo "Theme=faustix" >> "$WORK"/etc/plymouth/plymouthd.conf

# ---- hostname ----
echo "faustix" > "$WORK"/etc/hostname

tar -czf "$TARGET" -C "$WORK" etc usr
rm -rf "$WORK"
echo "OK : $TARGET"
# FAUST IS HERE
# FAUST IS HERE
# FAUST IS HERE
# FAUST IS HERE
# FAUST IS HERE
# FAUST IS HERE
