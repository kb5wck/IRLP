APRSBT
APRS Beacon generator.

APRS is a registered trademark of Bob Bruninga, W4APR

Do you want your node to be displayed on APRS screens throughout the country?  An operating APRS digi or software is not required to include the APRS users in your system.  Utilizing any TNC and VHF radio you can send out your IRLP information to the APRS world to be viewed on the APRS screens.  Additionally, by connecting to www.findu.com on the internet you are able to view the status of your IRLP node.  It will include the time of the last data packet received as well as a map locating the node site.  

This program script generates a text APRS packet that is sent via a TNC. Set up on the APRS VHF frequency of 144.390 Mhz, it allows APRS users to watch and monitor the activity of your IRLP node.  When not connected an APRS packet containing the IRLP Node's Latitude and Longitude, Frequency and offset, and NODE AVAILABLE statement is transmitted every 30 minutes.  When connected to another node or reflector it will transmit the IRLP node number, Latitude/Longitude and Node Number that you are connected to, and Frequency and offset of your station.  Utilizing an APRS formated text,  your callsign is transmitted in the raw packet but only the Node number is displayed on the APRS screen as the APRS object.  This allows the APRS user to view node numbers directly on their maps but have a legal id of the packet.

The Script runs as repeater and is a simple looping program that sends the information out a serial port to a TNC.  Installation requires the user to open the script (using pico -w) and replace the parameters for the aprs_node (node number), aprs_latlong,(latitude and longitude of node), aprsrpt (node frequency and offset), and aprscom (serial port used by your computer to TNC connection).  Once these values are inserted a few lines are added to the rc.irlp script to initialize the serial ports for use and to start the script in the background.  

A note about serial ports.  The equivalent for windows follows: 

Com1 in windows = /dev/ttyS0 in linux
Com2 in windows = /dev/ttyS1 in linux
			(The UPPER CASE "S" is required)

Setup of the TNC parameters requires the user to access the TNC via a com program prior to hooking it up to the IRLP system to ensure it has the appropriate APRS parameters.  The TNC must be in converse mode for proper operation and will be commanded into the converse mode when the program starts.   The parameters running on a MFJ TNC2 at IRLP node 4234 are:

     echo off
     BE E 0
     HEA off
     mycall WA0OJS-1
     headerln off
     mstamp off
     monitor off
     unproto APRS via KB3BLS-1,WIDE,WIDE
     conmode conv
     conok off
     digi off
     cpactime on     
     conv

The script will send a "conv" command when booted so if your tnc is in a power on reset state it will put in in the conv mode.  



SETUP of SCRIPT

I have set up an aprsbeacon directory within the custom directory for the file.  Copy the "aprsbt" file  to the /home/irlp/custom/aprsbeacon directory.  As "ROOT" open rc.irlp with "pico -w" and place the following at the end of the file (the following is for "com1"; substituting the appropriate serial port address for ttyS0):

     echo -n "Setting up serial ports "
        /bin/setserial /dev/ttyS0 auto_irq skip_test autoconfig
        /bin/stty -F /dev/ttyS0 9600      
     echo "done! "

      echo -n "Starting aprsbt ..... "
        /home/irlp/custom/aprsbeacon/aprsbt >&/dev/null 2>&1 &
      echo "done!..."

You will probably need to change the ownership of the serial port so that user repeater can access it.  This is done by logging on as root and typing "chown  repeater /dev/ttyS0 "  

Save this file and open /home/irlp/custom/aprsbeacon/aprsbt with pico -w (as repeater) and edit the following lines:
  Replace your node number, latitude/longitude (IMPORTANT:  LEAVE THE  "L AFTER THE LONGITUDE") and node frequency and offset and com port that your TNC will be connected to:

     aprsnode = "7070"
     aprslatlong = "3900.00N/07600.00WL"
     aprsrpt = "444.850+"
     aprscom = "/dev/ttyS0"
     
Save the file and then as "root" in the custom directory type "./rc.irlp" and the IRLP will restart.  You should see your "IRLP node number and Node Avail on an APRS screen.  Your node number will be the object on the APRS screen.  Connect to a node or reflector and you should see the node number that it is connected to.  This will be retransmitted every 10 minutes while you are connected.  While disconnected it will send out a packet every 30 minutes noting the Node Avail script.     

I hope this give those wanting to share in the fun of IRLP and APRS the ability to provide the information without installing a full blown APRS software package on your IRLP node.  The future of the two modes has much to offer that is well beyond this package but for a simple start this should work.  Have fun.

Ron  WA0OJS Node 7070 and 4234.  www.wa0ojs@arrl.net


