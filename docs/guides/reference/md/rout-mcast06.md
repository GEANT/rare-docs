# Example: multicast vpn routing with mldp

=== "Topology"

    ![Alt text](../d2/rout-mcast06/rout-mcast06.svg)

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
     mdt4
     mdt6
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v2
     ipv4 addr 3.3.3.1 255.255.255.255
     ipv6 addr 3333::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls ena
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.5
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    ipv4 route v1 2.2.2.4 255.255.255.255 1.1.1.5
    ipv6 route v1 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    router bgp4 1
     vrf v1
     address vpnuni vpnmlt
     local-as 1
     router-id 4.4.4.1
     neigh 2.2.2.3 remote-as 1
     neigh 2.2.2.3 update lo0
     neigh 2.2.2.3 send-comm both
     neigh 2.2.2.4 remote-as 1
     neigh 2.2.2.4 update lo0
     neigh 2.2.2.4 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     exit
    router bgp6 1
     vrf v1
     address vpnuni vpnmlt
     local-as 1
     router-id 6.6.6.1
     neigh 4321::3 remote-as 1
     neigh 4321::3 update lo0
     neigh 4321::3 send-comm both
     neigh 4321::4 remote-as 1
     neigh 4321::4 update lo0
     neigh 4321::4 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
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
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     mpls ena
     mpls ldp4
     mpls ldp6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     ipv6 addr 1234:3::1 ffff:ffff::
     mpls ena
     mpls ldp4
     mpls ldp6
     exit
    int eth3
     vrf for v1
     ipv4 addr 1.1.1.13 255.255.255.252
     ipv6 addr 1234:4::1 ffff:ffff::
     mpls ena
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.6
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.10
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::2
    ipv4 route v1 2.2.2.4 255.255.255.255 1.1.1.14
    ipv6 route v1 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::2
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
     mdt4
     mdt6
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v2
     ipv4 addr 3.3.3.3 255.255.255.255
     ipv6 addr 3333::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.10 255.255.255.252
     ipv6 addr 1234:3::2 ffff:ffff::
     mpls ena
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.9
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::1
    router bgp4 1
     vrf v1
     address vpnuni vpnmlt
     local-as 1
     router-id 4.4.4.3
     neigh 2.2.2.1 remote-as 1
     neigh 2.2.2.1 update lo0
     neigh 2.2.2.1 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     exit
    router bgp6 1
     vrf v1
     address vpnuni vpnmlt
     local-as 1
     router-id 6.6.6.3
     neigh 4321::1 remote-as 1
     neigh 4321::1 update lo0
     neigh 4321::1 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     exit
    ipv4 multi v2 join 232.2.2.2 3.3.3.1
    ipv6 multi v2 join ff06::1 3333::1
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
     mdt4
     mdt6
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v2
     ipv4 addr 3.3.3.4 255.255.255.255
     ipv6 addr 3333::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.14 255.255.255.252
     ipv6 addr 1234:4::2 ffff:ffff::
     mpls ena
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.13
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::1
    router bgp4 1
     vrf v1
     address vpnuni vpnmlt
     local-as 1
     router-id 4.4.4.4
     neigh 2.2.2.1 remote-as 1
     neigh 2.2.2.1 update lo0
     neigh 2.2.2.1 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     exit
    router bgp6 1
     vrf v1
     address vpnuni vpnmlt
     local-as 1
     router-id 6.6.6.4
     neigh 4321::1 remote-as 1
     neigh 4321::1 update lo0
     neigh 4321::1 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     exit
    ipv4 multi v2 join 232.2.2.2 3.3.3.1
    ipv6 multi v2 join ff06::1 3333::1
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r1 tping 100 60 4321::3 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.4 vrf v1 sou lo0
    r1 tping 100 60 4321::4 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r3 tping 100 60 4321::1 vrf v1 sou lo0
    r4 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r4 tping 100 60 4321::1 vrf v1 sou lo0
    r1 tping 100 60 3.3.3.3 vrf v2
    r1 tping 100 60 3333::3 vrf v2
    r1 tping 100 60 3.3.3.4 vrf v2
    r1 tping 100 60 3333::4 vrf v2
    r3 tping 100 60 3.3.3.1 vrf v2
    r3 tping 100 60 3333::1 vrf v2
    r4 tping 100 60 3.3.3.1 vrf v2
    r4 tping 100 60 3333::1 vrf v2
    r1 tping 200 10 232.2.2.2 vrf v2 sou lo1 multi
    r1 tping 200 10 ff06::1 vrf v2 sou lo1 multi
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-mcast06](../clab/rout-mcast06/rout-mcast06.yml) file  
        3. Launch ContainerLab `rout-mcast06.yml` topology:  

        ```
           containerlab deploy --topo rout-mcast06.yml  
        ```
        4. Destroy ContainerLab `rout-mcast06.yml` topology:  

        ```
           containerlab destroy --topo rout-mcast06.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-mcast06.tst` file [here](../tst/rout-mcast06.tst)  
        3. Launch `rout-mcast06.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-mcast06 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-mcast06.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

