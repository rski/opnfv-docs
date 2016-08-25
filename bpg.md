<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-generate-toc again -->
**Table of Contents**

- [BGP](#bgp)
    - [Definitions](#definitions)
    - [RIB](#rib)
    - [BGP Messages](#bgp-messages)
        - [OPEN](#open)
        - [UPDATE](#update)
        - [KEEPALIVE](#keepalive)
        - [NOTIFICATION](#notification)
- [OPNFV Setup](#opnfv-setup)
    - [Quagga](#quagga)
    - [Thrift](#thrift)
    - [ODL](#odl)
    - [Neutron BGPVPN](#neutron-bgpvpn)

<!-- markdown-toc end -->
# BGP

BGP is a protocol that allows AS (autonomous systems) to exchange routing information.
BGP is implemented over TCP.

    -------                   -------
    | AS1 |   <--tcp<BGP>-->  | AS2 |
    -------                   -------

Useful links:

http://www.enterprisenetworkingplanet.com/netsp/article.php/3615896/Networking-101-Understanding-BGP-Routing.htm
https://www.juniper.net/documentation/en_US/junos13.3/topics/concept/routing-protocol-bgp-security-peering-session-understanding.html
[RFC](https://tools.ietf.org/html/rfc4271)

## Definitions

BGP: Border Gateway protocol
Internal Peer (IBGP) : Peer in the same AS
External Peer (EBGP): Peer in another AS
AS: Autonomous System
RIB: Routing Information Base, where routes are stored
NLRI: Network layer reachability information, part of the BGP update message

## RIB ##

Three tables:
  * Adj-RIBs-in: Routing information learned from other BGP speakers
  * Loc-RIBs: Routing information obtained by applying local policies to Adj-RIBs-in
  * Adj-RIBs-out: Routing information to be sent to peers

## BGP Messages ##

### OPEN ###

Messages that start a connection.

  * Version: BGP version (probably 4)
  * My AS: This 2-octet unsigned integer indicates the Autonomous System
           number of the sender.
  * Hold time: maximum seconds between KEEPALIVE and/or UPDATE messages (time ==0s || time>=3s)
  * BGP Identifier: An IP given to the BGP speaker. Same for all interfaces of the speaker.


### UPDATE ###

Transfer routing information between peers.

  * Withdrawn router length/Withdrawn routes: The length of the withdrawn routes field and the routes withdrawn from service.
  * Total Path Attribute Length: The size of the Path attribute fields
  * Path attributes: A list of <attribute type, attribute length, attribute value>. eg <ORIGIN, 1, 0>
  * Network Layer Reachability Information: Kind of like a list of CIDRs. The IP ranges reachable.

### KEEPALIVE ###

Empty message to keep the connection alive. Only sent if hold time != 0.

### NOTIFICATION ###

   A NOTIFICATION message is sent when an error condition is detected.
   The BGP connection is closed immediately after it is sent.
   Contains information about the error.

# OPNFV Setup #

## Quagga ##

Quagga is the BGP router.

## Thrift ##

An adapter that connects ODL and Quagga

## ODL ##

Configures Neutron to use the BGP routing information and set up a VPN over those routes.
Starts the bgp router.

### Configuration ###

For a configuration example see the [ODL VPNService guide](https://wiki.opendaylight.org/view/Vpnservice:Beryllium_User_Guide)


Steps:

    * Set up mesh tunnels
    Not sure what this exactly is. *TODO* ask Nikolas
    * (Maybe) Start up quagga's bgp daemon.
    * Add the quagga router to ODL. Maybe the previous step is done automatically here.
    * Tell the router about a neighbor
    * Create tunnel interfaces between two switches (which switches?)

The expectation is:

    1. Unique If-index is generated
    2. 'Interface-state' operational DS is updated
    3. Corresponding Nexthop Group Entry is created

At this point, if the nexthop group entry is created, this test will be completed.

Then the guide talks about creating VMs and adding them to the VPN networks. This is handled via the openstack api.



## Neutron BGPVPN ##

http://docs.openstack.org/developer/networking-bgpvpn/
