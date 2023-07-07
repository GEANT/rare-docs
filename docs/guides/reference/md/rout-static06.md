# Example: static routing with labels

=== "Topology"

    ![Alt text](../d2/rout-static06/rout-static06.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
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
     ipv4 addr 2.2.2.101 255.255.255.255
     ipv6 addr 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls ena
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.2 mplsexp
    ipv6 route v1 :: :: 1234:1::2 mplsexp
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
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
     ipv4 addr 2.2.2.222 255.255.255.255
     ipv6 addr 4321::222 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls ena
     exit
    ipv4 route v1 2.2.2.101 255.255.255.255 1.1.1.1 mplsexp
    ipv6 route v1 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1 mplsexp
    ipv4 route v1 2.2.2.201 255.255.255.255 1.1.1.5 mplsexp
    ipv6 route v1 4321::201 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1 mplsexp
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
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
     ipv4 addr 2.2.2.201 255.255.255.255
     ipv6 addr 4321::201 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls ena
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.6 mplsexp
    ipv6 route v1 :: :: 1234:2::2 mplsexp
    ```

=== "Verification"

    ```
    r2 tping 100 5 2.2.2.201 vrf v1 sou lo0
    r2 tping 100 5 2.2.2.101 vrf v1 sou lo0
    r2 tping 100 5 4321::201 vrf v1 sou lo0
    r2 tping 100 5 4321::101 vrf v1 sou lo0
    r1 tping 100 5 2.2.2.201 vrf v1 sou lo0
    r1 tping 100 5 4321::201 vrf v1 sou lo0
    r3 tping 100 5 2.2.2.101 vrf v1 sou lo0
    r3 tping 100 5 4321::101 vrf v1 sou lo0
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-static06](../clab/rout-static06/rout-static06.yml) file  
        3. Launch ContainerLab `rout-static06.yml` topology:  

        ```
           containerlab deploy --topo rout-static06.yml  
        ```
        4. Destroy ContainerLab `rout-static06.yml` topology:  

        ```
           containerlab destroy --topo rout-static06.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-static06.tst` file [here](../tst/rout-static06.tst)  
        3. Launch `rout-static06.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-static06 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-static06.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

