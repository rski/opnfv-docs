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

if [ -z "$FUNCTEST_CONTAINER_NET" ]; then
    echo "FUNCTEST_CONTAINER_NET is not set properly"
    exit 1
fi

if [ -z "$CONTROLLER_IP" ]; then
    echo "CONTROLLER_IP is not set properly"
    exit 1
fi

cat <<EOF > /etc/quagga/bgpd.conf
! -*- bgp -*-

hostname bgpd
password zebra
router bgp 200
 bgp router-id $FUNCTEST_CONTAINER_IP
 network $FUNCTEST_CONTAINER_NET
 neighbor $CONTROLLER_IP remote-as 100
 access-list all permit any
log stdout
EOF


# make sure bgpd has started, exit with failure if not
service quagga restart
pgrep bgpd
exit $?
