NAME="python3"
DESC="Contains the python development environment"
VERSION="3.11.3"
SOURCE="https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tar.xz"
CHECKSUM="c8d52fc4fb8ad9932a11d86d142ee73a"
DEPS="libffi expat"
FLAGS="important"

_setup()
{
	tar -xf $DISTFILES/$(basename $SOURCE)
	cd Python-${VERSION}
}

_build()
{
	./configure --prefix=$FAKEROOT/$NAME/usr \
            --enable-shared      \
            --with-system-expat  \
            --with-system-ffi    \
            --enable-optimizations

	make -j$(nproc)
}

_install()
{
	make install

	# Supress pip3 warnings
	cat > /etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF
}