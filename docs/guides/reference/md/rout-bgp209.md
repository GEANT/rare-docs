# Example: multisite evpn/cmac over ibgp rr

=== "Topology"

    ![Alt text](../d2/rout-bgp209/rout-bgp209.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    bridge 1
     rd 1:1
     rt-both 1:1
     mac-learn
     private
     exit
    bridge 2
     rd 1:2
     rt-both 1:2
     mac-learn
     private
     exit
    bridge 3
     rd 1:3
     rt-both 1:3
     mac-learn
     private
     exit
    bridge 4
     rd 1:4
     rt-both 1:4
     mac-learn
     private
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int bvi1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     exit
    int bvi2
     vrf for v1
     ipv6 addr 4444::1 ffff::
     exit
    int bvi3
     vrf for v1
     ipv6 addr 3333::1 ffff::
     exit
    int bvi4
     vrf for v1
     ipv4 addr 4.4.4.1 255.255.255.0
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.3
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::3
    router bgp4 1
     vrf v1
     address evpn
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.4 remote-as 1
     neigh 1.1.1.4 update lo0
     neigh 1.1.1.4 send-comm both
     neigh 1.1.1.4 pmsi
     afi-evpn 101 bridge 1
     afi-evpn 101 update lo0
     afi-evpn 101 encap cmac
     afi-evpn 102 bridge 3
     afi-evpn 102 update lo0
     afi-evpn 102 encap cmac
     exit
    router bgp6 1
     vrf v1
     address evpn
     local-as 1
     router-id 6.6.6.1
     neigh 1234:1::4 remote-as 1
     neigh 1234:1::4 update lo0
     neigh 1234:1::4 send-comm both
     neigh 1234:1::4 pmsi
     afi-evpn 101 bridge 2
     afi-evpn 101 update lo0
     afi-evpn 101 encap cmac
     afi-evpn 102 bridge 4
     afi-evpn 102 update lo0
     afi-evpn 102 encap cmac
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    bridge 1
     rd 1:1
     rt-both 1:1
     mac-learn
     private
     exit
    bridge 2
     rd 1:2
     rt-both 1:2
     mac-learn
     private
     exit
    bridge 3
     rd 1:3
     rt-both 1:3
     mac-learn
     private
     exit
    bridge 4
     rd 1:4
     rt-both 1:4
     mac-learn
     private
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234:1::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int bvi1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     exit
    int bvi2
     vrf for v1
     ipv6 addr 4444::2 ffff::
     exit
    int bvi3
     vrf for v1
     ipv6 addr 3333::2 ffff::
     exit
    int bvi4
     vrf for v1
     ipv4 addr 4.4.4.2 255.255.255.0
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.3
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::3
    router bgp4 1
     vrf v1
     address evpn
     local-as 1
     router-id 4.4.4.2
     neigh 1.1.1.4 remote-as 1
     neigh 1.1.1.4 update lo0
     neigh 1.1.1.4 send-comm both
     neigh 1.1.1.4 pmsi
     afi-evpn 101 bridge 1
     afi-evpn 101 update lo0
     afi-evpn 101 encap cmac
     afi-evpn 102 bridge 3
     afi-evpn 102 update lo0
     afi-evpn 102 encap cmac
     exit
    router bgp6 1
     vrf v1
     address evpn
     local-as 1
     router-id 6.6.6.2
     neigh 1234:1::4 remote-as 1
     neigh 1234:1::4 update lo0
     neigh 1234:1::4 send-comm both
     neigh 1234:1::4 pmsi
     afi-evpn 101 bridge 2
     afi-evpn 101 update lo0
     afi-evpn 101 encap cmac
     afi-evpn 102 bridge 4
     afi-evpn 102 update lo0
     afi-evpn 102 encap cmac
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    bridge 1
     rd 1:1
     rt-both 1:1
     mac-learn
     private
     exit
    bridge 2
     rd 1:2
     rt-both 1:2
     mac-learn
     private
     exit
    bridge 3
     rd 1:3
     rt-both 1:3
     mac-learn
     private
     exit
    bridge 4
     rd 1:4
     rt-both 1:4
     mac-learn
     private
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234:1::3 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int bvi1
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.0
     exit
    int bvi2
     vrf for v1
     ipv6 addr 4444::3 ffff::
     exit
    int bvi3
     vrf for v1
     ipv6 addr 3333::3 ffff::
     exit
    int bvi4
     vrf for v1
     ipv4 addr 4.4.4.3 255.255.255.0
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    router bgp4 1
     vrf v1
     address evpn
     local-as 1
     router-id 4.4.4.3
     neigh 1.1.1.4 remote-as 1
     neigh 1.1.1.4 update lo0
     neigh 1.1.1.4 send-comm both
     neigh 1.1.1.4 pmsi
     afi-evpn 101 bridge 1
     afi-evpn 101 update lo0
     afi-evpn 101 encap cmac
     afi-evpn 102 bridge 3
     afi-evpn 102 update lo0
     afi-evpn 102 encap cmac
     exit
    router bgp6 1
     vrf v1
     address evpn
     local-as 1
     router-id 6.6.6.3
     neigh 1234:1::4 remote-as 1
     neigh 1234:1::4 update lo0
     neigh 1234:1::4 send-comm both
     neigh 1234:1::4 pmsi
     afi-evpn 101 bridge 2
     afi-evpn 101 update lo0
     afi-evpn 101 encap cmac
     afi-evpn 102 bridge 4
     afi-evpn 102 update lo0
     afi-evpn 102 encap cmac
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    bridge 1
     mac-learn
     exit
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int eth3
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.4 255.255.255.0
     ipv6 addr 1234:1::4 ffff:ffff::
     exit
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.3
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::3
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    router bgp4 1
     vrf v1
     address evpn
     local-as 1
     router-id 4.4.4.4
     neigh 2.2.2.1 remote-as 1
     neigh 2.2.2.1 send-comm both
     neigh 2.2.2.1 pmsi
     neigh 2.2.2.1 route-reflect
     neigh 2.2.2.2 remote-as 1
     neigh 2.2.2.2 send-comm both
     neigh 2.2.2.2 pmsi
     neigh 2.2.2.2 route-reflect
     neigh 2.2.2.3 remote-as 1
     neigh 2.2.2.3 send-comm both
     neigh 2.2.2.3 pmsi
     neigh 2.2.2.3 route-reflect
     exit
    router bgp6 1
     vrf v1
     address evpn
     local-as 1
     router-id 6.6.6.4
     neigh 4321::1 remote-as 1
     neigh 4321::1 send-comm both
     neigh 4321::1 pmsi
     neigh 4321::1 route-reflect
     neigh 4321::2 remote-as 1
     neigh 4321::2 send-comm both
     neigh 4321::2 pmsi
     neigh 4321::2 route-reflect
     neigh 4321::3 remote-as 1
     neigh 4321::3 send-comm both
     neigh 4321::3 pmsi
     neigh 4321::3 route-reflect
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r1 tping 100 60 4321::3 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 60 4321::1 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r2 tping 100 60 4321::3 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r3 tping 100 60 4321::1 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 60 4321::2 vrf v1 sou lo0
    r4 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r4 tping 100 60 4321::1 vrf v1 sou lo0
    r4 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r4 tping 100 60 4321::2 vrf v1 sou lo0
    r4 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r4 tping 100 60 4321::3 vrf v1 sou lo0
    r1 tping 100 60 3.3.3.2 vrf v1
    r1 tping 100 60 3333::2 vrf v1
    r1 tping 100 60 3.3.3.3 vrf v1
    r1 tping 100 60 3333::3 vrf v1
    r1 tping 100 60 4.4.4.2 vrf v1
    r1 tping 100 60 4444::2 vrf v1
    r1 tping 100 60 4.4.4.3 vrf v1
    r1 tping 100 60 4444::3 vrf v1
    r2 tping 100 60 3.3.3.1 vrf v1
    r2 tping 100 60 3333::1 vrf v1
    r2 tping 100 60 3.3.3.3 vrf v1
    r2 tping 100 60 3333::3 vrf v1
    r2 tping 100 60 4.4.4.1 vrf v1
    r2 tping 100 60 4444::1 vrf v1
    r2 tping 100 60 4.4.4.3 vrf v1
    r2 tping 100 60 4444::3 vrf v1
    r3 tping 100 60 3.3.3.1 vrf v1
    r3 tping 100 60 3333::1 vrf v1
    r3 tping 100 60 3.3.3.2 vrf v1
    r3 tping 100 60 3333::2 vrf v1
    r3 tping 100 60 4.4.4.1 vrf v1
    r3 tping 100 60 4444::1 vrf v1
    r3 tping 100 60 4.4.4.2 vrf v1
    r3 tping 100 60 4444::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp209](../clab/rout-bgp209/rout-bgp209.yml) file  
        3. Launch ContainerLab `rout-bgp209.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp209.yml  
        ```
        4. Destroy ContainerLab `rout-bgp209.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp209.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp209.tst` file [here](../tst/rout-bgp209.tst)  
        3. Launch `rout-bgp209.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp209 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp209.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```
