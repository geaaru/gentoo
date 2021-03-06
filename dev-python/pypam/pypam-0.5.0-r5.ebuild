# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{6..9} )

inherit distutils-r1 flag-o-matic

MY_PN="PyPAM"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python Bindings for PAM (Pluggable Authentication Modules)"
HOMEPAGE="http://www.pangalactic.org/PyPAM"
SRC_URI="http://www.pangalactic.org/PyPAM/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND=">=sys-libs/pam-0.64"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS examples/pamtest.py )

PATCHES=(
	# Pull patches from fedora.
	"${FILESDIR}/PyPAM-${PV}-dealloc.patch"
	"${FILESDIR}/PyPAM-${PV}-nofree.patch"
	"${FILESDIR}/PyPAM-${PV}-memory-errors.patch"
	"${FILESDIR}/PyPAM-${PV}-return-value.patch"
	"${FILESDIR}/PyPAM-python3-support.patch"
	# Fix a missing include.
	"${FILESDIR}/${P}-stricter.patch"
)

src_compile() {
	append-cflags -fno-strict-aliasing
	distutils-r1_src_compile
}

python_test() {
	"${PYTHON}" tests/PamTest.py
}
