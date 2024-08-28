Original README with good help urls by problem

############################################################################
HOW TO COMPILE MONIT 5.14 ON CYGWIN
##############################################################################
Author: KPorta
Mail: kfeina at gmail.com
Tested on:CYGWIN_NT-6.3 HOSTNAME 2.0.1(0.287/5/3) 2015-04-30 18:15 x86_64 Cygwin 2015-08-30 12:09 x86_64
libtool (GNU libtool) 2.4.6
gcc version 4.9.2 (GCC)
autoconf (GNU Autoconf) 2.69
automake 1.14
bison (GNU Bison) 3.0.4
flex 2.5.39
m4 (GN4 M4) 1.7.17 

##############################################################################
PACKGAGING
##############################################################################
1- The following packages are required:

    Devel -> autoconf,automake,gcc-core,bison,libtool, flex,
    System -> pam

2- Download monit source from https://mmonit.com/monit/

3- For better success, start cygwin.bat with administration privileges elevation

$ cd /tmp
$ tar xvfz monit-5.14.tar.gz
$ cd monit-5.14

##############################################################################
COMPILE LIBMONIT FIRST
##############################################################################
$ cd libmonit

$ ./bootstrap
    Success bootstrapping libmonit

#If Success then:
$ autoreconf -i -f
$ automake -acf
$ ./configure

#ERROR:
checking vsnprintf is c99 conformant... configure: error: in `/tmp/monit-5.14/libmonit':
configure: error: vsnprintf does not conform to c99
See `config.log' for more details

#ERROR INFO:
>> configure:12487: checking vsnprintf is c99 conformant
>> configure:12507: gcc -o conftest.exe -g -O2   conftest.c -lpthread  >&5
>> /usr/lib/gcc/x86_64-pc-cygwin/4.9.2/../../../../x86_64-pc-cygwin/bin/ld:
>> cannot open output file conftest.exe: Permission denied
>> collect2: error: ld returned 1 exit status
>

#SOLUTION: Disable Antivirus to solve the problem (tested with Symantec Antivirus).
##############################################################################

$ autoreconf -i -f && automake -acf && ./configure
$ autoreconf -i -f && automake -acf && ./configure --without-pam
$ autoreconf -i -f && automake -acf && ./configure #--without-ssl --without-pam

#ERROR: configure: error: Architecture not supported: CYGWIN_NT-6.3
#SOLUTION: Inside libmonit/configure.ac, search for the # CYGWIN # added lines.










#SOLUTION: In cygwin, stdio.h is located in /usr/include. We need to add this CFLAGS in configure.ac
#SOLUTION: In /libmonit/configure.ac, search for the # CYGWIN # added lines.





##############################################################################
$ ./bootstrap
$ autoreconf -i -f
$ automake -acf
$ ./configure

If successful you get:
+------------------------------------------------------------+
| License:                                                   |
| This is Open Source Software and use is subject to the GNU |
| AFFERO GENERAL PUBLIC LICENSE version 3, available in this |
| distribution in the file COPYING.                          |
|                                                            |
| By continuing this installation process, you are bound by  |
| the terms of this license agreement. If you do not agree   |
| with the terms of this license, you must abort the         |
| installation process at this point.                        |
+------------------------------------------------------------+
| Libmonit is configured as follows:                         |
|                                                            |
|   Optimized:                                    DISABLED   |
|   Profiling:                                    DISABLED   |
+------------------------------------------------------------+


##############################################################################
COMPILE MONIT SECOND
##############################################################################
$ cd ..  (move to the root folder)
$ ./bootstrap
    Success bootstrapping libmonit
    Success bootstrapping Monit

$ autoreconf -i -f
$ automake -acf
$ ./configure --without-pam --without-ssl --without-largefiles

#ERROR: Architecture not supported: CYGWIN_NT-5.2
#SOLUTION: In configure.ac, search for the # CYGWIN # added lines.

##############################################################################
$ ./bootstrap
$ autoreconf -i -f
$ automake -acf
$ ./configure

If successful you get:

Monit Build Information:

                Architecture: CYGWIN
              Compiler flags: -Wno-address -Wno-pointer-sign -g -O2 -Wall -Wunused -Wno-unused-label -funsigned-char -D_GNU_SOURCE -std=c99 -D _REENTRANT
                Linker flags: -lpthread -lcrypt -lresolv
           pid file location: /var/run
           Install directory: /usr/local

+------------------------------------------------------------+
| License:                                                   |
| This is Open Source Software and use is subject to the GNU |
| AFFERO GENERAL PUBLIC LICENSE version 3, available in this |
| distribution in the file COPYING.                          |
|                                                            |
| By continuing this installation process, you are bound by  |
| the terms of this license agreement. If you do not agree   |
| with the terms of this license, you must abort the         |
| installation process at this point.                        |
+------------------------------------------------------------+
| Monit has been configured with the following options:      |
|                                                            |
|   PAM support:                                  DISABLED   |
|   SSL support:                                  DISABLED   |
|   Large files support:                          DISABLED   |
|   Optimized:                                    DISABLED   |
+------------------------------------------------------------+

##############################################################################
https://cygwin.com/pipermail/cygwin/2018-January/235695.html

gcc -DHAVE_CONFIG_H -I. -I./src    -DCYGWIN
-DSYSCONFDIR="\"/usr/local/etc\"" -I./src -I./src/device -I./src/http
-I./src/process -I./src/protocols -I./src/ssl -I./libmonit/src
-Wno-address -Wno-pointer-sign -g -O2 -Wall -Wunused -Wno-unused-label
-funsigned-char -D_GNU_SOURCE -std=c99 -D _REENTRANT -c -o src/y.tab.o
src/y.tab.c
<command-line>:0:6: error: expected identifier or ‘(’ before numeric
constant
src/monit.h:581:19: note: in expansion of macro ‘unix’
                 } unix;
                   ^~~~
				   
istorically system-specific macros have had names with no special
prefix; for instance, it is common to find unix defined on Unix systems.
[...] When the -ansi option, or any -std option that requests strict
conformance, is given to the compiler, all the system-specific predefined
macros outside the reserved namespace are suppressed."

>> You can undefine the unix macro or rename the unix struct.
>
> Looks like -std=c99 without -ansi does not suppress those symbols so add -ansi
> to CFLAGS, use equivalent configure options, or autoconf/automake changes.

I'd go with the minimally intrusive `CFLAGS=-Uunix'. -ansi can have undesirable
side effects.


$ make
#ERROR: ICMP_ECHO

    src/p.y: En la función ‘yyparse’:
    src/p.y:995:40: error: ‘ICMP_ECHO’ no se declaró aquí (primer uso en esta función)
                             icmpset.type = ICMP_ECHO;                                  ^
    ...
    make: *** [all] Error 2

#SOLUTION: In src/net.h, search for ICMP_ECHO, ICMP_ECHOREPLY /* CYGWIN */ added lines

##############################################################################
$ make
#ERROR: struct icmp in function icmp_echo

    src/net.c: In function 'icmp_echo':
    src/net.c:424:39: error: invalid use of undefined type 'struct icmp'
    int len_out = offsetof(struct icmp, icmp_data) + DATALEN;

#SOLUTION: In src/net.c, redefinition of icmp_echo function. Raw Sockets (ICMP) are not supported in CYGWIN.
Search for the /* CYGWIN */ added lines
(https://lists.nongnu.org/archive/html/monit-general/2006-06/msg00048.html
http://lists.gnu.org/archive/html/monit-dev/2006-06/msg00026.html
https://cygwin.com/ml/cygwin/2010-01/msg00187.html)

You can implement something like:
http://marc.info/?l=squid-dev&m=107956877111783

##############################################################################
$ make
#ERROR: struc timeval collected

    In file included from src/l.l:52:0:
    src/monit.h:429:24: error: field 'collected' has incomplete type
             struct timeval collected;                    /**< When were data collected */
    ...                     ^
    make: *** [all] Error 2

#SOLUTION: In src/monit.h, search for HAVE_SYS_TIME_H in /* CYGWIN */ added lines (https://www.cygwin.com/ml/cygwin/2014-07/msg00041.html)

##############################################################################
$make
#ERROR: No /src/device/sysdep_CYGWIN.c file exists.
    make[2]: *** No rule to make target 'src/device/sysdep_CYGWIN.c', needed by 'src/device/sysdep_CYGWIN.o'.  Stop.
    ...
    make: *** [all] Error 2

#SOLUTION: device sysdep cygwin dependencies must be created. cp file /src/device/sysdep_Linux.c /src/device/sysdep_CYGWIN.c

##############################################################################
$make
#ERROR: No src/process/sysdep_CYGWIN.c file exists.
    GNU_SOURCE -std=c99 -D _REENTRANT -c -o src/process/process_common.o src/process/process_common.c
    make[2]: *** No rule to make target 'src/process/sysdep_CYGWIN.c', needed by 'src/process/sysdep_CYGWIN.o'.  Stop.
    ...
    make: *** [all] Error 2

#SOLUTION: process sysdep cygwin dependencies must be created. cp file /src/process/sysdep_Linux.c /src/process/sysdep_CYGWIN.c

##############################################################################
$make
#ERROR: GLOB_ONLYDIR not defined in sysdep_CYGWIN.c
    src/process/sysdep_CYGWIN.c: In function 'initprocesstree_sysdep':
    src/process/sysdep_CYGWIN.c:217:34: error: 'GLOB_ONLYDIR' undeclared (first use in this function)
       if ((rv = glob("/proc/[0-9]*", GLOB_ONLYDIR, NULL, &globbuf))) {
    ...
    make: *** [all] Error 2

#SOLUTION: In src/process/sysdep_CYGWIN.c, search for GLOB_ONLYDIR in /* CYGWIN */ added lines


##############################################################################
FINALLY WE GOT THE PROGRAM
##############################################################################
$ make
$ echo $?
0
$ ls -la monit.exe
-rwxr-xr-x 1 Admin Domain users 1523737 Dec 22 18:20 monit.exe

##############################################################################
$ make install

##############################################################################
START THE PROGRAM
##############################################################################
$ monit -vv -t monitrc_cygwin
Control file syntax OK

##############################################################################
$ monit -vv -c monitrc_cygwin
The control file '/tmp/monit-5.10_cygwin/monitrc_cygwin' must have permissions no more than -rwx------ (0700);
right now permissions are -rwxr-xr-x (0755).

$ chmod 0700 monitrc_cygwin
##############################################################################
$ monit -vv -c monitrc_cygwin

-------------------------------------------------------------------------------
$ pidfile '/home/k/.monit.pid' does not exist
$ Starting Monit 5.10 daemon with http interface at [mycomputer:2812]
$ Monit start delay set -- pause for 5s

##############################################################################

##############################################################################
CHECK THE LOG FILE - PROCESS ISSUES
##############################################################################

#ERROR: Windows pure process are not mathed. Windows processes launch by cygwin like: "notepad &" are not mattched.
Process matching works OK inside cygwin with PURE cygwin processes: monit procmatch bash -> "process match".
For non PURE windows process the link to ls -la /proc/PID/cwd is <defunct>

#SOLUTION: You should implement something like "ps -W". Find the code here: https://github.com/openunix/cygwin/blob/master/winsup/utils/ps.cc


##############################################################################
CHECK THE LOG FILE - MEMORY ISSUES
##############################################################################

#ERROR: In cygwin, no memory buffers, shares and reclaimable concept exist in /proc/meminfo

[CET Dec 22 18:38:39] debug    : system statistic error -- cannot get real memory buffers amount
[CET Dec 22 18:38:39] debug    : system statistic error -- cannot get real memory cache amount
[CET Dec 22 18:38:39] debug    : system statistic error -- cannot get slab reclaimable memory amount

#Solution: We should adopt the functions in /src/proces/sysdep_CYGWIN.c or coment them. But the program works as well. We don't touch the code.

#ERROR: In cygwin "wa" is not valid, we configured this in configure.ac. -> AC_DEFINE([HAVE_CPU_WAIT], [0], inside ARCH="CYGWIN"

##############################################################################
CHECK THE LOG FILE - FILESYSTEM ISSUES
##############################################################################

Inodes are not available on cygwin: https://cygwin.com/ml/cygwin/2012-11/msg00163.html
Monit report 100% inodes free -> Inodes free    4294967295 [100.0%]

##############################################################################
CHECK THE LOG FILE - FILE ISSUES
##############################################################################

check file cygwin_file_test with path /tmp/monit-5.10_cygwin/cygwin_file_test
    if match coffee then alert

It works ok, but it would be nice to have command line tool like: monit filematch pattern file
or reset the "last read line variable to zero", to reread the file.


##############################################################################
RUNNING MONIT AS A SERVICE
##############################################################################
$ cygrunsrv -I ksrd -p '/usr/local/bin/monit.exe' -a '-Ic /etc/monitrc -vv' -d "CYGWIN ksrd"
$ chown system /etc/monitrc
$ ./service.sh start ksrd monit

Start the service ksrd as the user: sshd (put the user in the admin groups).
$ chown sshd /etc/monitrc

Now we can do: monit reload (the file is owned by the service user)

