# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A tool like sed, awk, cut, join, and sort for name-indexed data (CSV, JSON, ..)"
HOMEPAGE="https://johnkerl.org/miller/doc/index.html"
SRC_URI="https://github.com/johnkerl/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc test"

DEPEND="sys-devel/flex"

src_prepare() {
	default

	# respect flags
	find -type f -name "Makefile.am" -exec sed -i -r -e '/.*FLAGS[^=]*=/ s:(-g|-pg|-O[0-9]) ::g' -- {} \; || die

	# disable docs rebuilding as they're shipped prebuilt
	sed -e '/SUBDIRS[^=]*=/ s:doc::g' -i -- Makefile.am || die

	# disable building tests automagically
	if ! use test; then
		sed -e '/SUBDIRS[^=]*=/ s:[^ ]*_test::g' -i -- c/Makefile.am || die
	fi

	eautoreconf
}

src_test() {
	emake -C c/reg_test
	emake -C c/unit_test
}

src_install() {
	local HTML_DOCS=( $(usev doc) )

	default

	doman 'doc/mlr.1'
}
