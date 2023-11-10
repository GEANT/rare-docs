# Example: bgp l3evpns change in metric

=== "Topology"

    ![Alt text](../d2/rout-bgp818/rout-bgp818.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    vrf def v2
     rd 1:2
     rt-both 1:2
     exit
    vrf def v3
     rd 1:3
     rt-both 1:3
     exit
    vrf def v4
     rd 1:4
     rt-both 1:4
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v2
     ipv4 addr 9.9.2.1 255.255.255.255
     ipv6 addr 9992::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo3
     vrf for v3
     ipv4 addr 9.9.3.1 255.255.255.255
     ipv6 addr 9993::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo4
     vrf for v4
     ipv4 addr 9.9.4.1 255.255.255.255
     ipv6 addr 9994::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff:ffff::
     mpls enable
     exit
    router bgp4 1
     vrf v1
     address evpn
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 1
     neigh 1.1.1.2 route-reflect
     neigh 1.1.1.2 send-comm both
     neigh 1.1.1.3 remote-as 1
     neigh 1.1.1.3 route-reflect
     neigh 1.1.1.3 send-comm both
     neigh 1.1.1.4 remote-as 1
     neigh 1.1.1.4 route-reflect
     neigh 1.1.1.4 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 import evpn
     afi-vrf v2 export evpn
     afi-vrf v3 ena
     afi-vrf v3 red conn
     afi-vrf v3 import evpn
     afi-vrf v3 export evpn
     afi-vrf v4 ena
     afi-vrf v4 red conn
     afi-vrf v4 import evpn
     afi-vrf v4 export evpn
     exit
    router bgp6 1
     vrf v1
     address evpn
     local-as 1
     router-id 6.6.6.1
     neigh 1234:1::2 remote-as 1
     neigh 1234:1::2 route-reflect
     neigh 1234:1::2 send-comm both
     neigh 1234:1::3 remote-as 1
     neigh 1234:1::3 route-reflect
     neigh 1234:1::3 send-comm both
     neigh 1234:1::4 remote-as 1
     neigh 1234:1::4 route-reflect
     neigh 1234:1::4 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 import evpn
     afi-vrf v2 export evpn
     afi-vrf v3 ena
     afi-vrf v3 red conn
     afi-vrf v3 import evpn
     afi-vrf v3 export evpn
     afi-vrf v4 ena
     afi-vrf v4 red conn
     afi-vrf v4 import evpn
     afi-vrf v4 export evpn
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    vrf def v2
     rd 1:2
     rt-both 1:2
     exit
    vrf def v3
     rd 1:3
     rt-both 1:3
     exit
    vrf def v4
     rd 1:4
     rt-both 1:4
     exit
    bridge 1
     mac-learn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v2
     ipv4 addr 9.9.2.2 255.255.255.255
     ipv6 addr 9992::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo3
     vrf for v3
     ipv4 addr 9.9.3.2 255.255.255.255
     ipv6 addr 9993::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo4
     vrf for v4
     ipv4 addr 9.9.4.2 255.255.255.255
     ipv6 addr 9994::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234:1::2 ffff:ffff::
     mpls enable
     exit
    route-map rm1
     sequence 10 act deny
     sequence 10 match metric 4000-6000
     sequence 20 act perm
     exit
    router bgp4 1
     vrf v1
     address evpn
     local-as 1
     router-id 4.4.4.2
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 send-comm both
     neigh 1.1.1.1 evpn-route-map-in rm1
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 import evpn
     afi-vrf v2 export evpn
     afi-vrf v3 ena
     afi-vrf v3 red conn
     afi-vrf v3 import evpn
     afi-vrf v3 export evpn
     afi-vrf v4 ena
     afi-vrf v4 red conn
     afi-vrf v4 import evpn
     afi-vrf v4 export evpn
     exit
    router bgp6 1
     vrf v1
     address evpn
     local-as 1
     router-id 6.6.6.2
     neigh 1234:1::1 remote-as 1
     neigh 1234:1::1 send-comm both
     neigh 1234:1::1 evpn-route-map-in rm1
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 import evpn
     afi-vrf v2 export evpn
     afi-vrf v3 ena
     afi-vrf v3 red conn
     afi-vrf v3 import evpn
     afi-vrf v3 export evpn
     afi-vrf v4 ena
     afi-vrf v4 red conn
     afi-vrf v4 import evpn
     afi-vrf v4 export evpn
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    vrf def v2
     rd 1:2
     rt-both 1:2
     exit
    vrf def v3
     rd 1:3
     rt-both 1:3
     exit
    vrf def v4
     rd 1:4
     rt-both 1:4
     exit
    bridge 1
     mac-learn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v2
     ipv4 addr 9.9.2.3 255.255.255.255
     ipv6 addr 9992::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo3
     vrf for v3
     ipv4 addr 9.9.3.3 255.255.255.255
     ipv6 addr 9993::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo4
     vrf for v4
     ipv4 addr 9.9.4.3 255.255.255.255
     ipv6 addr 9994::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234:1::3 ffff:ffff::
     mpls enable
     exit
    route-map rm1
     set metric 1000
     exit
    router bgp4 1
     vrf v1
     address evpn
     local-as 1
     router-id 4.4.4.3
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 import evpn
     afi-vrf v2 export evpn
     afi-vrf v3 ena
     afi-vrf v3 red conn
     afi-vrf v3 import evpn
     afi-vrf v3 export evpn
     afi-vrf v4 ena
     afi-vrf v4 red conn route-map rm1
     afi-vrf v4 import evpn
     afi-vrf v4 export evpn
     exit
    router bgp6 1
     vrf v1
     address evpn
     local-as 1
     router-id 6.6.6.3
     neigh 1234:1::1 remote-as 1
     neigh 1234:1::1 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 import evpn
     afi-vrf v2 export evpn
     afi-vrf v3 ena
     afi-vrf v3 red conn
     afi-vrf v3 import evpn
     afi-vrf v3 export evpn
     afi-vrf v4 ena
     afi-vrf v4 red conn route-map rm1
     afi-vrf v4 import evpn
     afi-vrf v4 export evpn
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    vrf def v2
     rd 1:2
     rt-both 1:2
     exit
    vrf def v3
     rd 1:3
     rt-both 1:3
     exit
    vrf def v4
     rd 1:4
     rt-both 1:4
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v2
     ipv4 addr 9.9.2.4 255.255.255.255
     ipv6 addr 9992::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo3
     vrf for v3
     ipv4 addr 9.9.3.4 255.255.255.255
     ipv6 addr 9993::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo4
     vrf for v4
     ipv4 addr 9.9.4.4 255.255.255.255
     ipv6 addr 9994::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.4 255.255.255.0
     ipv6 addr 1234:1::4 ffff:ffff::
     mpls enable
     exit
    route-map rm1
     sequence 10 act deny
     sequence 10 match metric 2000-4000
     sequence 20 act perm
     exit
    router bgp4 1
     vrf v1
     address evpn
     local-as 1
     router-id 4.4.4.4
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 evpn-route-map-in rm1
     neigh 1.1.1.1 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 import evpn
     afi-vrf v2 export evpn
     afi-vrf v3 ena
     afi-vrf v3 red conn
     afi-vrf v3 import evpn
     afi-vrf v3 export evpn
     afi-vrf v4 ena
     afi-vrf v4 red conn
     afi-vrf v4 import evpn
     afi-vrf v4 export evpn
     exit
    router bgp6 1
     vrf v1
     address evpn
     local-as 1
     router-id 6.6.6.4
     neigh 1234:1::1 remote-as 1
     neigh 1234:1::1 evpn-route-map-in rm1
     neigh 1234:1::1 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 import evpn
     afi-vrf v2 export evpn
     afi-vrf v3 ena
     afi-vrf v3 red conn
     afi-vrf v3 import evpn
     afi-vrf v3 export evpn
     afi-vrf v4 ena
     afi-vrf v4 red conn
     afi-vrf v4 import evpn
     afi-vrf v4 export evpn
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 9.9.4.2 vrf v4
    r1 tping 100 60 9994::2 vrf v4
    r1 tping 100 60 9.9.4.3 vrf v4
    r1 tping 100 60 9994::3 vrf v4
    r1 tping 100 60 9.9.4.4 vrf v4
    r1 tping 100 60 9994::4 vrf v4
    r2 tping 100 60 9.9.4.1 vrf v4
    r2 tping 100 60 9994::1 vrf v4
    r2 tping 100 60 9.9.4.3 vrf v4
    r2 tping 100 60 9994::3 vrf v4
    r2 tping 100 60 9.9.4.4 vrf v4
    r2 tping 100 60 9994::4 vrf v4
    r3 tping 100 60 9.9.4.1 vrf v4
    r3 tping 100 60 9994::1 vrf v4
    r3 tping 100 60 9.9.4.2 vrf v4
    r3 tping 100 60 9994::2 vrf v4
    r3 tping 100 60 9.9.4.4 vrf v4
    r3 tping 100 60 9994::4 vrf v4
    r4 tping 100 60 9.9.4.1 vrf v4
    r4 tping 100 60 9994::1 vrf v4
    r4 tping 100 60 9.9.4.2 vrf v4
    r4 tping 100 60 9994::2 vrf v4
    r4 tping 100 60 9.9.4.3 vrf v4
    r4 tping 100 60 9994::3 vrf v4
    r3 send conf t
    r3 send route-map rm1
    r3 send set metric 3000
    r3 send end
    r3 send clear ipv4 route v4
    r3 send clear ipv6 route v4
    r1 tping 100 60 9.9.4.2 vrf v4
    r1 tping 100 60 9994::2 vrf v4
    r1 tping 100 60 9.9.4.3 vrf v4
    r1 tping 100 60 9994::3 vrf v4
    r1 tping 100 60 9.9.4.4 vrf v4
    r1 tping 100 60 9994::4 vrf v4
    r2 tping 100 60 9.9.4.1 vrf v4
    r2 tping 100 60 9994::1 vrf v4
    r2 tping 100 60 9.9.4.3 vrf v4
    r2 tping 100 60 9994::3 vrf v4
    r2 tping 100 60 9.9.4.4 vrf v4
    r2 tping 100 60 9994::4 vrf v4
    r3 tping 100 60 9.9.4.1 vrf v4
    r3 tping 100 60 9994::1 vrf v4
    r3 tping 100 60 9.9.4.2 vrf v4
    r3 tping 100 60 9994::2 vrf v4
    r3 tping 0 60 9.9.4.4 vrf v4
    r3 tping 0 60 9994::4 vrf v4
    r4 tping 100 60 9.9.4.1 vrf v4
    r4 tping 100 60 9994::1 vrf v4
    r4 tping 100 60 9.9.4.2 vrf v4
    r4 tping 100 60 9994::2 vrf v4
    r4 tping 0 60 9.9.4.3 vrf v4
    r4 tping 0 60 9994::3 vrf v4
    r3 send conf t
    r3 send route-map rm1
    r3 send set metric 5000
    r3 send end
    r3 send clear ipv4 route v4
    r3 send clear ipv6 route v4
    r1 tping 100 60 9.9.4.2 vrf v4
    r1 tping 100 60 9994::2 vrf v4
    r1 tping 100 60 9.9.4.3 vrf v4
    r1 tping 100 60 9994::3 vrf v4
    r1 tping 100 60 9.9.4.4 vrf v4
    r1 tping 100 60 9994::4 vrf v4
    r2 tping 100 60 9.9.4.1 vrf v4
    r2 tping 100 60 9994::1 vrf v4
    r2 tping 0 60 9.9.4.3 vrf v4
    r2 tping 0 60 9994::3 vrf v4
    r2 tping 100 60 9.9.4.4 vrf v4
    r2 tping 100 60 9994::4 vrf v4
    r3 tping 100 60 9.9.4.1 vrf v4
    r3 tping 100 60 9994::1 vrf v4
    r3 tping 0 60 9.9.4.2 vrf v4
    r3 tping 0 60 9994::2 vrf v4
    r3 tping 100 60 9.9.4.4 vrf v4
    r3 tping 100 60 9994::4 vrf v4
    r4 tping 100 60 9.9.4.1 vrf v4
    r4 tping 100 60 9994::1 vrf v4
    r4 tping 100 60 9.9.4.2 vrf v4
    r4 tping 100 60 9994::2 vrf v4
    r4 tping 100 60 9.9.4.3 vrf v4
    r4 tping 100 60 9994::3 vrf v4
    r3 send conf t
    r3 send route-map rm1
    r3 send set metric 1000
    r3 send end
    r3 send clear ipv4 route v4
    r3 send clear ipv6 route v4
    r1 tping 100 60 9.9.4.2 vrf v4
    r1 tping 100 60 9994::2 vrf v4
    r1 tping 100 60 9.9.4.3 vrf v4
    r1 tping 100 60 9994::3 vrf v4
    r1 tping 100 60 9.9.4.4 vrf v4
    r1 tping 100 60 9994::4 vrf v4
    r2 tping 100 60 9.9.4.1 vrf v4
    r2 tping 100 60 9994::1 vrf v4
    r2 tping 100 60 9.9.4.3 vrf v4
    r2 tping 100 60 9994::3 vrf v4
    r2 tping 100 60 9.9.4.4 vrf v4
    r2 tping 100 60 9994::4 vrf v4
    r3 tping 100 60 9.9.4.1 vrf v4
    r3 tping 100 60 9994::1 vrf v4
    r3 tping 100 60 9.9.4.2 vrf v4
    r3 tping 100 60 9994::2 vrf v4
    r3 tping 100 60 9.9.4.4 vrf v4
    r3 tping 100 60 9994::4 vrf v4
    r4 tping 100 60 9.9.4.1 vrf v4
    r4 tping 100 60 9994::1 vrf v4
    r4 tping 100 60 9.9.4.2 vrf v4
    r4 tping 100 60 9994::2 vrf v4
    r4 tping 100 60 9.9.4.3 vrf v4
    r4 tping 100 60 9994::3 vrf v4
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp818](../clab/rout-bgp818/rout-bgp818.yml) file  
        3. Launch ContainerLab `rout-bgp818.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp818.yml  
        ```
        4. Destroy ContainerLab `rout-bgp818.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp818.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp818.tst` file [here](../tst/rout-bgp818.tst)  
        3. Launch `rout-bgp818.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp818 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp818.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

