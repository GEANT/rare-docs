# Example: interop2: ldp over point2point ethernet

=== "Topology"

    ![Alt text](../d2/intop2-ldp06/intop2-ldp06.svg)

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
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.11 255.255.255.255
     ipv6 addr 1111::1111:1111 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.254
     ipv6 addr fe80::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffe
     ipv4 access-group-in test4
     ipv6 access-group-in test6
    ! ipv4 access-group-out test4
    ! ipv6 access-group-out test6
     mpls enable
     mpls ldp4
     mpls ldp6 lo1
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.3
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff fe80::2
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.3
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff fe80::2
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.252
     pseudo v1 lo0 pweompls 2.2.2.3 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 3.3.3.5 255.255.255.252
     pseudo v1 lo0 pweompls 4321::3 1234
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
     ipv4 address 1.1.1.3 255.255.255.254
     ipv6 address fe80::2 link-local
     ipv6 enable
     no shutdown
     exit
    interface gigabit0/0/0/1
     ipv4 address 1.1.2.2 255.255.255.254
     ipv6 address fe80::2 link-local
     ipv6 enable
     no shutdown
     exit
    mpls ldp
     address-family ipv4
     address-family ipv6
     interface gigabit0/0/0/0
      address-family ipv4
      address-family ipv6
     interface gigabit0/0/0/1
      address-family ipv4
      address-family ipv6
    router static
     address-family ipv4 unicast 2.2.2.1/32 1.1.1.2 gigabit0/0/0/0
     address-family ipv6 unicast 4321::1/128 fe80::3 gigabit0/0/0/0
     address-family ipv6 unicast 1111::1111:1111/128 fe80::3 gigabit0/0/0/0
     address-family ipv4 unicast 2.2.2.3/32 1.1.2.3 gigabit0/0/0/1
     address-family ipv6 unicast 4321::3/128 fe80::3 gigabit0/0/0/1
     address-family ipv6 unicast 1111::3333:3333/128 fe80::3 gigabit0/0/0/1
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
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.13 255.255.255.255
     ipv6 addr 1111::3333:3333 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.3 255.255.255.254
     ipv6 addr fe80::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffe
     ipv4 access-group-in test4
     ipv6 access-group-in test6
    ! ipv4 access-group-out test4
    ! ipv6 access-group-out test6
     mpls enable
     mpls ldp4
     mpls ldp6 lo1
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff fe80::2
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff fe80::2
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.252
     pseudo v1 lo0 pweompls 2.2.2.1 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 3.3.3.6 255.255.255.252
     pseudo v1 lo0 pweompls 4321::1 1234
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 0 10 1.1.1.3 vrf v1
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    !r1 tping 0 10 4321::2 vrf v1
    r3 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r3 tping 0 10 1.1.2.2 vrf v1
    r3 tping 100 60 4321::2 vrf v1 sou lo0
    !r3 tping 0 10 4321::2 vrf v1
    r1 tping 100 40 3.3.3.2 vrf v1
    r3 tping 100 40 3.3.3.1 vrf v1
    r1 tping 100 40 3.3.3.6 vrf v1
    r3 tping 100 40 3.3.3.5 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop2-ldp06](../clab/intop2-ldp06/intop2-ldp06.yml) file  
        3. Launch ContainerLab `intop2-ldp06.yml` topology:  

        ```
           containerlab deploy --topo intop2-ldp06.yml  
        ```
        4. Destroy ContainerLab `intop2-ldp06.yml` topology:  

        ```
           containerlab destroy --topo intop2-ldp06.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop2-ldp06.tst` file [here](../tst/intop2-ldp06.tst)  
        3. Launch `intop2-ldp06.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop2-ldp06 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop2-ldp06.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

