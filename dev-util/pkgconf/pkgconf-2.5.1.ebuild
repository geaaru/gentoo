# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib multilib-minimal

if [[ ${PV} == 9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/pkgconf/pkgconf"
else
	SRC_URI="https://distfiles.ariadne.space/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

DESCRIPTION="pkg-config compatible replacement with no dependencies other than C99"
HOMEPAGE="https://github.com/pkgconf/pkgconf"

LICENSE="ISC"
SLOT="0/7"
IUSE="+native-symlinks test"

RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-libs/atf
		dev-util/kyua
	)
"
RDEPEND="!dev-util/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-buf_sz.patch
)

src_prepare() {
	default

	[[ ${PV} == 9999 ]] && eautoreconf

	MULTILIB_CHOST_TOOLS=(
		/usr/bin/pkgconf$(get_exeext)
		/usr/bin/pkg-config$(get_exeext)
	)
}

multilib_src_configure() {
	local myeconfargs=(
		--with-system-includedir="${EPREFIX}/usr/include"
		--with-system-libdir="${EPREFIX}/$(get_libdir):${EPREFIX}/usr/$(get_libdir)"
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	unset PKG_CONFIG_LIBDIR PKG_CONFIG_PATH
	default
}

multilib_src_install() {
	default

	dosym pkgconf$(get_exeext) /usr/bin/pkg-config$(get_exeext)
	dosym pkgconf.1 /usr/share/man/man1/pkg-config.1
}

multilib_src_install_all() {
	einstalldocs

	if ! use native-symlinks; then
		rm "${ED}"/usr/bin/{pkgconf,pkg-config}$(get_exeext) || die
	fi

	find "${ED}" -type f -name '*.la' -delete || die
}
