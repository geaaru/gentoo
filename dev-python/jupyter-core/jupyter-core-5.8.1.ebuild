# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Core common functionality of Jupyter projects"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/jupyter_core/
	https://pypi.org/project/jupyter-core/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"

RDEPEND="
	>=dev-python/platformdirs-2.5[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.11.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pip[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
