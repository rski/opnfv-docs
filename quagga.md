Quagga
======

Quagga implements a BGP router. This document explains how to use both vanilla Quagga and ODL/OPNFV-quagga to set up BGP routers and pair them.

A very useful hands-on introduction can be found [here](https://openmaniak.com/quagga_tutorial.php)

# Vanilla Quagga #

## Setting up bgpd manually ##

Install quagga:

    sudo apt install quagga -y

## GBP Peering ##

An example can be found on [Xmodulo](http://xmodulo.com/centos-bgp-router-quagga.html)

# OPNFV-Quagga #

The source can be found [here](https://github.com/nikolas-hermanns/opnfv-quagga-packaging)

## Differences from Vanilla ##

From the project's README:

    Package is based on official Quagga from http://www.quagga.net/ and Quagga Source is pulled during the build from the official Git. In addition to Quagga, this package will add the Thrift Interface to integrate Quagga into OPNFV

OPNFV quagga does not start the zebra daemon or any other daemon. Instead it starts the `opnfv-quagga` service, which is a daemon that interfaces quagga with ODL. The quagga bgpd is started by ODL when a rest call to create a router is sent to it.


## Adding routers and peering ##

    export own_ip=<your-managment-ip-which-is-reachable-by-the-router>
    export remote_ip=<the-manamnet-ip-of-the-router>
    /opt/opendaylight/bin/client -u karaf "odl:configure-bgp -op start-bgp-server --as-num 100 --router-id $own_ip"
    /opt/opendaylight/bin/client -u karaf "odl:configure-bgp -op add-neighbor --ip $remote_ip --use-source-ip $own_ip --as-num 100"
    
eg 

    odl:configure-bgp -op start-bgp-server --as-num 100 --router-id 192.168.2.12
    configure-bgp -op add-neighbor --ip 192.168.2.11 --use-source-ip 192.168.2.12 --as-num 200

and 

     configure-bgp -op add-neighbor --ip 192.168.2.11 --use-source-ip 192.168.2.12 --as-num 200
     odl:configure-bgp -op stop-bgp-server


Note that if the opnfv-quagga service has restarted, the opendaylight service needs to be restarted as well.

[Source](https://wiki.opnfv.org/display/ds/Peer+Opendaylight+with+a+BGP+router)

## Get quagga information from ODL ##

To get a list of bgp neighbors:

    /opt/opendaylight/bin/client -u karaf "odl:show-bgp  --cmd \"bgp neighbors\""

The state of the peer should be Established.

Also:

    /opt/opendaylight/bin/client -u karaf "display-bgp-config"


## Rest calls ##

### Routers ###

N.B. These do not start the quagga service like odl:configure-bgp does.

GET http://172.16.0.16:8181/restconf/config/bgp:bgp-router/

DELETE http://172.16.0.16:8181/restconf/config/bgp:bgp-router/

PUT http://172.16.0.16:8181/restconf/config/bgp:bgp-router/

    {
        "bgp-router": {
            "local-as-identifier": "10.10.10.10",
            "local-as-number": 108
        }
    }
    
### Troubleshooting the router ###


Note that if the opnfv-quagga service has restarted, the opendaylight service needs to be restarted as well.

Check that the bgpd service can be started manually. This will fail if the config file is malformed:

    /usr/lib/quagga/bgpd -f /usr/lib/quagga/qthrift/bgpd.conf

To start it like opendaylight does:

    /usr/lib/quagga/bgpd -f /usr/lib/quagga/qthrift/bgpd.conf -p 0 -Z ipc:///tmp/qzc-100


# Useful commands #

    ps aux | grep quagga
    watch -d "ps aux | grep bgp"

    netstat -ptuna | grep "bgpd\|zebra"

    telnet localhost $PORT
    telnet localhost 2605 # for bgpd

    vtysh
    vtysh -d bgpd
