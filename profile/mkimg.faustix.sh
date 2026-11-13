profile_faustix() {
	profile_standard

	title="Faustix"
	desc="Faustix — Live"
	image_ext="iso"
	arch="x86_64"
	kernel_flavors="lts"
	initfs_features="${initfs_features} plymouth kms"
	hostname="faustix"
	syslinux_timeout="3"

	apks="$apks
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
		py3-pywal
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
		xf86-video-qxl
		eudev
	"
}
