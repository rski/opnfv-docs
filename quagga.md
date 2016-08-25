Quagga
======

Quagga implements a BGP router. This document explains how to use both vanilla Quagga and ODL/OPNFV-quagga to set up BGP routers and pair them.

A very useful hands-on introduction can be found [here](https://openmaniak.com/quagga_tutorial.php)

# Vanilla Quagga #

To install on Ubuntu:

    sudo apt install quagga

## GBP Peering ##

An example can be found on [Xmodulo](http://xmodulo.com/centos-bgp-router-quagga.html)

# OPNFV-Quagga #

The source can be found [here](https://github.com/nikolas-hermanns/opnfv-quagga-packaging)

## Differences from Vanilla ##

From the project's README:

    Package is based on official Quagga from http://www.quagga.net/ and Quagga Source is pulled during the build from the official Git. In addition to Quagga, this package will add the Thrift Interface to integrate Quagga into OPNFV

OPNFV quagga does not start the zebra daemon or any other daemon. Instead it starts the `opnfv-quagga` service, which is a daemon that interfaces quagga with ODL. The quagga bgpd is started by ODL when a rest call to create a router is sent to it.

## Rest calls ##

### Routers ###

GET http://172.16.0.16:8181/restconf/config/bgp:bgp-router/

DELETE http://172.16.0.16:8181/restconf/config/bgp:bgp-router/

PUT http://172.16.0.16:8181/restconf/config/bgp:bgp-router/

    {
        "bgp-router": {
            "local-as-identifier": "10.10.10.10",
            "local-as-number": 108
        }
    }

# Useful commands #

    ps aux | grep quagga

    netstat -ptuna | grep "bgpd\|zebra"

    telnet localhost $PORT
    telnet localhost 2605 # for bgpd

    vtysh
    vtysh -d bgpd
