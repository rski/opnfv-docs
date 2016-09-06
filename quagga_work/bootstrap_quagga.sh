#/bin/bash
set +xe

DEBIAN_FRONTEND=noninteractive apt-get -y install quagga

# Set up quagga's bgpd
cat <<EOF > /etc/quagga/daemons
zebra=no
bgpd=yes
ospfd=no
ospf6d=no
ripd=no
ripngd=no
isisd=no
babeld=no
EOF

if [ -z "$FUNCTEST_CONTAINER_IP" ]; then
    echo "FUNCTEST_CONTAINER_IP is not set properly"
    exit 1
fi

if [ -z "$CONTROLLER_IP" ]; then
    echo "CONTROLLER_IP is not set properly"
    exit 1
fi

# create a log file for bgpd and make sure bgpd can access it
BGPD_LOG='/var/log/quagga/bgpd.log'
touch $BGPD_LOG
chown quagga.quagga $BGPD_LOG

cat <<EOF > /etc/quagga/bgpd.conf
! -*- bgp -*-

hostname bgpd
password zebra
log file $BGPD_LOG

router bgp 200
 bgp router-id $FUNCTEST_CONTAINER_IP
 neighbor $CONTROLLER_IP remote-as 100
 no neighbor $CONTROLLER_IP activate
!
 address-family vpnv4 unicast
 neighbor $CONTROLLER_IP activate
 exit-address-family
!
line vty
 exec-timeout 0 0
!
end
EOF

# make sure bgpd has started, exit with failure if not
service quagga restart
pgrep bgpd
exit $?
