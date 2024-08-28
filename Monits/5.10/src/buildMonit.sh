#! /bin/sh
set -e #"set -e" in the main script causes any function returning 1 (or exiting with it) to abort the whole execution

##############################################################################
# Created by: KPorta
# On Date: 1/12/2014
# License: GPL v3
##############################################################################

##############################################################################
#GLOBAL VARIABLES:
_MONIT_VERSION=5.10
_MONIT_FILE=monit-$_MONIT_VERSION.tar.gz
_CYGMONIT_DEV_VERSION=/cygdrive/c/CygMonit_Dev


##############################################################################
#FUCNTIONS:
move_me() {
    cd  /tmp/monit-$_MONIT_VERSION
}


###############################################################################!
### CLEANING
/usr/bin/rm /tmp/$_MONIT_FILE -f
/usr/bin/rm /tmp/monit-$_MONIT_VERSION -rf  
/usr/bin/sleep 1

### INSTALLING
/usr/bin/cp $_CYGMONIT_DEV_VERSION/Monits/$_MONIT_VERSION/src/$_MONIT_FILE /tmp/$_MONIT_FILE
/usr/bin/gunzip -f /tmp/$_MONIT_FILE 
/usr/bin/tar -xvf /tmp/monit-$_MONIT_VERSION.tar -C /tmp
/usr/bin/rm /tmp/monit-$_MONIT_VERSION.tar -f

### PATCHING
/usr/bin/cp /tmp/monit-$_MONIT_VERSION/configure.ac /tmp/monit-$_MONIT_VERSION/configure.ac.original
/usr/bin/cp $_CYGMONIT_DEV_VERSION/Monits/$_MONIT_VERSION/src/monit_configure.ac.patch /tmp/monit-$_MONIT_VERSION
/usr/bin/patch -p1 /tmp/monit-$_MONIT_VERSION/configure.ac /tmp/monit-$_MONIT_VERSION/monit_configure.ac.patch

/usr/bin/cp /tmp/monit-$_MONIT_VERSION/libmonit/configure.ac /tmp/monit-$_MONIT_VERSION/libmonit/configure.ac.original
/usr/bin/cp $_CYGMONIT_DEV_VERSION/Monits/$_MONIT_VERSION/src/libmonit_configure.ac.patch /tmp/monit-$_MONIT_VERSION/libmonit
/usr/bin/patch -p1 /tmp/monit-$_MONIT_VERSION/libmonit/configure.ac /tmp/monit-$_MONIT_VERSION/libmonit/libmonit_configure.ac.patch

/usr/bin/cp /tmp/monit-$_MONIT_VERSION/src/monit.h /tmp/monit-$_MONIT_VERSION/src/monit.h.original
/usr/bin/cp $_CYGMONIT_DEV_VERSION/Monits/$_MONIT_VERSION/src/monit.h.patch /tmp/monit-$_MONIT_VERSION/src
/usr/bin/patch -p1 /tmp/monit-$_MONIT_VERSION/src/monit.h /tmp/monit-$_MONIT_VERSION/src/monit.h.patch

/usr/bin/cp /tmp/monit-$_MONIT_VERSION/src/net.c /tmp/monit-$_MONIT_VERSION/src/net.c.original
/usr/bin/cp $_CYGMONIT_DEV_VERSION/Monits/$_MONIT_VERSION/src/net.c.patch /tmp/monit-$_MONIT_VERSION/src
/usr/bin/patch -p1 /tmp/monit-$_MONIT_VERSION/src/net.c /tmp/monit-$_MONIT_VERSION/src/net.c.patch

# For cygwin I emulate Linux, but I wonder what would be best, unless to compile the functions for CYGWIN
/usr/bin/cp /tmp/monit-$_MONIT_VERSION/src/process/sysdep_Linux.c /tmp/monit-$_MONIT_VERSION/src/process/sysdep_CYGWIN.c
/usr/bin/cp /tmp/monit-$_MONIT_VERSION/src/device/sysdep_Linux.c /tmp/monit-$_MONIT_VERSION/src/device/sysdep_CYGWIN.c


### BUILDING
echo myPWD $PWD && move_me && echo myPWD $PWD 

# There is no PAM for Cygwin (./bootstrap && autoreconf -i -f && automake -acf && ./configure --without-pam && make clean && make # --without-ssl #--without-ipv6)
./bootstrap 
./configure --without-pam # --without-ssl #--without-ipv6

make clean && make
/usr/bin/cp /tmp/monit-$_MONIT_VERSION/monit.exe $_CYGMONIT_DEV_VERSION/Monits/$_MONIT_VERSION/exe/monit-$_MONIT_VERSION.exe
/usr/bin/cp $_CYGMONIT_DEV_VERSION/Monits/$_MONIT_VERSION/exe/monit-$_MONIT_VERSION.exe $_CYGMONIT_DEV_VERSION/Monits/$_MONIT_VERSION/exe/monit.exe 

make dist
/usr/bin/mv /tmp/monit-$_MONIT_VERSION/monit-$_MONIT_VERSION.tar.gz /tmp/monit-$_MONIT_VERSION/monit-CYGWIN-$_MONIT_VERSION.tar.gz
/usr/bin/mv /tmp/monit-$_MONIT_VERSION/monit-CYGWIN-$_MONIT_VERSION.tar.gz $_CYGMONIT_DEV_VERSION/Monits/$_MONIT_VERSION/src/monit-CYGWIN-$_MONIT_VERSION.tar.gz

./monit --version