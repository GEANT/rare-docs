# Example: l3evpns with egress rtfilter

=== "Topology"

    ![Alt text](../d2/rout-bgp825/rout-bgp825.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
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
     rt-both 1:41
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
    int lo41
     vrf for v4
     ipv4 addr 9.9.4.11 255.255.255.255
     ipv6 addr 9994::11 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo42
     vrf for v4
     ipv4 addr 9.9.4.12 255.255.255.255
     ipv6 addr 9994::12 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo43
     vrf for v4
     ipv4 addr 9.9.4.13 255.255.255.255
     ipv6 addr 9994::13 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo44
     vrf for v4
     ipv4 addr 9.9.4.14 255.255.255.255
     ipv6 addr 9994::14 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo45
     vrf for v4
     ipv4 addr 9.9.4.15 255.255.255.255
     ipv6 addr 9994::15 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    router bgp4 1
     vrf v1
     address evpn rtfilter
     local-as 1
     router-id 4.4.4.1
     neigh 2.2.2.3 remote-as 1
     neigh 2.2.2.3 update lo0
     neigh 2.2.2.3 send-comm both
     neigh 2.2.2.3 maximum-prefix-in 5 50
     neigh 2.2.2.3 route-target-filter-out
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
     address evpn rtfilter
     local-as 1
     router-id 6.6.6.1
     neigh 4321::3 remote-as 1
     neigh 4321::3 update lo0
     neigh 4321::3 send-comm both
     neigh 4321::3 maximum-prefix-in 5 50
     neigh 4321::3 route-target-filter-out
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
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.6
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     label-mode per-prefix
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
     rt-both 1:43
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
    int lo41
     vrf for v4
     ipv4 addr 9.9.4.31 255.255.255.255
     ipv6 addr 9994::31 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo42
     vrf for v4
     ipv4 addr 9.9.4.32 255.255.255.255
     ipv6 addr 9994::32 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo43
     vrf for v4
     ipv4 addr 9.9.4.33 255.255.255.255
     ipv6 addr 9994::33 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo44
     vrf for v4
     ipv4 addr 9.9.4.34 255.255.255.255
     ipv6 addr 9994::34 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo45
     vrf for v4
     ipv4 addr 9.9.4.35 255.255.255.255
     ipv6 addr 9994::35 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.5
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.5
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    router bgp4 1
     vrf v1
     address evpn rtfilter
     local-as 1
     router-id 4.4.4.3
     neigh 2.2.2.1 remote-as 1
     neigh 2.2.2.1 update lo0
     neigh 2.2.2.1 send-comm both
     neigh 2.2.2.1 maximum-prefix-in 5 50
     neigh 2.2.2.1 route-target-filter-out
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
     address evpn rtfilter
     local-as 1
     router-id 6.6.6.3
     neigh 4321::1 remote-as 1
     neigh 4321::1 update lo0
     neigh 4321::1 send-comm both
     neigh 4321::1 maximum-prefix-in 5 50
     neigh 4321::1 route-target-filter-out
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
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 4321::3 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r2 tping 100 60 4321::3 vrf v1 sou lo0
    r2 tping 100 60 4321::1 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 60 4321::1 vrf v1 sou lo0
    r3 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 9.9.2.3 vrf v2
    r3 tping 100 60 9.9.2.1 vrf v2
    r1 tping 100 60 9992::3 vrf v2
    r3 tping 100 60 9992::1 vrf v2
    r1 tping 100 60 9.9.3.3 vrf v3
    r3 tping 100 60 9.9.3.1 vrf v3
    r1 tping 100 60 9993::3 vrf v3
    r3 tping 100 60 9993::1 vrf v3
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp825](../clab/rout-bgp825/rout-bgp825.yml) file  
        3. Launch ContainerLab `rout-bgp825.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp825.yml  
        ```
        4. Destroy ContainerLab `rout-bgp825.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp825.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp825.tst` file [here](../tst/rout-bgp825.tst)  
        3. Launch `rout-bgp825.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp825 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp825.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

