# Example: ldp php

=== "Topology"

    ![Alt text](../d2/mpls-ldp25/mpls-ldp25.svg)

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
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff:ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     no ipv4 unreachables
     no ipv6 unreachables
     mpls enable
     mpls ldp4
     mpls ldp6
     mpls label4pop
     mpls label6pop
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
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
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234:1::2 ffff:ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     no ipv4 unreachables
     no ipv6 unreachables
     mpls enable
     mpls ldp4
     mpls ldp6
     mpls label4pop
     mpls label6pop
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1234:2::2 ffff:ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     no ipv4 unreachables
     no ipv6 unreachables
     mpls enable
     mpls ldp4
     mpls ldp6
     mpls label4pop
     mpls label6pop
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.2.3
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::3
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
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.3 255.255.255.0
     ipv6 addr 1234:2::3 ffff:ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     no ipv4 unreachables
     no ipv6 unreachables
     mpls enable
     mpls ldp4
     mpls ldp6
     mpls label4pop
     mpls label6pop
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.2.2
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
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
    r2 tping 0 10 1.1.1.1 vrf v1
    r2 tping 0 10 1.1.2.3 vrf v1
    r3 tping 0 10 1.1.2.2 vrf v1
    r1 tping 0 10 2.2.2.2 vrf v1 sou lo0
    r1 tping 0 10 4321::2 vrf v1 sou lo0
    r1 tping 0 10 2.2.2.3 vrf v1 sou lo0
    r1 tping 0 10 4321::3 vrf v1 sou lo0
    r2 tping 0 10 2.2.2.1 vrf v1 sou lo0
    r2 tping 0 10 4321::1 vrf v1 sou lo0
    r2 tping 0 10 2.2.2.3 vrf v1 sou lo0
    r2 tping 0 10 4321::3 vrf v1 sou lo0
    r3 tping 0 10 2.2.2.1 vrf v1 sou lo0
    r3 tping 0 10 4321::1 vrf v1 sou lo0
    r3 tping 0 10 2.2.2.2 vrf v1 sou lo0
    r3 tping 0 10 4321::2 vrf v1 sou lo0
    r1 tping 100 40 3.3.3.2 vrf v1
    r3 tping 100 40 3.3.3.1 vrf v1
    r1 tping 100 40 3.3.4.2 vrf v1
    r3 tping 100 40 3.3.4.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-ldp25](../clab/mpls-ldp25/mpls-ldp25.yml) file  
        3. Launch ContainerLab `mpls-ldp25.yml` topology:  

        ```
           containerlab deploy --topo mpls-ldp25.yml  
        ```
        4. Destroy ContainerLab `mpls-ldp25.yml` topology:  

        ```
           containerlab destroy --topo mpls-ldp25.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-ldp25.tst` file [here](../tst/mpls-ldp25.tst)  
        3. Launch `mpls-ldp25.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-ldp25 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-ldp25.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

