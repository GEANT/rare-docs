# Example: interop8: bgp with php labels

=== "Topology"

    ![Alt text](../d2/intop8-bgp14/intop8-bgp14.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny 58 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff::
     mpls enable
     ipv4 access-group-in test4
     ipv6 access-group-in test6
    ! ipv4 access-group-out test4
    ! ipv6 access-group-out test6
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address lab
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 2
     neigh 1.1.1.2 label-pop
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address lab
     local-as 1
     router-id 6.6.6.1
     neigh 1234:1::2 remote-as 2
     neigh 1234:1::2 label-pop
     red conn
     exit
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     pseudo v1 lo0 pweompls 2.2.2.3 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 3.3.4.1 255.255.255.0
     pseudo v1 lo0 pweompls 4321::3 1234
     exit
    ```

    **r2**

    ```
    hostname r2
    ip forwarding
    ipv6 forwarding
    interface lo
     ip addr 2.2.2.2/32
     ipv6 addr 4321::2/128
     exit
    interface ens3
     ip address 1.1.1.2/24
     ipv6 address 1234:1::2/64
     no shutdown
     exit
    interface ens4
     ip address 1.1.2.2/24
     ipv6 address 1234:2::2/64
     no shutdown
     exit
    route-map all permit 10
     exit
    router bgp 2
     neighbor 1.1.1.1 remote-as 1
     neighbor 1234:1::1 remote-as 1
     neighbor 1.1.2.1 remote-as 3
     neighbor 1234:2::1 remote-as 3
     address-family ipv4 unicast
      no neighbor 1.1.1.1 activate
      no neighbor 1234:1::1 activate
      no neighbor 1.1.2.1 activate
      no neighbor 1234:2::1 activate
      neighbor 1.1.1.1 route-map all in
      neighbor 1.1.1.1 route-map all out
      neighbor 1.1.2.1 route-map all in
      neighbor 1.1.2.1 route-map all out
     address-family ipv6 unicast
      no neighbor 1.1.1.1 activate
      no neighbor 1234:1::1 activate
      no neighbor 1.1.2.1 activate
      no neighbor 1234:2::1 activate
      neighbor 1234:1::1 route-map all in
      neighbor 1234:1::1 route-map all out
      neighbor 1234:2::1 route-map all in
      neighbor 1234:2::1 route-map all out
     address-family ipv4 label
      neighbor 1.1.1.1 activate
      neighbor 1.1.1.1 route-map all in
      neighbor 1.1.1.1 route-map all out
      neighbor 1.1.2.1 activate
      neighbor 1.1.2.1 route-map all in
      neighbor 1.1.2.1 route-map all out
      redistribute connected
     address-family ipv6 label
      neighbor 1234:1::1 activate
      neighbor 1234:1::1 route-map all in
      neighbor 1234:1::1 route-map all out
      neighbor 1234:2::1 activate
      neighbor 1234:2::1 route-map all in
      neighbor 1234:2::1 route-map all out
      redistribute connected
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
     deny 58 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1234:2::1 ffff::
     mpls enable
     ipv4 access-group-in test4
     ipv6 access-group-in test6
    ! ipv4 access-group-out test4
    ! ipv6 access-group-out test6
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address lab
     local-as 3
     router-id 4.4.4.3
     neigh 1.1.2.2 remote-as 2
     neigh 1.1.2.2 label-pop
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address lab
     local-as 3
     router-id 6.6.6.3
     neigh 1234:2::2 remote-as 2
     neigh 1234:2::2 label-pop
     red conn
     exit
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     pseudo v1 lo0 pweompls 2.2.2.1 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 3.3.4.2 255.255.255.0
     pseudo v1 lo0 pweompls 4321::1 1234
     exit
    ```

=== "Verification"

    ```
    r1 tping 0 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234:1::2 vrf v1
    r3 tping 0 10 1.1.2.2 vrf v1
    r3 tping 100 10 1234:2::2 vrf v1
    r1 tping 0 60 2.2.2.2 vrf v1 sou lo0
    !r1 tping 0 60 4321::2 vrf v1 sou lo0
    r3 tping 0 60 2.2.2.2 vrf v1 sou lo0
    !r3 tping 0 60 4321::2 vrf v1 sou lo0
    r1 tping 0 60 2.2.2.3 vrf v1 sou lo0
    r1 tping 0 60 4321::3 vrf v1 sou lo0
    r3 tping 0 60 2.2.2.1 vrf v1 sou lo0
    r3 tping 0 60 4321::1 vrf v1 sou lo0
    r1 tping 100 40 3.3.3.2 vrf v1
    r3 tping 100 40 3.3.3.1 vrf v1
    r1 tping 100 40 3.3.4.2 vrf v1
    r3 tping 100 40 3.3.4.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop8-bgp14](../clab/intop8-bgp14/intop8-bgp14.yml) file  
        3. Launch ContainerLab `intop8-bgp14.yml` topology:  

        ```
           containerlab deploy --topo intop8-bgp14.yml  
        ```
        4. Destroy ContainerLab `intop8-bgp14.yml` topology:  

        ```
           containerlab destroy --topo intop8-bgp14.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop8-bgp14.tst` file [here](../tst/intop8-bgp14.tst)  
        3. Launch `intop8-bgp14.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop8-bgp14 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop8-bgp14.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

