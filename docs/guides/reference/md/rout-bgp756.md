# Example: bgp csc vpn with car

=== "Topology"

    ![Alt text](../d2/rout-bgp756/rout-bgp756.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    vrf def v3
     rd 1:3
     rt-both 1:3
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v3
     ipv4 addr 4.4.4.1 255.255.255.255
     ipv6 addr 4444::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     mpls enable
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address car
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 2
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address car
     local-as 1
     router-id 6.6.6.1
     neigh 1234:1::2 remote-as 2
     red conn
     exit
    router bgp4 4
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 4
     router-id 4.4.4.1
     neigh 2.2.2.4 remote-as 4
     neigh 2.2.2.4 update lo0
     neigh 2.2.2.4 send-comm both
     afi-vrf v3 ena
     afi-vrf v3 red conn
     exit
    router bgp6 4
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 4
     router-id 6.6.6.1
     neigh 4321::4 remote-as 4
     neigh 4321::4 update lo0
     neigh 4321::4 send-comm both
     afi-vrf v3 ena
     afi-vrf v3 red conn
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    vrf def v2
     rd 1:2
     rt-both 1:2
     label-mode per-prefix
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    int lo0
     vrf for v1
     ipv4 addr 3.3.3.101 255.255.255.255
     ipv6 addr 3333::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v2
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v2
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     mpls enable
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    int eth2
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.252
     ipv6 addr 3333::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffc
     mpls enable
     mpls ldp4
     mpls ldp6
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    ipv4 route v1 3.3.3.102 255.255.255.255 3.3.3.2
    ipv6 route v1 3333::102 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 3333::2
    router bgp4 1
     vrf v2
     no safe-ebgp
     address car
     local-as 2
     router-id 4.4.4.2
     neigh 1.1.1.1 remote-as 1
     red conn
     red bgp4 2
     exit
    router bgp6 1
     vrf v2
     no safe-ebgp
     address car
     local-as 2
     router-id 6.6.6.2
     neigh 1234:1::1 remote-as 1
     red conn
     red bgp6 2
     exit
    router bgp4 2
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 2
     router-id 4.4.4.1
     neigh 3.3.3.102 remote-as 2
     neigh 3.3.3.102 update lo0
     neigh 3.3.3.102 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 red bgp4 1
     exit
    router bgp6 2
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 2
     router-id 6.6.6.1
     neigh 3333::102 remote-as 2
     neigh 3333::102 update lo0
     neigh 3333::102 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 red bgp6 1
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    int eth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.252
     ipv6 addr 3333::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffc
     mpls enable
     mpls ldp4
     mpls ldp6
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    int eth2
     vrf for v1
     ipv4 addr 3.3.3.5 255.255.255.252
     ipv6 addr 3333::5 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffc
     mpls enable
     mpls ldp4
     mpls ldp6
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    ipv4 route v1 3.3.3.101 255.255.255.255 3.3.3.1
    ipv6 route v1 3333::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 3333::1
    ipv4 route v1 3.3.3.102 255.255.255.255 3.3.3.6
    ipv6 route v1 3333::102 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 3333::6
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    vrf def v2
     rd 1:2
     rt-both 1:2
     label-mode per-prefix
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    int lo0
     vrf for v1
     ipv4 addr 3.3.3.102 255.255.255.255
     ipv6 addr 3333::102 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v2
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 3.3.3.6 255.255.255.252
     ipv6 addr 3333::6 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffc
     mpls enable
     mpls ldp4
     mpls ldp6
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    int eth2
     vrf for v2
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     mpls enable
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    ipv4 route v1 3.3.3.101 255.255.255.255 3.3.3.5
    ipv6 route v1 3333::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 3333::5
    router bgp4 1
     vrf v2
     no safe-ebgp
     address car
     local-as 2
     router-id 4.4.4.2
     neigh 1.1.1.6 remote-as 3
     red conn
     red bgp4 2
     exit
    router bgp6 1
     vrf v2
     no safe-ebgp
     address car
     local-as 2
     router-id 6.6.6.2
     neigh 1234:2::2 remote-as 3
     red conn
     red bgp6 2
     exit
    router bgp4 2
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 2
     router-id 4.4.4.2
     neigh 3.3.3.101 remote-as 2
     neigh 3.3.3.101 update lo0
     neigh 3.3.3.101 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 red bgp4 1
     exit
    router bgp6 2
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 2
     router-id 6.6.6.2
     neigh 3333::101 remote-as 2
     neigh 3333::101 update lo0
     neigh 3333::101 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 red bgp6 1
     exit
    ```

    **r5**

    ```
    hostname r5
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    vrf def v3
     rd 1:3
     rt-both 1:3
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v3
     ipv4 addr 4.4.4.4 255.255.255.255
     ipv6 addr 4444::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls enable
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address car
     local-as 3
     router-id 4.4.4.3
     neigh 1.1.1.5 remote-as 2
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address car
     local-as 3
     router-id 6.6.6.3
     neigh 1234:2::1 remote-as 2
     red conn
     exit
    router bgp4 4
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 4
     router-id 4.4.4.2
     neigh 2.2.2.1 remote-as 4
     neigh 2.2.2.1 update lo0
     neigh 2.2.2.1 send-comm both
     afi-vrf v3 ena
     afi-vrf v3 red conn
     exit
    router bgp6 4
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 4
     router-id 6.6.6.2
     neigh 4321::1 remote-as 4
     neigh 4321::1 update lo0
     neigh 4321::1 send-comm both
     afi-vrf v3 ena
     afi-vrf v3 red conn
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 60 3.3.3.102 vrf v1 sou lo0
    r2 tping 100 60 3333::102 vrf v1 sou lo0
    r4 tping 100 60 3.3.3.101 vrf v1 sou lo0
    r4 tping 100 60 3333::101 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.4 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 4321::3 vrf v1 sou lo0
    r1 tping 100 60 4321::4 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.1 vrf v2 sou lo1
    r2 tping 100 60 2.2.2.3 vrf v2 sou lo1
    r2 tping 100 60 2.2.2.4 vrf v2 sou lo1
    r2 tping 100 60 4321::1 vrf v2 sou lo1
    r2 tping 100 60 4321::3 vrf v2 sou lo1
    r2 tping 100 60 4321::4 vrf v2 sou lo1
    r4 tping 100 60 2.2.2.1 vrf v2 sou lo1
    r4 tping 100 60 2.2.2.2 vrf v2 sou lo1
    r4 tping 100 60 2.2.2.4 vrf v2 sou lo1
    r4 tping 100 60 4321::1 vrf v2 sou lo1
    r4 tping 100 60 4321::2 vrf v2 sou lo1
    r4 tping 100 60 4321::4 vrf v2 sou lo1
    r5 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r5 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r5 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r5 tping 100 60 4321::1 vrf v1 sou lo0
    r5 tping 100 60 4321::2 vrf v1 sou lo0
    r5 tping 100 60 4321::3 vrf v1 sou lo0
    r1 tping 100 60 4.4.4.4 vrf v3 sou lo1
    r1 tping 100 60 4444::4 vrf v3 sou lo1
    r5 tping 100 60 4.4.4.1 vrf v3 sou lo1
    r5 tping 100 60 4444::1 vrf v3 sou lo1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp756](../clab/rout-bgp756/rout-bgp756.yml) file  
        3. Launch ContainerLab `rout-bgp756.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp756.yml  
        ```
        4. Destroy ContainerLab `rout-bgp756.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp756.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp756.tst` file [here](../tst/rout-bgp756.tst)  
        3. Launch `rout-bgp756.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp756 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp756.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```
