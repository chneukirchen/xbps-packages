# Enable as-needed by default.
LDFLAGS="-Wl,--as-needed ${LDFLAGS}"

if [ -z "$nopie" ]; then
	# Enable FORITFY_SOURCE=2
	CFLAGS="-D_FORTIFY_SOURCE=2 ${CFLAGS}"
	CXXFLAGS="-D_FORTIFY_SOURCE=2 ${CXXFLAGS}"
	LDFLAGS="-Wl,-z,relro -Wl,-z,now ${LDFLAGS}"
	case "$XBPS_TARGET_MACHINE" in
		# needs help finding __stack_chk_fail_local (issue #2902)
		i686-musl) LDFLAGS="-lssp_nonshared $LDFLAGS";;
	esac
	# Our compilers use --enable-default-pie and --enable-default-ssp,
	# but the bootstrap host compiler may not, force them.
	if [ -z "$CHROOT_READY" ]; then
		CFLAGS="-fPIE ${CFLAGS}"
		CXXFLAGS="-fPIE ${CXXFLAGS}"
		LDFLAGS="-pie ${LDFLAGS}"
	fi
else
	CFLAGS="-fno-PIE ${CFLAGS}"
	CXXFLAGS="-fno-PIE ${CFLAGS}"
	LDFLAGS="-no-pie ${LDFLAGS}"
fi
