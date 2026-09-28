platform_check_image() {
	local board=$(board_name)

	case "$board" in
	chinamobile,gs3101|\
	dasan,h660gm-a-airtel|\
	dasan,h660gm-a-generic|\
	jiofiber,jcow407|\
	jiofiber,jcow414)
		return 0
		;;
	zyxel,ex3301-t0)
		if fwtool -q -i /dev/null "$1"; then
			return 0
		fi
		local magic=$(dd if="$1" bs=1 count=4 2>/dev/null)
		if [ "$magic" = "2RDH" ]; then
			return 0
		fi
		echo "Invalid image: missing OpenWrt metadata or 2RDH header"
		return 1
		;;
	esac

	return 1
}

platform_do_upgrade() {
	local board=$(board_name)

	case "$board" in
	chinamobile,gs3101|\
	dasan,h660gm-a-airtel|\
	dasan,h660gm-a-generic|\
	jiofiber,jcow407|\
	jiofiber,jcow414)
		CI_KERNPART="tclinux_kernel"
		nand_do_upgrade "$1"
		;;
	zyxel,ex3301-t0)
		PART_NAME="tclinux"
		MTD_ARGS="-e rootfs_data"
		default_do_upgrade "$1"
		;;
	esac
}
