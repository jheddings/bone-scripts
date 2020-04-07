#!/bin/bash

# Often, the WiFi adapter does not come up on boot and the USB network
# interfaces cause routing problems.  This script will reset the WiFi
# interface and disable the USB interfaces.

################################################################################
safe_ifdown() {
  IFACE=$1
  STAT=`ifconfig -s | grep $IFACE`
  if [ -n "$STAT" ] ; then
    ifconfig $IFACE down
  fi
}

################################################################################
safe_ifup() {
  IFACE=$1
  STAT=`ifconfig -s | grep $IFACE`
  if [ -z "$STAT" ] ; then
    ifconfig $IFACE up
  fi
}

logger 'fix_inet: disable wifi'

# bring down wifi temporarilly
# TODO first check if wifi is enabled...
connmanctl disable wifi > /dev/null

logger 'fix_inet: disable usb interfaces'

# turn off USB network interfaces
safe_ifdown usb0
safe_ifdown usb1

logger 'fix_inet: enable wifi'

# bring back up wifi
connmanctl enable wifi > /dev/null
safe_ifup wlan0

logger 'fix_inet: finished'
