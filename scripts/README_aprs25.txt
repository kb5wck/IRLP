# aprs_status  IRLP node status reporting via APRS
#
# v1.0 26 April 2003 - Geoff VK2XJG
# v1.1 15 May 2003 - Added node callsign to extra text area of beacon
# v2.0 12 June 2005 - major re-write to change to TCP connections to 
#            APRSSD server, plus allow user config of more values
#		 TNC and TTY support has been removed
# v2.1 14 June 2005 - update from sugestions received D7 mode support,
#             improve README
# v2.2 25 June 2005 -ZL1AMW - further update of README and notes in .conf file
#                         - bugfix for simplex frequencies
# v2.3 26 June 2005 -ZL1AMW - improved enviro variable loading
# v2.4 01 July 2005 - ZL1AMW - fix bug with 1 digit day of month
# v2.5 05 July 2005 - ZL1AMW - allow 3 digit node numbers
#

OVERVIEW
========
This script intends to combine IRLP and APRS together, in the IPRS or AVRS concept of
APRS Author Bob Bruninga WB4APR. 

See also http://web.usna.navy.mil/~bruninga/avrs.html

This script will transmit the current status of the node to the local APRS network, as 
well as make the status and location of nodes available on the global APRS-IS network.

This version 2.x script is developed by ZL1AMW, from a version 1.x script by VK2XJG.

Note there is a significant change from vn 1 of this script.  The previous version sent
station beacons with the callsign STNxxxx, this version sends the status as an APRS object,
with the node call as the origonator's callsign.  The change means the data sent is
from a valid amateur callsign, so will pass through IGATES.

This version no longer supports a local TNC or radio.

NOTES ON IRLP-APRS INTERFACE
============================

APRS is an excellent medium for local operators to be made aware of your node name, 
frequency and current status.

The IRLP node operator does not have to have any APRS equipment, or any knowledge 
of the APRS network, the script just sends data to the APRS system in the same manner 
that all other APRS stations do.

For the object to appear on APRS RF, it then needs to transit through an IGATE somewhere, 
but this should happen automatically, any IGATE set up to gateway APRS traffic from the 
area and/or callsign district of the IRLP node will send the object to RF, unless they 
have specifically decided to filter individual callsigns (which is unusual).

You must enter an APRS server name, and a valid connecting port for that server. It 
is unimportant which APRS server the data is sent too, they are all inter-connected 
through the APRS network. You can view a list of servers and their available ports
at serverlist.aprswest.com

For a quick map view of all the nodes running this or similar APRS scripts, have a look at:
http://www.findu.com/cgi-bin/find.cgi?irlp*

On an APRS programme running at home, the IRLP nodes show up as an icon amongst other 
stations, with the frequency and current state (linked, idle etc) displayed.


OPERATION
=========
The aprs_status script is called periodically (60 minutes) from custom.crons, and sends
an APRS format beacon to the APRS-IS network.  To make this script effective in real time mode, it is also
called from both custom_on and custom_off, so that it captures change of status of the 
node in real time.

Whenever the node is idle (LINK CLEAR), the APRS beacon indicates this.
If the node is connected to another node or reflector, this is indicated in the beacon,
as well as the ID of the connected station (LINKED TO ..).
If the node is OFFLINE (disabled) this too is captured in the APRS beacon.

Each status is represented by a different (configurable) overlay letter on the APRS symbol,
and text in the beacon comment.


INSTALLATION
============
The file aprs_status-xx.tgz should be copied to the root directory of your system (cd /)
then issue the command:

tar -xzvf aprs_status-2.0.tgz

This will in-zip the files and place them in the appropiate directories.

After installation you will need to add the line:

$CUSTOM/aprs_status

to both custom_on and custom_off.  You also need to ensure that CUSTOM_ON=YES and 
CUSTOM_OFF=YES in your $CUSTOM/environment file.  Without these, there will be no beacon as
your node changes status!

Next configure the aprs_status.conf file as described below.


SETTING UP YOUR APRS BEACON
===========================
You must edit the contents of the file aprs_status.conf

Each entry has comments within the aprs_status.conf file describing what is required.

Take special note of:
- your longitude must be three digits of degrees, followed by 2 digits of minutes, then
two digits of decimal minutes then E or W (DDDMM.mm), eg: for 88 degrees, 8.56 minutes,
enter 08808.56W.
- your latitude must be two digits of degrees, 2 digits of minutes then two diits of 
decimal minutes.
- You must enter a valid aprs_port on teh server you have selected.  These vary for 
different servers.  You can check what ports are available on a server by browing to the
server name, and port 14501, eg enter: http://first.aprs.net.nz:14501 into your browser.


APRS VALIDATION NUMBER
======================
Stations sending APRS beacons to the internet server must have an APRS Validation number
if they wish to have their beacon transmited through IGATE stations to radio channels.  This 
validation number must match the amateur callsign. A validation number can be obtained from 
many sources,including some APRS client programmes, some sofwtare writers, and through internet
resources. If you do not have an valisation number for your node callsign, and cannot identify
a source, send an email to the author of this scrpt version, zl1amw@zl1amw.info


D7 MODE
=======
The standard format of the beacon is verbose, describing Node access parameters:
146.950MHz, - offset PL tone 103.5: LINK CLEAR

An alternative format, more suitable for the 20 character display of a
D7A is available:
146.950MHz- PL103.5: LINK CLEAR

To select the D7 mode,enter D7=Y in the config file.


SETTING UP THE CUSTOM CRON
==========================
To update your custom cron to schedule running aprs_status script regularly,
run the update in the /tmp file with the command:

sh post_install_aprs.sh 

This will write the new entries in your custom_crons you then must enter:

update files 

to read the custom crons into the system.

