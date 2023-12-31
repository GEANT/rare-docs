# Example: vpls/ldp with ingress rtfilter

=== "Topology"

    ![Alt text](../d2/rout-bgp594/rout-bgp594.svg)

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
     rt-both 1:13
     mac-learn
     private
     exit
    bridge 4
     rd 1:4
     rt-both 1:14
     mac-learn
     private
     exit
    bridge 5
     rd 1:5
     rt-both 1:15
     mac-learn
     private
     exit
    bridge 6
     rd 1:6
     rt-both 1:16
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
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int bvi1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.252
     ipv6 addr 3333::1 ffff::
     exit
    int bvi2
     vrf for v1
     ipv4 addr 4.4.4.1 255.255.255.252
     ipv6 addr 4444::1 ffff::
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    router bgp4 1
     vrf v1
     address vpls rtfilter
     local-as 1
     router-id 4.4.4.1
     neigh 2.2.2.2 remote-as 1
     neigh 2.2.2.2 update lo0
     neigh 2.2.2.2 send-comm both
     neigh 2.2.2.2 maximum-prefix-in 5 50
     neigh 2.2.2.2 route-target-filter-in
     afi-vpls 1:1 bridge 1
     afi-vpls 1:1 update lo0
     afi-vpls 1:3 bridge 3
     afi-vpls 1:3 update lo0
     afi-vpls 1:5 bridge 5
     afi-vpls 1:5 update lo0
     exit
    router bgp6 1
     vrf v1
     address vpls rtfilter
     local-as 1
     router-id 6.6.6.1
     neigh 4321::2 remote-as 1
     neigh 4321::2 update lo0
     neigh 4321::2 send-comm both
     neigh 4321::2 maximum-prefix-in 5 50
     neigh 4321::2 route-target-filter-in
     afi-vpls 1:1 bridge 2
     afi-vpls 1:1 update lo0
     afi-vpls 1:4 bridge 4
     afi-vpls 1:4 update lo0
     afi-vpls 1:6 bridge 6
     afi-vpls 1:6 update lo0
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
     rt-both 1:23
     mac-learn
     private
     exit
    bridge 4
     rd 1:4
     rt-both 1:24
     mac-learn
     private
     exit
    bridge 5
     rd 1:5
     rt-both 1:25
     mac-learn
     private
     exit
    bridge 6
     rd 1:6
     rt-both 1:26
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
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int bvi1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.252
     ipv6 addr 3333::2 ffff::
     exit
    int bvi2
     vrf for v1
     ipv4 addr 4.4.4.2 255.255.255.252
     ipv6 addr 4444::2 ffff::
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    router bgp4 1
     vrf v1
     address vpls rtfilter
     local-as 1
     router-id 4.4.4.2
     neigh 2.2.2.1 remote-as 1
     neigh 2.2.2.1 update lo0
     neigh 2.2.2.1 send-comm both
     neigh 2.2.2.1 maximum-prefix-in 5 50
     neigh 2.2.2.1 route-target-filter-in
     afi-vpls 1:1 bridge 1
     afi-vpls 1:1 update lo0
     afi-vpls 1:3 bridge 3
     afi-vpls 1:3 update lo0
     afi-vpls 1:5 bridge 5
     afi-vpls 1:5 update lo0
     exit
    router bgp6 1
     vrf v1
     address vpls rtfilter
     local-as 1
     router-id 6.6.6.2
     neigh 4321::1 remote-as 1
     neigh 4321::1 update lo0
     neigh 4321::1 send-comm both
     neigh 4321::1 maximum-prefix-in 5 50
     neigh 4321::1 route-target-filter-in
     afi-vpls 1:1 bridge 2
     afi-vpls 1:1 update lo0
     afi-vpls 1:4 bridge 4
     afi-vpls 1:4 update lo0
     afi-vpls 1:6 bridge 6
     afi-vpls 1:6 update lo0
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 60 4321::1 vrf v1 sou lo0
    r1 tping 100 60 3.3.3.2 vrf v1
    r1 tping 100 60 3333::2 vrf v1
    r1 tping 100 60 4.4.4.2 vrf v1
    r1 tping 100 60 4444::2 vrf v1
    r2 tping 100 60 3.3.3.1 vrf v1
    r2 tping 100 60 3333::1 vrf v1
    r2 tping 100 60 4.4.4.1 vrf v1
    r2 tping 100 60 4444::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp594](../clab/rout-bgp594/rout-bgp594.yml) file  
        3. Launch ContainerLab `rout-bgp594.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp594.yml  
        ```
        4. Destroy ContainerLab `rout-bgp594.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp594.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp594.tst` file [here](../tst/rout-bgp594.tst)  
        3. Launch `rout-bgp594.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp594 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp594.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

