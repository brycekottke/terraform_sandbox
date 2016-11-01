#!/bin/bash
apt-get update
apt-get upgrade -y
wget http://swupdate.openvpn.org/as/openvpn-as-2.1.4-Ubuntu16.amd_64.deb -O /tmp/openvpn.deb
dpkg --install /tmp/openvpn.deb
rm /tmp/openvpn.deb
reboot now
