<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-generate-toc again -->
**Table of Contents**

- [BPG Overview](#bpg-overview)
- [OPNFV Setup](#opnfv-setup)
    - [Quagga](#quagga)
        - [Thrift](#thrift)
    - [ODL](#odl)

<!-- markdown-toc end -->
# BPG Overview

BGP is a protocol that allows AS (autonomous systems) to exchange routing information.
BGP is implemented over TCP.

    -------                   -------
    | AS1 |   <--tcp<BGP>-->  | AS2 |
    -------                   -------

Useful links:

http://www.enterprisenetworkingplanet.com/netsp/article.php/3615896/Networking-101-Understanding-BGP-Routing.htm
https://www.juniper.net/documentation/en_US/junos13.3/topics/concept/routing-protocol-bgp-security-peering-session-understanding.html
[RFC](https://tools.ietf.org/html/rfc4271)


# OPNFV Setup

## Quagga

Quagga is the BGP router.

## Thrift

An adapter that connects ODL and Quagga

## ODL

Not sure what it does yet...
