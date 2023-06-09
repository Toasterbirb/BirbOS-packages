NAME="stfl"
DESC="A library which implements a curses-based widget set for text terminals"
VERSION="0.22"
SOURCE="http://deb.debian.org/debian/pool/main/s/stfl/stfl_${VERSION}.orig.tar.gz"
CHECKSUM="df4998f69fed15fabd702a25777f74ab"
DEPS="ncurses"
FLAGS=""

# NOTE: The original website is partly down and thus the sources are unavailable
# For now, the debian "mirror" will be used for this package

_setup()
{
	tar -xf $DISTFILES/$(basename $SOURCE)
	cd ${NAME}-${VERSION}
}

_build()
{
	# Fix ncurses header paths
	sed -i 's/<ncursesw\/ncurses.h>/<ncurses.h>/' stfl_internals.h

	make -j${BUILD_JOBS}
}

_install()
{
	make prefix=/usr DESTDIR=$FAKEROOT/$NAME install
	ln -srv $FAKEROOT/$NAME/usr/lib/libstfl.so $FAKEROOT/$NAME/usr/lib/libstfl.so.0
}
