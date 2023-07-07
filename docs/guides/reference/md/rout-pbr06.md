# Example: policy routing with nexthop on interface between vrfs

=== "Topology"

    ![Alt text](../d2/rout-pbr06/rout-pbr06.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.101 255.255.255.255
     ipv6 addr 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     exit
    access-list a2b4
     permit all 2.2.2.101 255.255.255.255 all 2.2.2.201 255.255.255.255 all
     exit
    access-list a2b6
     permit all 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all 4321::201 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    ipv4 pbr v1 a2b4 v1 next 1.1.1.2
    ipv6 pbr v1 a2b6 v1 next 1234:1::2
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    vrf def v2
     rd 1:1
     exit
    access-list a2b4
     permit all 2.2.2.101 255.255.255.255 all 2.2.2.201 255.255.255.255 all
     exit
    access-list b2a4
     permit all 2.2.2.201 255.255.255.255 all 2.2.2.101 255.255.255.255 all
     exit
    access-list a2b6
     permit all 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all 4321::201 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    access-list b2a6
     permit all 4321::201 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     ipv4 pbr a2b4 v2 next 1.1.1.5
     ipv6 pbr a2b6 v2 next 1234:2::1
     exit
    int eth2
     vrf for v2
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     ipv4 pbr b2a4 v1 next 1.1.1.1
     ipv6 pbr b2a6 v1 next 1234:1::1
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
     ipv4 addr 2.2.2.201 255.255.255.255
     ipv6 addr 4321::201 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     exit
    access-list b2a4
     permit all 2.2.2.201 255.255.255.255 all 2.2.2.101 255.255.255.255 all
     exit
    access-list b2a6
     permit all 4321::201 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    ipv4 pbr v1 b2a4 v1 next 1.1.1.6
    ipv6 pbr v1 b2a6 v1 next 1234:2::2
    ```

=== "Verification"

    ```
    r1 tping 100 5 2.2.2.201 vrf v1 sou lo0
    r1 tping 100 5 4321::201 vrf v1 sou lo0
    r3 tping 100 5 2.2.2.101 vrf v1 sou lo0
    r3 tping 100 5 4321::101 vrf v1 sou lo0
    r1 tping 0 5 2.2.2.201 vrf v1
    r1 tping 0 5 4321::201 vrf v1
    r3 tping 0 5 2.2.2.101 vrf v1
    r3 tping 0 5 4321::101 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-pbr06](../clab/rout-pbr06/rout-pbr06.yml) file  
        3. Launch ContainerLab `rout-pbr06.yml` topology:  

        ```
           containerlab deploy --topo rout-pbr06.yml  
        ```
        4. Destroy ContainerLab `rout-pbr06.yml` topology:  

        ```
           containerlab destroy --topo rout-pbr06.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-pbr06.tst` file [here](../tst/rout-pbr06.tst)  
        3. Launch `rout-pbr06.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-pbr06 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-pbr06.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

