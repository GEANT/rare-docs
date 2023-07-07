# Example: bgp dual core vpn

=== "Topology"

    ![Alt text](../d2/rout-bgp337/rout-bgp337.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    vrf def v3
     rd 1:2
     rt-both 1:2
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v3
     ipv4 addr 3.3.3.1 255.255.255.255
     ipv6 addr 3333::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
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
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    router bgp4 1
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 1
     router-id 4.4.4.1
     neigh 2.2.2.2 remote-as 1
     neigh 2.2.2.2 update lo0
     neigh 2.2.2.2 send-comm both
     afi-vrf v3 ena
     afi-vrf v3 red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 1
     router-id 6.6.6.1
     neigh 4321::2 remote-as 1
     neigh 4321::2 update lo0
     neigh 4321::2 send-comm both
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
     rd 1:0
     label-mode per-prefix
     exit
    vrf def v3
     rd 1:2
     rt-both 1:2
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v2
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v3
     ipv4 addr 3.3.3.2 255.255.255.255
     ipv6 addr 3333::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
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
     vrf for v2
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v2 2.2.2.3 255.255.255.255 1.1.1.6
    ipv6 route v2 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    router bgp4 1
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 1
     router-id 4.4.4.2
     neigh 2.2.2.1 remote-as 1
     neigh 2.2.2.1 update lo0
     neigh 2.2.2.1 send-comm both
     afi-vrf v3 ena
     afi-vrf v3 red conn
     afi-vrf v3 red bgp4 2
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address vpnuni
     local-as 1
     router-id 6.6.6.2
     neigh 4321::1 remote-as 1
     neigh 4321::1 update lo0
     neigh 4321::1 send-comm both
     afi-vrf v3 ena
     afi-vrf v3 red conn
     afi-vrf v3 red bgp6 2
     exit
    router bgp4 2
     vrf v2
     no safe-ebgp
     address vpnuni
     local-as 2
     router-id 4.4.4.2
     neigh 2.2.2.3 remote-as 2
     neigh 2.2.2.3 update lo1
     neigh 2.2.2.3 send-comm both
     afi-vrf v3 ena
     afi-vrf v3 red conn
     afi-vrf v3 red bgp4 1
     exit
    router bgp6 2
     vrf v2
     no safe-ebgp
     address vpnuni
     local-as 2
     router-id 6.6.6.2
     neigh 4321::3 remote-as 2
     neigh 4321::3 update lo1
     neigh 4321::3 send-comm both
     afi-vrf v3 ena
     afi-vrf v3 red conn
     afi-vrf v3 red bgp6 1
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v2
     rd 1:1
     label-mode per-prefix
     exit
    vrf def v3
     rd 1:2
     rt-both 1:2
     exit
    int lo1
     vrf for v2
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v3
     ipv4 addr 3.3.3.3 255.255.255.255
     ipv6 addr 3333::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v2
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v2 2.2.2.2 255.255.255.255 1.1.1.5
    ipv6 route v2 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    router bgp4 1
     vrf v2
     no safe-ebgp
     address vpnuni
     local-as 2
     router-id 4.4.4.3
     neigh 2.2.2.2 remote-as 2
     neigh 2.2.2.2 update lo1
     neigh 2.2.2.2 send-comm both
     afi-vrf v3 ena
     afi-vrf v3 red conn
     exit
    router bgp6 1
     vrf v2
     no safe-ebgp
     address vpnuni
     local-as 2
     router-id 6.6.6.3
     neigh 4321::2 remote-as 2
     neigh 4321::2 update lo1
     neigh 4321::2 send-comm both
     afi-vrf v3 ena
     afi-vrf v3 red conn
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 60 4321::1 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.3 vrf v2 sou lo1
    r2 tping 100 60 4321::3 vrf v2 sou lo1
    r3 tping 100 60 2.2.2.2 vrf v2 sou lo1
    r3 tping 100 60 4321::2 vrf v2 sou lo1
    r1 tping 100 60 3.3.3.2 vrf v3 sou lo2
    r1 tping 100 60 3333::2 vrf v3 sou lo2
    r1 tping 100 60 3.3.3.3 vrf v3 sou lo2
    r1 tping 100 60 3333::3 vrf v3 sou lo2
    r2 tping 100 60 3.3.3.1 vrf v3 sou lo2
    r2 tping 100 60 3333::1 vrf v3 sou lo2
    r2 tping 100 60 3.3.3.3 vrf v3 sou lo2
    r2 tping 100 60 3333::3 vrf v3 sou lo2
    r3 tping 100 60 3.3.3.1 vrf v3 sou lo2
    r3 tping 100 60 3333::1 vrf v3 sou lo2
    r3 tping 100 60 3.3.3.2 vrf v3 sou lo2
    r3 tping 100 60 3333::2 vrf v3 sou lo2
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp337](../clab/rout-bgp337/rout-bgp337.yml) file  
        3. Launch ContainerLab `rout-bgp337.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp337.yml  
        ```
        4. Destroy ContainerLab `rout-bgp337.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp337.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp337.tst` file [here](../tst/rout-bgp337.tst)  
        3. Launch `rout-bgp337.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp337 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp337.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

