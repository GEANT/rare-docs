# Example: vpns over srv6 over bgp route server

=== "Topology"

    ![Alt text](../d2/rout-bgp367/rout-bgp367.svg)

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
     ipv6 addr 1234::1 ffff:ffff::
     exit
    int tun1
     vrf for v1
     ipv6 addr 4321:1:: ffff:ffff::
     tun sour eth1
     tun dest 4321:1::
     tun vrf v1
     tun mod srv6
     exit
    ipv6 route v1 4321:2:: ffff:ffff:: 1234::2
    router bgp4 1
     vrf v1
     no safe-ebgp
     address vpnuni ovpnuni
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.3 remote-as 3
     neigh 1.1.1.3 send-comm both
     neigh 1.1.1.3 segrou
     afi-vrf v3 ena
     afi-vrf v3 srv6 tun1
     afi-vrf v3 red conn
     afi-ovrf v3 ena
     afi-ovrf v3 srv6 tun1
     afi-ovrf v3 red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address vpnuni ovpnuni
     local-as 1
     router-id 6.6.6.1
     neigh 1234::3 remote-as 3
     neigh 1234::3 send-comm both
     neigh 1234::3 segrou
     afi-vrf v2 ena
     afi-vrf v2 srv6 tun1
     afi-vrf v2 red conn
     afi-vrf v4 ena
     afi-vrf v4 srv6 tun1
     afi-vrf v4 red conn
     afi-ovrf v2 ena
     afi-ovrf v2 srv6 tun1
     afi-ovrf v2 red conn
     afi-ovrf v4 ena
     afi-ovrf v4 srv6 tun1
     afi-ovrf v4 red conn
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
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff:ffff::
     exit
    int tun1
     vrf for v1
     ipv6 addr 4321:2:: ffff:ffff::
     tun sour eth1
     tun dest 4321:2::
     tun vrf v1
     tun mod srv6
     exit
    ipv6 route v1 4321:1:: ffff:ffff:: 1234::1
    router bgp4 1
     vrf v1
     no safe-ebgp
     address vpnuni ovpnuni
     local-as 2
     router-id 4.4.4.2
     neigh 1.1.1.3 remote-as 3
     neigh 1.1.1.3 send-comm both
     neigh 1.1.1.3 segrou
     afi-vrf v3 ena
     afi-vrf v3 srv6 tun1
     afi-vrf v3 red conn
     afi-ovrf v3 ena
     afi-ovrf v3 srv6 tun1
     afi-ovrf v3 red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address vpnuni ovpnuni
     local-as 2
     router-id 6.6.6.3
     neigh 1234::3 remote-as 3
     neigh 1234::3 send-comm both
     neigh 1234::3 segrou
     afi-vrf v2 ena
     afi-vrf v2 srv6 tun1
     afi-vrf v2 red conn
     afi-vrf v4 ena
     afi-vrf v4 srv6 tun1
     afi-vrf v4 red conn
     afi-ovrf v2 ena
     afi-ovrf v2 srv6 tun1
     afi-ovrf v2 red conn
     afi-ovrf v4 ena
     afi-ovrf v4 srv6 tun1
     afi-ovrf v4 red conn
     exit
    ```

    **r3**

    ```
    hostname r3
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
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address vpnuni ovpnuni
     local-as 3
     router-id 4.4.4.3
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 send-comm both
     neigh 1.1.1.1 segrou
     neigh 1.1.1.1 route-server
     neigh 1.1.1.2 remote-as 2
     neigh 1.1.1.2 send-comm both
     neigh 1.1.1.2 segrou
     neigh 1.1.1.2 route-server
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address vpnuni ovpnuni
     local-as 3
     router-id 4.4.4.3
     neigh 1234::1 remote-as 1
     neigh 1234::1 send-comm both
     neigh 1234::1 segrou
     neigh 1234::1 route-server
     neigh 1234::2 remote-as 2
     neigh 1234::2 send-comm both
     neigh 1234::2 segrou
     neigh 1234::2 route-server
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 1234::2 vrf v1
    r2 tping 100 60 1234::1 vrf v1
    r1 tping 100 60 9.9.2.3 vrf v2
    r2 tping 100 60 9.9.2.1 vrf v2
    r1 tping 100 60 9992::3 vrf v2
    r2 tping 100 60 9992::1 vrf v2
    r1 tping 100 60 9.9.3.3 vrf v3
    r2 tping 100 60 9.9.3.1 vrf v3
    r1 tping 100 60 9993::3 vrf v3
    r2 tping 100 60 9993::1 vrf v3
    r1 tping 100 60 9.9.4.3 vrf v4
    r2 tping 100 60 9.9.4.1 vrf v4
    r1 tping 100 60 9994::3 vrf v4
    r2 tping 100 60 9994::1 vrf v4
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp367](../clab/rout-bgp367/rout-bgp367.yml) file  
        3. Launch ContainerLab `rout-bgp367.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp367.yml  
        ```
        4. Destroy ContainerLab `rout-bgp367.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp367.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp367.tst` file [here](../tst/rout-bgp367.tst)  
        3. Launch `rout-bgp367.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp367 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp367.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

