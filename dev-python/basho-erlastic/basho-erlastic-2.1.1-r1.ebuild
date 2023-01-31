# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Erlang binary term codec and port interface"
HOMEPAGE="
	https://github.com/basho/python-erlastic/
	https://pypi.org/project/basho-erlastic/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"

python_test() {
	"${EPYTHON}" tests.py || die
}
