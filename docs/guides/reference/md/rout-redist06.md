# Example: redistribution with bgp othervpn

=== "Topology"

    ![Alt text](../d2/rout-redist06/rout-redist06.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.1111.00
     is-type level2
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.1111.00
     is-type level2
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.11 255.255.255.255
     ipv6 addr 4321::11 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo3
     vrf for v1
     ipv4 addr 2.2.2.21 255.255.255.255
     ipv6 addr 4321::21 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     router isis4 1 ena
     exit
    int eth1.12
     vrf for v1
     ipv6 addr 1234:1::1 ffff:ffff::
     router isis6 1 ena
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
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    router isis4 1
     vrf v2
     net 48.4444.0000.2222.00
     is-type level2
     red conn
     red bgp4 1
     exit
    router isis6 1
     vrf v2
     net 48.6666.0000.2222.00
     is-type level2
     red conn
     red bgp4 1
     exit
    router bgp4 1
     vrf v1
     address vpnuni ovpnuni
     local-as 1
     router 4.4.4.2
     neigh 2.2.2.3 remote-as 1
     neigh 2.2.2.3 update lo1
     neigh 2.2.2.3 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v2 red isis4 1
     afi-ovrf v2 ena
     afi-ovrf v2 red conn
     afi-ovrf v2 red isis6 1
     exit
    router bgp6 1
     vrf v1
     address vpnuni ovpnuni
     local-as 1
     router 6.6.6.2
     neigh 4321::3 remote-as 1
     neigh 4321::3 update lo1
     neigh 4321::3 send-comm both
     exit
    int lo2
     vrf for v2
     ipv4 addr 2.2.2.12 255.255.255.255
     ipv6 addr 4321::12 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo3
     vrf for v2
     ipv4 addr 2.2.2.22 255.255.255.255
     ipv6 addr 4321::22 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v2
     ipv4 addr 1.1.1.2 255.255.255.252
     router isis4 1 ena
     exit
    int eth1.12
     vrf for v2
     ipv6 addr 1234:1::2 ffff:ffff::
     router isis6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.6
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
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    router bgp4 1
     vrf v1
     address vpnuni ovpnuni
     local-as 1
     router 4.4.4.3
     neigh 2.2.2.2 remote-as 1
     neigh 2.2.2.2 update lo1
     neigh 2.2.2.2 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-ovrf v2 ena
     afi-ovrf v2 red conn
     exit
    router bgp6 1
     vrf v1
     address vpnuni ovpnuni
     local-as 1
     router 6.6.6.3
     neigh 4321::2 remote-as 1
     neigh 4321::2 update lo1
     neigh 4321::2 send-comm both
     exit
    int lo2
     vrf for v2
     ipv4 addr 2.2.2.13 255.255.255.255
     ipv6 addr 4321::13 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo3
     vrf for v2
     ipv4 addr 2.2.2.23 255.255.255.255
     ipv6 addr 4321::23 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.5
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.12 vrf v1
    r1 tping 100 60 2.2.2.22 vrf v1
    r1 tping 100 60 2.2.2.13 vrf v1
    r1 tping 100 60 2.2.2.23 vrf v1
    r1 tping 100 60 4321::12 vrf v1
    r1 tping 100 60 4321::22 vrf v1
    r1 tping 100 60 4321::13 vrf v1
    r1 tping 100 60 4321::23 vrf v1
    r2 tping 100 60 2.2.2.1 vrf v2
    r2 tping 100 60 2.2.2.11 vrf v2
    r2 tping 100 60 2.2.2.21 vrf v2
    r2 tping 100 60 2.2.2.13 vrf v2
    r2 tping 100 60 2.2.2.23 vrf v2
    r2 tping 100 60 4321::1 vrf v2
    r2 tping 100 60 4321::11 vrf v2
    r2 tping 100 60 4321::21 vrf v2
    r2 tping 100 60 4321::13 vrf v2
    r2 tping 100 60 4321::23 vrf v2
    r3 tping 100 60 2.2.2.1 vrf v2
    r3 tping 100 60 2.2.2.11 vrf v2
    r3 tping 100 60 2.2.2.21 vrf v2
    r3 tping 100 60 2.2.2.12 vrf v2
    r3 tping 100 60 2.2.2.22 vrf v2
    r3 tping 100 60 4321::1 vrf v2
    r3 tping 100 60 4321::11 vrf v2
    r3 tping 100 60 4321::21 vrf v2
    r3 tping 100 60 4321::12 vrf v2
    r3 tping 100 60 4321::22 vrf v2
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-redist06](../clab/rout-redist06/rout-redist06.yml) file  
        3. Launch ContainerLab `rout-redist06.yml` topology:  

        ```
           containerlab deploy --topo rout-redist06.yml  
        ```
        4. Destroy ContainerLab `rout-redist06.yml` topology:  

        ```
           containerlab destroy --topo rout-redist06.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-redist06.tst` file [here](../tst/rout-redist06.tst)  
        3. Launch `rout-redist06.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-redist06 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-redist06.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

