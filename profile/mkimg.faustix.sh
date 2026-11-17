profile_faustix() {
	profile_standard

	title="Faustix"
	desc="Faustix — Live KDE Plasma sombre"
	image_ext="iso"
	arch="x86_64"
	kernel_flavors="lts"
	initfs_features="${initfs_features} plymouth kms"
	hostname="faustix"
	apkovl="genapkovl-faustix.sh"
	syslinux_timeout="3"

		apks="$apks
		
		xorg-server
		xf86-input-libinput
		xwayland
		plasma-desktop
		plasma-nm
		sddm
		sddm-kcm
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
	"
}
