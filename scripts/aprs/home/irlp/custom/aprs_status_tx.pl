#!/usr/bin/perl
#
# Perl script to send a in APRS format.
#
#  Modified from similar script (author unknown, possibly VK2XJG)
#            by ZL1AMW 12 June 2005
#    - Now uses command line variables for configuration
#    - Now uses TCP connections to server 
#
# -----------------------------------------
#

# load the beacon data set uo by aprs_status bash script

$aprsdata = '/home/irlp/local/aprs_data';
open(INFO, $aprsdata);
$beacon = <INFO>;
close(INFO);

use Socket;

# recover variables from aprs_status bash script:
#
$aprsServer = $ARGV[0];
$port = $ARGV[1];
$aprs_call=$ARGV[2];
$aprs_validation = $ARGV[3];


$logon = "User $aprs_call pass $aprs_validation vers IRLP-interface 1
";

($d1, $d2, $d3, $d4, $rawserver) = gethostbyname($aprsServer);
$serveraddr = pack("Sna4x8",2,$port,$rawserver);
$prototype = getprotobyname('tcp');

# Connect to server

socket(SOCKET,PF_INET, SOCK_STREAM,$prototype) || die("No Socket\n");
connect(SOCKET, $serveraddr) || die "no connect: $!";

# Send  to the Internet...

send SOCKET, $logon , 0,  $serveraddr;
send SOCKET, "$aprs_call$beacon" , 0 , $serveraddr;

# Close connection

close(SOCKET);
