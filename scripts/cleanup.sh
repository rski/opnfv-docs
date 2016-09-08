#!/bin/env bash

nova delete sdnvpn-4-1
nova delete sdnvpn-4-2
nova delete sdnvpn-4-3
nova delete sdnvpn-4-4
nova delete sdnvpn-4-5

vpnid=$(neutron bgpvpn-list  | awk '{print $2}' | grep -v '^$' | tail -1)

nassocid=$(neutron bgpvpn-net-assoc-list ${vpnid} | awk '{print $2}' | grep -v '^$' | tail -1)
rassocid=$(neutron bgpvpn-router-assoc-list ${vpnid} | awk '{print $2}' | grep -v '^$' | tail -1)

neutron bgpvpn-net-assoc-delete $nassocid $vpnid
neutron bgpvpn-router-assoc-delete $rassocid $vpnid
neutron bgpvpn-delete $vpnid


neutron router-gateway-clear sdnvpn-4-1-router
neutron router-gateway-clear sdnvpn-4-2-router

neutron router-interface-delete sdnvpn-4-1-router sdnvpn-4-1-subnet
neutron router-interface-delete sdnvpn-4-2-router sdnvpn-4-2-subnet

neutron router-delete sdnvpn-4-1-router
neutron router-delete sdnvpn-4-2-router

neutron subnet-delete sdnvpn-4-1-subnet
neutron subnet-delete sdnvpn-4-2-subnet


neutron net-delete sdnvpn-4-1-net
neutron net-delete sdnvpn-4-2-net
