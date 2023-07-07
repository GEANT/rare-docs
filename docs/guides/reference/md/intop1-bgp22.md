# Example: interop1: vpls/ldp cw over bgp

=== "Topology"

    ![Alt text](../d2/intop1-bgp22/intop1-bgp22.svg)

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
     afi-vpls 1:1 control
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
    ip routing
    ipv6 unicast-routing
    mpls ldp explicit-null
    interface loopback0
     ip addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2/128
     exit
    interface gigabit1
     ip address 1.1.1.2 255.255.255.0
     ipv6 address 1234::2/64
     mpls ip
     no shutdown
     exit
    ip route 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route 4321::1/128 1234::1
    router bgp 1
     neighbor 2.2.2.1 remote-as 1
     neighbor 2.2.2.1 update-source loopback0
     neighbor 4321::1 remote-as 1
     neighbor 4321::1 update-source loopback0
     neighbor 4321::1 shutdown
     address-family l2vpn vpls
      neighbor 2.2.2.1 activate
      neighbor 2.2.2.1 send-community both
      neighbor 2.2.2.1 prefix-length-size 2
      neighbor 4321::1 activate
      neighbor 4321::1 send-community both
      neighbor 4321::1 prefix-length-size 2
     exit
    l2vpn vfi context a
     vpn id 1
     autodiscovery bgp signaling ldp
      vpls-id 1:1
      rd 1:1
      route-target export 1:1
      route-target import 1:1
     exit
    bridge-domain 1
     member vfi a
     exit
    interface bdi1
     ip address 3.3.3.2 255.255.255.252
     ipv6 address 4444::2/64
     no shutdown
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234::2 vrf v1
    r1 tping 100 120 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 120 4321::2 vrf v1 sou lo0
    r1 tping 100 120 3.3.3.2 vrf v1
    r1 tping 100 120 4444::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-bgp22](../clab/intop1-bgp22/intop1-bgp22.yml) file  
        3. Launch ContainerLab `intop1-bgp22.yml` topology:  

        ```
           containerlab deploy --topo intop1-bgp22.yml  
        ```
        4. Destroy ContainerLab `intop1-bgp22.yml` topology:  

        ```
           containerlab destroy --topo intop1-bgp22.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-bgp22.tst` file [here](../tst/intop1-bgp22.tst)  
        3. Launch `intop1-bgp22.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-bgp22 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-bgp22.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

