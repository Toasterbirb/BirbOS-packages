NAME="libelf"
DESC="Library for handling ELF (Executable and Linkable Format) files"
VERSION="0.189"
SOURCE="https://sourceware.org/ftp/elfutils/${VERSION}/elfutils-${VERSION}.tar.bz2"
CHECKSUM="5cfaa711a90cb670406cd495aeaa6030"
DEPS=""
FLAGS="32bit test"

_setup()
{
	tar -xf $DISTFILES/$(basename $SOURCE)
	cd ${NAME}-${VERSION}
}

_build()
{
	./configure --prefix=$FAKEROOT/$NAME/usr \
            --disable-debuginfod         \
            --enable-libdebuginfod=dummy

	make -j$(nproc)
}

_install()
{
	# Only install libelf
	make -C libelf install
	install -vm644 config/libelf.pc $FAKEROOT/$NAME/usr/lib/pkgconfig
	rm /usr/lib/libelf.a
}

_test()
{
	make -j$(nproc) check
}

# These 32 bit functions get called only if the '32bit' flag is set
# Otherwise they are optional
_build32()
{
	make distclean

	CC="gcc -m32" ./configure \
		--host=i686-pc-linux-gnu \
		--prefix=$FAKEROOT/$NAME/usr \
		--libdir=/usr/lib32      \
		--disable-debuginfod     \
		--enable-libdebuginfod=dummy

	make -j$(nproc)
}

_install32()
{
	make DESTDIR=$PWD/DESTDIR -C libelf install
	install -vDm644 config/libelf.pc DESTDIR/usr/lib32/pkgconfig/libelf.pc
	cp -Rv DESTDIR/usr/lib32/* $FAKEROOT/$NAME/usr/lib32
	rm -rf DESTDIR
}
