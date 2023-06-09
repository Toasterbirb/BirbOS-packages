NAME="newsboat"
DESC="RSS/Atom feed reader for the text console"
VERSION="2.31"
SOURCE="https://newsboat.org/releases/${VERSION}/newsboat-${VERSION}.tar.xz"
CHECKSUM="035e98338f8f672c5c11ccb3ba509a0b"
DEPS="sqlite curl libxml2 stfl asciidoctor json-c rustc"
FLAGS=""

_setup()
{
	tar -xf $DISTFILES/$(basename $SOURCE)
	cd ${NAME}-${VERSION}
}

_build()
{
	# Remove a --require flag that seems to break asciidoctor
	sed -i 's/--require=.\/doc\/man.rb//g' Makefile

	cargo build --release
	make -j${BUILD_JOBS}
}

_install()
{
	make -j${BUILD_JOBS} prefix=/usr DESTDIR=$FAKEROOT/$NAME install
}
