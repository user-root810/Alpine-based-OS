#!/bin/sh
# Génère faustix.apkovl.tar.gz : configs + services + branding.
set -eu

TARGET="faustix.apkovl.tar.gz"
WORK=$(mktemp -d)
ROOT="$(cd "$(dirname "$0")/.." && pwd)/overlay-root"

# Copie intégrale de l'arborescence d'overlay
mkdir -p "$WORK"
cp -r "$ROOT"/etc "$ROOT"/usr "$WORK"/

# ---- services (démarrage graphique) ----
mkdir -p "$WORK"/etc/runlevels/default "$WORK"/etc/local.d

# rc_add <runlevel> <service>
rc_add() {
	mkdir -p "$WORK/etc/runlevels/$1"
	ln -sf "/etc/init.d/$2" "$WORK/etc/runlevels/$1/$2"
}

rc_add default dbus
rc_add default elogind
rc_add default sddm
rc_add default networkmanager
rc_add default crond
rc_add default local

# ---- régénérer le cache d'icônes au boot ----
cat > "$WORK"/etc/local.d/branding.start <<'EOF'
#!/bin/sh
gtk-update-icon-cache -f /usr/share/icons/hicolor 2>/dev/null || true
EOF
chmod +x "$WORK"/etc/local.d/branding.start

# ---- Plymouth par défaut ----
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
