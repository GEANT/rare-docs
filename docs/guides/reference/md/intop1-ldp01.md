# Example: interop1: ldp lsp

=== "Topology"

    ![Alt text](../d2/intop1-ldp01/intop1-ldp01.svg)

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
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
    ! ipv4 access-group-out test4
     ipv6 access-group-out test6
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.252
     pseudo v1 lo0 pweompls 2.2.2.3 1234
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
     ipv6 address 1234:1::2/64
     mpls ip
     no shutdown
     exit
    interface gigabit2
     ip address 1.1.2.2 255.255.255.0
     ipv6 address 1234:2::2/64
     mpls ip
     no shutdown
     exit
    ip route 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route 4321::1/128 1234:1::1
    ip route 2.2.2.3 255.255.255.255 1.1.2.1
    ipv6 route 4321::3/128 1234:2::1
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
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1234:2::1 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
    ! ipv4 access-group-out test4
     ipv6 access-group-out test6
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.252
     pseudo v1 lo0 pweompls 2.2.2.1 1234
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 0 10 1.1.1.2 vrf v1
    r3 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r3 tping 0 10 1.1.2.2 vrf v1
    r1 tping 100 40 3.3.3.2 vrf v1
    r3 tping 100 40 3.3.3.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-ldp01](../clab/intop1-ldp01/intop1-ldp01.yml) file  
        3. Launch ContainerLab `intop1-ldp01.yml` topology:  

        ```
           containerlab deploy --topo intop1-ldp01.yml  
        ```
        4. Destroy ContainerLab `intop1-ldp01.yml` topology:  

        ```
           containerlab destroy --topo intop1-ldp01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-ldp01.tst` file [here](../tst/intop1-ldp01.tst)  
        3. Launch `intop1-ldp01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-ldp01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-ldp01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

