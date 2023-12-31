/*
 *	KerberosHeaders.pch
 *
 *	Script to generate the 'MacHeaders<xxx>' precompiled header for Metrowerks C/C++.
 *  Copyright � 1993 metrowerks inc.  All rights reserved.
 * Modified for Kerberos5 Mac port to include compile options
 */
 
#include "autoconf.h"

/*
 * Add the compile flag switches for kerberos compile
 */
#define KRB5 1

#define HAVE_SRAND
#define NO_PASSWORD
#define HAVE_LABS
#define ANSI_STDIO
#define USE_CCAPI

#include <unix.h>
#include <ctype.h>
#include <KerberosSupport/SocketErrors.h>
#include <unistd.h>

#define PROVIDE_RSA_MD4
#define PROVIDE_RSA_MD5
#define PROVIDE_CRC32
#define PROVIDE_DES_CBC_CKSUM
#define PROVIDE_DES_CBC_CRC
#define PROVIDE_DES_CBC_MD5
#define PROVIDE_DES_CBC_RAW
/* #define PROVIDE_DES3_CBC_MD5 */
/* #define PROVIDE_DES3_CBC_RAW */
/* #define PROVIDE_NIST_SHA */

#define NO_SYS_TYPES_H
#define NO_SYS_STAT_H

//jfm need to reimplement
#define mktemp(a)

enum {
EROFS  = 30,
/*ENFILE = 23*/
};
