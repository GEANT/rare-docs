# Example: interop2: ldp mp2mp lsp

=== "Topology"

    ![Alt text](../d2/intop2-ldp04/intop2-ldp04.svg)

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
     ipv6 addr 1234::1 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
    ! ipv4 access-group-out test4
     ipv6 access-group-out test6
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
    int tun1
     tun sou lo0
     tun dest 2.2.2.2
     tun vrf v1
     tun key 1234
     tun mod mp2mpldp
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
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
     ipv6 enable
     no shutdown
     exit
    interface gigabit0/0/0/1
     ipv4 address 1.1.2.2 255.255.255.0
     ipv6 address 1235::2/64
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
     mldp
    router static
     address-family ipv4 unicast
      2.2.2.1/32 1.1.1.1 gigabit0/0/0/0
      2.2.2.3/32 1.1.2.1 gigabit0/0/0/1
     address-family ipv6 unicast
      4321::1/128 1234::1 gigabit0/0/0/0
      4321::3/128 1235::1 gigabit0/0/0/1
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
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1235::1 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
    ! ipv4 access-group-out test4
     ipv6 access-group-out test6
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1235::2
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1235::2
    int tun1
     tun sou lo0
     tun dest 2.2.2.2
     tun vrf v1
     tun key 1234
     tun mod mp2mpldp
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.0
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r1 tping 100 60 3.3.3.3 vrf v1 sou lo0
    r3 tping 100 60 3.3.3.1 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop2-ldp04](../clab/intop2-ldp04/intop2-ldp04.yml) file  
        3. Launch ContainerLab `intop2-ldp04.yml` topology:  

        ```
           containerlab deploy --topo intop2-ldp04.yml  
        ```
        4. Destroy ContainerLab `intop2-ldp04.yml` topology:  

        ```
           containerlab destroy --topo intop2-ldp04.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop2-ldp04.tst` file [here](../tst/intop2-ldp04.tst)  
        3. Launch `intop2-ldp04.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop2-ldp04 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop2-ldp04.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

