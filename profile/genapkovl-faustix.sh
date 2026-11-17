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
xorg-server
xf86-input-libinput
xwayland
plasma-desktop
plasma-nm
sddm
powerdevil
konsole
dolphin
ark
breeze-icons
breeze-gtk
font-noto
font-jetbrains-mono-nerd
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
mesa-gl
eudev
sudo
plasma-workspace-x11
EOF

# ---- utilisateur live + droits sudo ----
cat > "$tmp"/etc/local.d/faustix-user.start <<'EOF'
#!/bin/sh
getent passwd faustix || adduser -D -s /bin/sh faustix
echo 'faustix ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/faustix || true
mkdir -p /home/faustix/.config
cp -r /etc/skel/.config/* /home/faustix/.config/ 2>/dev/null || true
chown -R faustix:faustix /home/faustix
EOF
chmod +x "$tmp"/etc/local.d/faustix-user.start

# ---- autologin SDDM en session Plasma Wayland ----
mkdir -p "$tmp"/etc/sddm.conf.d
cat > "$tmp"/etc/sddm.conf.d/live.conf <<'EOF'
[Autologin]
User=faustix
Session=plasma
Relogin=false

[X11]
ServerArguments=-nolisten tcp -background none -noreset
EOF

# ---- régénérer le cache d'icônes au boot ----
cat > "$tmp"/etc/local.d/branding.start <<'EOF'
#!/bin/sh
gtk-update-icon-cache -f /usr/share/icons/hicolor 2>/dev/null || true
EOF
chmod +x "$tmp"/etc/local.d/branding.start

# ---- Plymouth par défaut ----
mkdir -p "$tmp"/etc/plymouth
echo "[Daemon]" > "$tmp"/etc/plymouth/plymouthd.conf
echo "Theme=faustix" >> "$tmp"/etc/plymouth/plymouthd.conf

# ---- hostname ----
echo "$HOSTNAME" > "$tmp"/etc/hostname

# Écrit l'overlay DANS le répertoire courant (exigé par mkimage)
tar -c -C "$tmp" etc usr | gzip -9n > "$TARGET"
rm -rf "$tmp"
echo "OK : $TARGET"
# FAUST IS HERE
# FAUST IS HERE
# FAUST IS HERE
# FAUST IS HERE
# FAUST IS HERE
# FAUST IS HERE
