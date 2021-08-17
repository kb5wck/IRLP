#!/bin/sh
#
if ! (grep aprs_status /home/irlp/custom/custom.crons >/dev/null) ; then
  echo "Installing CRON entry"
  MIN=$[ $RANDOM % 60 ]
  if [ "$MIN" -le "9" ] ; then MIN=0$MIN ; fi
  echo "" >> /home/irlp/custom/custom.crons
  echo "# Run the aprs_status script every 60 minutes, with a random offset " >> /home/irlp/custom/custom.crons
  echo $MIN" * * * * (/home/irlp/custom/aprs_status >/dev/null 2>&1)" >> /home/irlp/custom/custom.crons
  chown repeater.repeater /home/irlp/custom/custom.crons
fi
  
