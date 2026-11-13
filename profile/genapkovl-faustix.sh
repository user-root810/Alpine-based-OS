#!/bin/sh
# Génère l'overlay Faustix.
# Contrat mkimage : appelé par fakeroot avec le hostname en $1,
# doit écrire "<hostname>.apkovl.tar.gz" dans le répertoire courant.
set -eu

HOSTNAME="${1:-faustix}"
TARGET="${HOSTNAME}.apkovl.tar.gz"
tmp=$(mktemp -d)

# Retrouve overlay-root (monté en /work dans la CI GitHub Actions)
ROOT=""
for _d in /work/overlay-root "$PWD/overlay-root" \
	"$(dirname "$0")/../../overlay-root"; do
	if [ -d "$_d" ]; then ROOT="$_d"; break; fi
done
[ -n "$ROOT" ] || { echo "overlay-root introuvable" >&2; exit 1; }

cp -r "$ROOT"/etc "$ROOT"/usr "$tmp"/

# ---- services (démarrage graphique) ----
mkdir -p "$tmp"/etc/runlevels/default "$tmp"/etc/local.d
rc_add() { ln -sf "/etc/init.d/$2" "$tmp/etc/runlevels/$1/$2"; }

rc_add default dbus
rc_add default elogind
rc_add default sddm
rc_add default networkmanager
rc_add default crond
rc_add default local

# ---- paquets installés au boot depuis le dépôt de l'ISO ----
mkdir -p "$tmp"/etc/apk
cat > "$tmp"/etc/apk/world <<'EOF'
alpine-base
plasma-desktop
plasma-nm
kde-plasma-network-management
sddm
powerdevil
konsole
dolphin
ark
breeze-icons
breeze-gtk
font-noto
font-jetbrainsmono-nerd-font
fastfetch
networkmanager
networkmanager-wifi
firefox-esr
plasma-pa
xdg-desktop-portal-kde
elogind
polkit-elogind
dbus
mesa-dri-gallium
eudev
EOF

# ---- régénérer le cache d'icônes au boot ----
cat > "$tmp"/etc/local.d/branding.start <<'EOF'
#!/bin/sh
gtk-update-icon-cache -f /usr/share/icons/hicolor 2>/dev/null || true
EOF
chmod +x "$tmp"/etc/local.d/branding.start

# ---- Plymouth ----
mkdir -p "$tmp"/etc/plymouth
echo "[Daemon]" > "$tmp"/etc/plymouth/plymouthd.conf
echo "Theme=faustix" >> "$tmp"/etc/plymouth/plymouthd.conf

# ---- hostname ----
echo "$HOSTNAME" > "$tmp"/etc/hostname

# overlay
tar -c -C "$tmp" etc usr | gzip -9n > "$TARGET"
rm -rf "$tmp"
echo "OK : $TARGET"
# FAUST IS HERE
# FAUST IS HERE
# FAUST IS HERE
# FAUST IS HERE
# FAUST IS HERE
# FAUST IS HERE
