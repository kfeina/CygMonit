Original README with good help urls by problem

##############################################################################
HOW TO COMPILE MONIT 5.10 ON CYGWIN
##############################################################################
Author KPorta
Mail kfeina at gmail.com
Tested on Cygwin Version 1.7.33 32 bits and gcc 4.8.3

##############################################################################
PACKGAGING
##############################################################################
1- The following packages are required

    Devel - gcc-core, diff , bison, lex, ...

2- Download monit source from httpsmmonit.commonit
$ cd tmp
$ tar xvfz monit-5.10.tar.gz
$ cd monit-5.10

##############################################################################
COMPILE LIBMONIT FIRST
##############################################################################
$ cd libmonit

$ .bootstrap
    Success bootstrapping libmonit

$ autoreconf -i -f
$ automake -acf
$ .configure

#ERROR configure error Architecture not supported CYGWIN_NT-5.2
#SOLUTION In ...libmonitconfigure.ac, search for the # CYGWIN # added lines.

##############################################################################
$ .bootstrap
$ autoreconf -i -f
$ automake -acf
$ .configure

If successful you get
+------------------------------------------------------------+
 License                                                   
 This is Open Source Software and use is subject to the GNU 
 AFFERO GENERAL PUBLIC LICENSE version 3, available in this 
 distribution in the file COPYING.                          
                                                            
 By continuing this installation process, you are bound by  
 the terms of this license agreement. If you do not agree   
 with the terms of this license, you must abort the         
 installation process at this point.                        
+------------------------------------------------------------+
 Libmonit is configured as follows                         
                                                            
   Optimized                                    DISABLED   
   Profiling                                    DISABLED   
+------------------------------------------------------------+


##############################################################################
COMPILE MONIT SECOND
##############################################################################
$ cd ..  (move to the root folder)
$ .bootstrap
    Success bootstrapping libmonit
    Success bootstrapping Monit

$ autoreconf -i -f
$ automake -acf
$ .configure --without-pam --without-ssl --without-largefiles

#ERROR Architecture not supported CYGWIN_NT-5.2
#SOLUTION In configure.ac, search for the # CYGWIN # added lines.

##############################################################################
$ .bootstrap
$ autoreconf -i -f
$ automake -acf
$ .configure

If successful you get

Monit Build Information

                Architecture CYGWIN
              Compiler flags -Wno-address -Wno-pointer-sign -g -O2 -Wall -Wunused -Wno-unused-label -funsigned-char -D_GNU_SOURCE -std=c99 -D _REENTRANT
                Linker flags -lpthread -lcrypt -lresolv
           pid file location varrun
           Install directory usrlocal

+------------------------------------------------------------+
 License                                                   
 This is Open Source Software and use is subject to the GNU 
 AFFERO GENERAL PUBLIC LICENSE version 3, available in this 
 distribution in the file COPYING.                          
                                                            
 By continuing this installation process, you are bound by  
 the terms of this license agreement. If you do not agree   
 with the terms of this license, you must abort the         
 installation process at this point.                        
+------------------------------------------------------------+
 Monit has been configured with the following options      
                                                            
   PAM support                                  DISABLED   
   SSL support                                  DISABLED   
   Large files support                          DISABLED   
   Optimized                                    DISABLED   
+------------------------------------------------------------+

##############################################################################
$ make
#ERROR ICMP_ECHO

    srcp.y En la función ‘yyparse’
    srcp.y99540 error ‘ICMP_ECHO’ no se declaró aquí (primer uso en esta función)
                             icmpset.type = ICMP_ECHO;                                  ^
    ...
    make  [all] Error 2

#SOLUTION In srcnet.h, search for ICMP_ECHO, ICMP_ECHOREPLY  CYGWIN  added lines

##############################################################################
$ make
#ERROR struct icmp in function icmp_echo

    srcnet.c In function 'icmp_echo'
    srcnet.c42439 error invalid use of undefined type 'struct icmp'
    int len_out = offsetof(struct icmp, icmp_data) + DATALEN;

#SOLUTION In srcnet.c, redefinition of icmp_echo function. Raw Sockets (ICMP) are not supported in CYGWIN.
Search for the  CYGWIN  added lines
(httpslists.nongnu.orgarchivehtmlmonit-general2006-06msg00048.html
httplists.gnu.orgarchivehtmlmonit-dev2006-06msg00026.html
httpscygwin.commlcygwin2010-01msg00187.html)

You can implement something like
httpmarc.infol=squid-dev&m=107956877111783

##############################################################################
$ make
#ERROR struc timeval collected

    In file included from srcl.l520
    srcmonit.h42924 error field 'collected' has incomplete type
             struct timeval collected;                     When were data collected 
    ...                     ^
    make  [all] Error 2

#SOLUTION In srcmonit.h, search for HAVE_SYS_TIME_H in  CYGWIN  added lines (httpswww.cygwin.commlcygwin2014-07msg00041.html)

##############################################################################
$make
#ERROR No srcdevicesysdep_CYGWIN.c file exists.
    make[2]  No rule to make target 'srcdevicesysdep_CYGWIN.c', needed by 'srcdevicesysdep_CYGWIN.o'.  Stop.
    ...
    make  [all] Error 2

#SOLUTION device sysdep cygwin dependencies must be created. cp file srcdevicesysdep_Linux.c srcdevicesysdep_CYGWIN.c

##############################################################################
$make
#ERROR No srcprocesssysdep_CYGWIN.c file exists.
    GNU_SOURCE -std=c99 -D _REENTRANT -c -o srcprocessprocess_common.o srcprocessprocess_common.c
    make[2]  No rule to make target 'srcprocesssysdep_CYGWIN.c', needed by 'srcprocesssysdep_CYGWIN.o'.  Stop.
    ...
    make  [all] Error 2

#SOLUTION process sysdep cygwin dependencies must be created. cp file srcprocesssysdep_Linux.c srcprocesssysdep_CYGWIN.c

##############################################################################
$make
#ERROR GLOB_ONLYDIR not defined in sysdep_CYGWIN.c
    srcprocesssysdep_CYGWIN.c In function 'initprocesstree_sysdep'
    srcprocesssysdep_CYGWIN.c21734 error 'GLOB_ONLYDIR' undeclared (first use in this function)
       if ((rv = glob(proc[0-9], GLOB_ONLYDIR, NULL, &globbuf))) {
    ...
    make  [all] Error 2

#SOLUTION In srcprocesssysdep_CYGWIN.c, search for GLOB_ONLYDIR in  CYGWIN  added lines, moved to monit.h:

https://cygwin.com/pipermail/cygwin/2014-December/218835.html

In monit.h add: 
#ifndef GLOB_ONLYDIR
#define GLOB_ONLYDIR 0
#endif
  


##############################################################################
FINALLY WE GOT THE PROGRAM
##############################################################################
$ make
$ echo $
0
$ ls -la monit.exe
-rwxr-xr-x 1 Admin Domain Users 1523737 Dec 22 1820 monit.exe

##############################################################################
$ make install

##############################################################################
START THE PROGRAM
##############################################################################
$ monit -vv -t monitrc_cygwin
Control file syntax OK

##############################################################################
$ monit -vv -c monitrc_cygwin
The control file 'tmpmonit-5.10_cygwinmonitrc_cygwin' must have permissions no more than -rwx------ (0700);
right now permissions are -rwxr-xr-x (0755).

$ chmod 0700 monitrc_cygwin
##############################################################################
$ monit -vv -c monitrc_cygwin

-------------------------------------------------------------------------------
$ pidfile 'homek.monit.pid' does not exist
$ Starting Monit 5.10 daemon with http interface at [mycomputer2812]
$ Monit start delay set -- pause for 5s

##############################################################################

##############################################################################
CHECK THE LOG FILE - PROCESS ISSUES
##############################################################################

#ERROR Windows pure process are not mathed. Windows processes launch by cygwin like notepad & are not mattched.
Process matching works OK inside cygwin with PURE cygwin processes monit procmatch bash - process match.
For non PURE windows process the link to ls -la procPIDcwd is defunct

#SOLUTION You should implement something like ps -W. Find the code here httpsgithub.comopenunixcygwinblobmasterwinsuputilsps.cc


##############################################################################
CHECK THE LOG FILE - MEMORY ISSUES
##############################################################################

#ERROR In cygwin, no memory buffers, shares and reclaimable concept exist in procmeminfo

[CET Dec 22 183839] debug     system statistic error -- cannot get real memory buffers amount
[CET Dec 22 183839] debug     system statistic error -- cannot get real memory cache amount
[CET Dec 22 183839] debug     system statistic error -- cannot get slab reclaimable memory amount

#Solution We should adopt the functions in srcprocessysdep_CYGWIN.c or coment them. But the program works as well. We don't touch the code.

#ERROR In cygwin wa is not valid, we configured this in configure.ac. - AC_DEFINE([HAVE_CPU_WAIT], [0], inside ARCH=CYGWIN

##############################################################################
CHECK THE LOG FILE - FILESYSTEM ISSUES
##############################################################################

Inodes are not available on cygwin httpscygwin.commlcygwin2012-11msg00163.html
Monit report 100% inodes free - Inodes free    4294967295 [100.0%]

##############################################################################
CHECK THE LOG FILE - FILE ISSUES
##############################################################################

check file cygwin_file_test with path tmpmonit-5.10_cygwincygwin_file_test
    if match coffee then alert

It works ok, but it would be nice to have command line tool like monit filematch pattern file
or reset the last read line variable to zero, to reread the file.


##############################################################################
RUNNING MONIT AS A SERVICE
##############################################################################
$ cygrunsrv -I ksrd -p 'usrlocalbinmonit.exe' -a '-Ic etcmonitrc -vv' -d CYGWIN ksrd
$ chown system etcmonitrc
$ .service.sh start ksrd monit

Start the service ksrd as the user sshd (put the user in the admin groups).
$ chown sshd etcmonitrc

Now we can do monit reload (the file is owned by the service user)