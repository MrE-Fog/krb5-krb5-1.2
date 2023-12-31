.\" Copyright (c) 1983 Regents of the University of California.
.\" All rights reserved.  The Berkeley software License Agreement
.\" specifies the terms and conditions for redistribution.
.\"
.\"	@(#)rlogind.8c	6.3 (Berkeley) 5/24/86
.\"
.TH KLOGIND 8C
.SH NAME
klogind \- remote login server
.SH SYNOPSIS
.B klogind
[
.B \-kr54cpPe
]
[
[ \fB\-w\fP[\fBip\fP|\fImaxhostlen\fP[\fB,\fP[\fBno\fP]\fBstriplocal\fP]] ]
.SH DESCRIPTION
.I Klogind
is the server for the 
.IR rlogin (1C)
program.  The server is 
based on rlogind(8C) but uses Kerberos authentication.
.PP
The 
.I klogind
server is invoked by \fIinetd(8c)\fP when it receives a connection on
the port indicated in /etc/inetd.conf.  A typical /etc/inetd.conf
configuration line for \fIklogind\fP might be:

klogin stream tcp nowait root /usr/cygnus/sbin/klogind klogind -e5c

When a service request is received, the following protocol is initiated:

.IP 1)
Check authentication.
.IP 2)
Check authorization via the access-control files \fI.k5login\fP, \fI.klogin\fP 
and \fI.rhosts\fP in the user's home directory.
.IP 3)
Prompt for password if any checks fail and the \fI-p\fP option was supplied.
.PP
If the authentication succeeds, login the user by calling the accompanying 
login.krb5 or /bin/login, according to the definition of 
DO_NOT_USE_K_LOGIN.  
.PP 
The configuration of \fIklogind\fP is done
by command line arguments passed by inetd.  The options are:
.IP \fB\-5\fP 10
Allow Kerberos V5 authentication with the \fI.k5login\fP access control
file to be trusted.  If this authentication system is used by the client
and the authorization check is passed, then the user is allowed to log
in.

.IP \fB\-4\fP 
Allow Kerberos V4 authentication with the \fI.klogin\fP access control
file to be trusted.  If this authentication system is used by the client
and the authorization check is passed, then the user is allowed to log
in.

.IP \fB\-k\fP 
Allow Kerberos V5 and Kerberos V4 as acceptable authentication
mechanisms.  This is the same as including \fB\-4\fP and \fB\-5\fP.


.IP \fB\-p\fP
 If all other authorization checks fail, prompt the user
for a password If this option is not included, access is denied
without successful authentication and authorization using one of the
previous mechanisms.

.IP \fB\-P\fP
Prompt the user for a password.
If the -P option is passed, then the password is verified in addition
to all other checks.

.IP \fB\-e\fP
Create an encrypted session. 

.IP \fB\-c\fP 
Require Kerberos V5 clients to present a cryptographic checksum of
initial connection information like the name of the user that the client
is trying to access in the initial authenticator.  This checksum
provides additionl security by preventing an attacker from changing the
initial connection information.  To benefit from this security, only
Kerberos V5 should be trusted; Kerberos V4 and rhosts authentication do
not include this checksum.  If this option is specified, older Kerberos
V5 clients that do not send a checksum in the authenticator will not be
able to authenticate to this server.  This option is mutually exclusive
with the \fB-i\fP option.

	If neither the \fB-c\fP or \fB-i\fP options are specified,then
checksums are validated if presented.  Since it is difficult to remove
a checksum from an authenticator without making the authenticator
invalid, this default mode is almost as significant of a security
improvement as \fB-c\fP if new clients are used.  It has the additional
advantage of backwards compatability with some clients.
Unfortunately, clients before Kerberos V5, Beta5, generate invalid
checksums; if these clients are used, the \fB-i\fP option must be
used.

.IP \fB\-i\fP 
Ignore authenticator checksums if provided.  This option
ignore authenticator checksusm presented by current Kerberos clients
to protect initial connection information; it is the opposite of
\fB-c\fP.  This option is provided because some older
clients--particularly clients predating the release of Kerberos V5
Beta5 (May 1995)--present bogus checksums that prevent Kerberos
authentication from succeeding in the default mode.


.PP
If the
~/.rhosts check is to be used, then the program verifies that the
client is connecting from a privileged port, before allowing login.

.PP
The parent of the login process manipulates the master side of the
pseduo terminal, operating as an intermediary between the login
process and the client instance of the
.I rlogin(1C)
program.  In normal operation, the packet protocol described in
.IR pty (4)
is invoked to provide ^S/^Q type facilities and propagate interrupt
signals to the remote programs.  The login process propagates the
client terminal's baud rate and terminal type, as found in the
environment variable, ``TERM''; see
.IR environ (7).
The screen or
window size of the terminal is requested from the client, and window
size changes from the client are propagated to the pseudo terminal.

.PP
.I Klogind
supports the following options to control the form of the hostname
passed to login(1):

.TP
\fB\-w \fP[\fBip\fP|\fImaxhostlen\fP[\fB,\fP[\fBno\fP]\fBstriplocal\fP]]
Controls the form of the remote hostname passed to login(1).
Specifying \fBip\fP results in the numeric IP address always being
passed to login(1).  Specifying a number, \fImaxhostlen\fP, sets the
maximum length of the hostname passed to login(1) before it will be
passed as a numeric IP address.  If \fImaxhostlen\fP is 0, then the
system default, as determined by the utmp or utmpx structures, is
used.  The \fBnostriplocal\fP and \fBstriplocal\fP options, which must
be preceded by a comma, control whether or not the local host domain
is stripped from the remote hostname.  By default, the equivalent of
\fBstriplocal\fP is in effect.

.PP
.I Klogind
supports three options which are used for testing
purposes:

.IP \fB\-S\ keytab\fP 10
Set the \fIkeytab\fP file to use.

.IP \fB\-M\ realm\fP
Set the Kerberos realm to use.

.IP \fB\-L\ login\fP
Set the login program to use.  This option only has an effect if
DO_NOT_USE_K_LOGIN was not defined when
.I klogind
was compiled.
.SH DIAGNOSTICS
All diagnostic messages are returned on the connection
associated with the
.BR stderr ,
after which any network connections are closed.
An error is indicated by a leading byte with a value of 1.
.PP
.B ``Try again.''
.br
A
.I fork
by the server failed.
.PP
.B ``/bin/sh: ...''
.br
The user's login shell could not be started.
.SH SEE ALSO
rlogind(8C), rlogin(1C)
.SH BUGS
A more extensible protocol should be used.
