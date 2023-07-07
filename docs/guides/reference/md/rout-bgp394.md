# Example: evpn/vpws over srv6 over confed bgp

=== "Topology"

    ![Alt text](../d2/rout-bgp394/rout-bgp394.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
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
    router bgp4 1
     vrf v1
     no safe-ebgp
     address evpn
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.3 remote-as 3
     neigh 1.1.1.3 send-comm both
     neigh 1.1.1.3 pmsi
     neigh 1.1.1.3 segrou
     afi-evpn 101 bridge 1
     afi-evpn 101 srv6 tun1
     afi-evpn 101 update eth1
     afi-evpn 101 encap vpws
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address evpn
     local-as 1
     router-id 6.6.6.1
     neigh 1234::3 remote-as 3
     neigh 1234::3 send-comm both
     neigh 1234::3 pmsi
     neigh 1234::3 segrou
     afi-evpn 102 bridge 2
     afi-evpn 102 srv6 tun1
     afi-evpn 102 update eth1
     afi-evpn 102 encap vpws
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    bridge 1
     rd 2:1
     rt-both 1:1
     mac-learn
     private
     exit
    bridge 2
     rd 2:2
     rt-both 1:2
     mac-learn
     private
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
    router bgp4 1
     vrf v1
     no safe-ebgp
     address evpn
     local-as 2
     router-id 4.4.4.2
     neigh 1.1.1.3 remote-as 3
     neigh 1.1.1.3 send-comm both
     neigh 1.1.1.3 pmsi
     neigh 1.1.1.3 segrou
     afi-evpn 101 bridge 1
     afi-evpn 101 srv6 tun1
     afi-evpn 101 update eth1
     afi-evpn 101 encap vpws
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address evpn
     local-as 2
     router-id 6.6.6.2
     neigh 1234::3 remote-as 3
     neigh 1234::3 send-comm both
     neigh 1234::3 pmsi
     neigh 1234::3 segrou
     afi-evpn 102 bridge 2
     afi-evpn 102 srv6 tun1
     afi-evpn 102 update eth1
     afi-evpn 102 encap vpws
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
     address evpn
     local-as 3
     router-id 4.4.4.3
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 send-comm both
     neigh 1.1.1.1 pmsi
     neigh 1.1.1.1 segrou
     neigh 1.1.1.1 confed
     neigh 1.1.1.2 remote-as 2
     neigh 1.1.1.2 send-comm both
     neigh 1.1.1.2 pmsi
     neigh 1.1.1.2 segrou
     neigh 1.1.1.2 confed
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address evpn
     local-as 3
     router-id 4.4.4.3
     neigh 1234::1 remote-as 1
     neigh 1234::1 send-comm both
     neigh 1234::1 pmsi
     neigh 1234::1 segrou
     neigh 1234::1 confed
     neigh 1234::2 remote-as 2
     neigh 1234::2 send-comm both
     neigh 1234::2 pmsi
     neigh 1234::2 segrou
     neigh 1234::2 confed
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 1234::2 vrf v1
    r2 tping 100 60 1234::1 vrf v1
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
        2. Fetch [rout-bgp394](../clab/rout-bgp394/rout-bgp394.yml) file  
        3. Launch ContainerLab `rout-bgp394.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp394.yml  
        ```
        4. Destroy ContainerLab `rout-bgp394.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp394.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp394.tst` file [here](../tst/rout-bgp394.tst)  
        3. Launch `rout-bgp394.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp394 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp394.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

