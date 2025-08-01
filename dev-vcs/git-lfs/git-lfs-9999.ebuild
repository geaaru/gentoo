# Copyright 2017-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EGO_PN=github.com/git-lfs/git-lfs
# Update the ID as it's included in each build.
COMMIT_ID=""

inherit go-module shell-completion

DESCRIPTION="Command line extension and specification for managing large files with git"
HOMEPAGE="
	https://git-lfs.com
	https://github.com/git-lfs/git-lfs
"

if [[ "${PV}" = 9999* ]]; then
	EGIT_REPO_URI="https://${EGO_PN}"
	inherit git-r3
else
	SRC_URI="https://${EGO_PN}/releases/download/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"
	# Add the manually vendored tarball.
	# 1) Create a tar archive optimized to reproduced by other users or devs.
	# 2) Compress the archive using XZ limiting decompression memory for
	#    pretty constraint systems.
	# Use something like:
	# GOMODCACHE="${PWD}"/go-mod go mod download -modcacherw
	# tar cf $P-deps.tar go-mod \
	#	--mtime="1970-01-01" --sort=name --owner=portage --group=portage
	# xz -k -9eT0 --memlimit-decompress=256M $P-deps.tar
	SRC_URI+=" https://files.holgersson.xyz/gentoo/distfiles/golang-pkg-deps/${P}-deps.tar.xz"
fi

LICENSE="Apache-2.0 BSD BSD-2 BSD-4 ISC MIT"
SLOT="0"
# KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

BDEPEND="
	doc? ( dev-ruby/asciidoctor )
"
RDEPEND="dev-vcs/git"

RESTRICT+=" !test? ( test )"

DOCS=(
	CHANGELOG.md
	CODE-OF-CONDUCT.md
	CONTRIBUTING.md
	README.md
	SECURITY.md
)

src_compile() {
	export CGO_ENABLED=0

	# Flags -w, -s: Omit debugging information to reduce binary size,
	# see https://golang.org/cmd/link/.
	local mygobuildargs=(
		-ldflags="-X ${EGO_PN}/config.GitCommit=${COMMIT_ID} -s -w"
		-gcflags=" "
		-trimpath
		-v -work -x
	)
	ego build "${mygobuildargs[@]}" -o git-lfs git-lfs.go

	if use doc; then
		for doc in docs/man/*adoc;
			do asciidoctor -b manpage ${doc} || die "man building failed"
		done
	fi

	# Generate auto-completion scripts.
	# bug 914542
	./git-lfs completion bash > "${PN}.bash" || die
	./git-lfs completion fish > "${PN}.fish" || die
	./git-lfs completion zsh > "${PN}.zsh" || die
}

src_install() {
	dobin git-lfs
	einstalldocs

	# Install auto-completion scripts generated earlier.
	# bug 914542
	newbashcomp "${PN}.bash" "${PN}"
	dofishcomp "${PN}.fish"
	newzshcomp "${PN}.zsh" "_${PN}"

	use doc && doman docs/man/*.1
}

src_test() {
	local mygotestargs=(
		-ldflags="-X ${EGO_PN}/config.GitCommit=${COMMIT_ID}"
	)
	ego test "${mygotestargs[@]}" ./...
}

pkg_postinst () {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog ""
		elog "Run 'git lfs install' once for each user account manually."
		elog "For more details see https://bugs.gentoo.org/show_bug.cgi?id=733372."
	fi
}
