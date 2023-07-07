# Example: mp2mp ldp tunnel mid+head

=== "Topology"

    ![Alt text](../d2/mpls-ldp16/mpls-ldp16.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
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
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.2
    ipv6 route v1 :: :: 1234:1::2
    access-list test4
     permit all 2.2.2.1 255.255.255.255 all any all
     deny all any all any all
     exit
    access-list test6
     permit all 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all any all
     deny all any all any all
     exit
    int tun1
     tun sou lo0
     tun dest 2.2.2.2
     tun vrf v1
     tun key 1234
     tun mod mp2mpldp
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     ipv4 access-group-out test4
     no ipv4 unreachables
     exit
    int tun2
     tun sou lo0
     tun dest 4321::2
     tun vrf v1
     tun key 1234
     tun mod mp2mpldp
     vrf for v1
     ipv6 addr 3333::1 ffff:ffff::
     ipv6 access-group-out test6
     no ipv6 unreachables
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
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
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1234:2::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int eth3
     vrf for v1
     ipv4 addr 1.1.3.1 255.255.255.0
     ipv6 addr 1234:3::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.2.2
    ipv4 route v1 2.2.2.4 255.255.255.255 1.1.3.2
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    ipv6 route v1 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::2
    access-list test4
     permit all 2.2.2.2 255.255.255.255 all any all
     deny all any all any all
     exit
    access-list test6
     permit all 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all any all
     deny all any all any all
     exit
    int tun1
     tun sou lo0
     tun dest 2.2.2.2
     tun vrf v1
     tun key 1234
     tun mod mp2mpldp
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     ipv4 access-group-out test4
     no ipv4 unreachables
     exit
    int tun2
     tun sou lo0
     tun dest 4321::2
     tun vrf v1
     tun key 1234
     tun mod mp2mpldp
     vrf for v1
     ipv6 addr 3333::2 ffff:ffff::
     ipv6 access-group-out test6
     no ipv6 unreachables
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.2.1
    ipv6 route v1 :: :: 1234:2::1
    access-list test4
     permit all 2.2.2.3 255.255.255.255 all any all
     deny all any all any all
     exit
    access-list test6
     permit all 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all any all
     deny all any all any all
     exit
    int tun1
     tun sou lo0
     tun dest 2.2.2.2
     tun vrf v1
     tun key 1234
     tun mod mp2mpldp
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.0
     ipv4 access-group-out test4
     no ipv4 unreachables
     exit
    int tun2
     tun sou lo0
     tun dest 4321::2
     tun vrf v1
     tun key 1234
     tun mod mp2mpldp
     vrf for v1
     ipv6 addr 3333::3 ffff:ffff::
     ipv6 access-group-out test6
     no ipv6 unreachables
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.3.2 255.255.255.0
     ipv6 addr 1234:3::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.3.1
    ipv6 route v1 :: :: 1234:3::1
    access-list test4
     permit all 2.2.2.4 255.255.255.255 all any all
     deny all any all any all
     exit
    access-list test6
     permit all 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all any all
     deny all any all any all
     exit
    int tun1
     tun sou lo0
     tun dest 2.2.2.2
     tun vrf v1
     tun key 1234
     tun mod mp2mpldp
     vrf for v1
     ipv4 addr 3.3.3.4 255.255.255.0
     ipv4 access-group-out test4
     no ipv4 unreachables
     exit
    int tun2
     tun sou lo0
     tun dest 4321::2
     tun vrf v1
     tun key 1234
     tun mod mp2mpldp
     vrf for v1
     ipv6 addr 3333::4 ffff:ffff::
     ipv6 access-group-out test6
     no ipv6 unreachables
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.3 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.4 vrf v1 sou lo0
    r1 tping 100 10 4321::2 vrf v1 sou lo0
    r1 tping 100 10 4321::3 vrf v1 sou lo0
    r1 tping 100 10 4321::4 vrf v1 sou lo0
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 10 2.2.2.3 vrf v1 sou lo0
    r2 tping 100 10 2.2.2.4 vrf v1 sou lo0
    r2 tping 100 10 4321::1 vrf v1 sou lo0
    r2 tping 100 10 4321::3 vrf v1 sou lo0
    r2 tping 100 10 4321::4 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.4 vrf v1 sou lo0
    r3 tping 100 10 4321::1 vrf v1 sou lo0
    r3 tping 100 10 4321::2 vrf v1 sou lo0
    r3 tping 100 10 4321::4 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.3 vrf v1 sou lo0
    r4 tping 100 10 4321::1 vrf v1 sou lo0
    r4 tping 100 10 4321::2 vrf v1 sou lo0
    r4 tping 100 10 4321::3 vrf v1 sou lo0
    r1 tping 100 10 3.3.3.2 vrf v1 sou lo0
    r1 tping 100 10 3.3.3.3 vrf v1 sou lo0
    r1 tping 100 10 3.3.3.4 vrf v1 sou lo0
    r1 tping 100 10 3333::2 vrf v1 sou lo0
    r1 tping 100 10 3333::3 vrf v1 sou lo0
    r1 tping 100 10 3333::4 vrf v1 sou lo0
    r2 tping 100 10 3.3.3.1 vrf v1 sou lo0
    r2 tping 100 10 3.3.3.3 vrf v1 sou lo0
    r2 tping 100 10 3.3.3.4 vrf v1 sou lo0
    r2 tping 100 10 3333::1 vrf v1 sou lo0
    r2 tping 100 10 3333::3 vrf v1 sou lo0
    r2 tping 100 10 3333::4 vrf v1 sou lo0
    r3 tping 100 10 3.3.3.1 vrf v1 sou lo0
    r3 tping 100 10 3.3.3.2 vrf v1 sou lo0
    r3 tping 100 10 3.3.3.4 vrf v1 sou lo0
    r3 tping 100 10 3333::1 vrf v1 sou lo0
    r3 tping 100 10 3333::2 vrf v1 sou lo0
    r3 tping 100 10 3333::4 vrf v1 sou lo0
    r4 tping 100 10 3.3.3.1 vrf v1 sou lo0
    r4 tping 100 10 3.3.3.2 vrf v1 sou lo0
    r4 tping 100 10 3.3.3.3 vrf v1 sou lo0
    r4 tping 100 10 3333::1 vrf v1 sou lo0
    r4 tping 100 10 3333::2 vrf v1 sou lo0
    r4 tping 100 10 3333::3 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-ldp16](../clab/mpls-ldp16/mpls-ldp16.yml) file  
        3. Launch ContainerLab `mpls-ldp16.yml` topology:  

        ```
           containerlab deploy --topo mpls-ldp16.yml  
        ```
        4. Destroy ContainerLab `mpls-ldp16.yml` topology:  

        ```
           containerlab destroy --topo mpls-ldp16.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-ldp16.tst` file [here](../tst/mpls-ldp16.tst)  
        3. Launch `mpls-ldp16.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-ldp16 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-ldp16.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

