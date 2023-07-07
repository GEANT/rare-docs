# Example: interop2: vpls/ldp over bgp

=== "Topology"

    ![Alt text](../d2/intop2-bgp14/intop2-bgp14.svg)

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
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int bvi1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.252
     ipv6 addr 4444::1 ffff::
     exit
    router bgp4 1
     vrf v1
     address vpls
     local-as 1
     router-id 4.4.4.1
     neigh 2.2.2.2 remote-as 1
     neigh 2.2.2.2 update lo0
     neigh 2.2.2.2 send-comm both
     afi-vpls 1:1 bridge 1
     afi-vpls 1:1 update lo0
     exit
    router bgp6 1
     vrf v1
     address vpls
     local-as 1
     router-id 6.6.6.1
     neigh 4321::2 remote-as 1
     neigh 4321::2 update lo0
     neigh 4321::2 send-comm both
     exit
    ```

    **r2**

    ```
    hostname r2
    interface loopback0
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2/128
     exit
    interface gigabit0/0/0/0
     ipv4 address 1.1.1.2 255.255.255.0
     ipv6 address 1234::2/64
     no shutdown
     exit
    mpls ldp
     address-family ipv4
     address-family ipv6
     interface gigabit0/0/0/0
      address-family ipv4
      address-family ipv6
    l2vpn bridge group a bridge-domain a
       vfi a autodiscovery bgp
         rd 1:1
         route-target import 1:1
         route-target export 1:1
         signaling-protocol ldp vpls-id 1:1
       routed interface bvi1
    interface bvi1
     ipv4 address 3.3.3.2 255.255.255.252
     ipv6 address 4444::2/64
     no shutdown
     exit
    router static
     address-family ipv4 unicast 2.2.2.1/32 1.1.1.1 gigabit0/0/0/0
     address-family ipv6 unicast 4321::1/128 1234::1 gigabit0/0/0/0
     exit
    router bgp 1
     address-family l2vpn vpls-vpws
     neighbor 2.2.2.1
      remote-as 1
      update-source loopback0
      address-family l2vpn vpls-vpws
    ! neighbor 4321::1
    !  remote-as 1
    !  update-source loopback0
    !  address-family l2vpn vpls-vpws
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234::2 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 3.3.3.2 vrf v1
    r1 tping 100 60 4444::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop2-bgp14](../clab/intop2-bgp14/intop2-bgp14.yml) file  
        3. Launch ContainerLab `intop2-bgp14.yml` topology:  

        ```
           containerlab deploy --topo intop2-bgp14.yml  
        ```
        4. Destroy ContainerLab `intop2-bgp14.yml` topology:  

        ```
           containerlab destroy --topo intop2-bgp14.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop2-bgp14.tst` file [here](../tst/intop2-bgp14.tst)  
        3. Launch `intop2-bgp14.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop2-bgp14 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop2-bgp14.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

