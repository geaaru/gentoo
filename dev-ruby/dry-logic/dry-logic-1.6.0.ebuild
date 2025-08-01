# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="dry-logic.gemspec"

inherit ruby-fakegem

DESCRIPTION="Predicate logic with rule composition"

HOMEPAGE="https://dry-rb.org/gems/dry-logic/"
SRC_URI="https://github.com/dry-rb/dry-logic/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~arm64 ~hppa ppc ppc64 sparc ~x86"
IUSE="test"

ruby_add_rdepend "
	dev-ruby/bigdecimal
	dev-ruby/concurrent-ruby:1
	dev-ruby/dry-core:1
	>=dev-ruby/zeitwerk-2.6:2
"

ruby_add_bdepend "test? ( dev-ruby/warning )"

all_ruby_prepare() {
	sed -e '3irequire "uri"' -i spec/spec_helper.rb || die
}
