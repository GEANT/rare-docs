# Example: recursive static routing with labels

=== "Topology"

    ![Alt text](../d2/rout-static10/rout-static10.svg)

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
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.102 255.255.255.255
     ipv6 addr 4321::102 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
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
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.111 255.255.255.255
     ipv6 addr 4321::111 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
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
    ipv4 route v1 2.2.2.102 255.255.255.255 2.2.2.101 recurigp mplsexp
    ipv6 route v1 4321::102 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 4321::101 recurigp mplsexp
    ipv4 route v1 2.2.2.202 255.255.255.255 2.2.2.201 recurigp mplsexp
    ipv6 route v1 4321::202 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 4321::201 recurigp mplsexp
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
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.202 255.255.255.255
     ipv6 addr 4321::202 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
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
    r2 tping 100 5 2.2.2.202 vrf v1 sou lo1
    r2 tping 100 5 2.2.2.102 vrf v1 sou lo1
    r2 tping 100 5 4321::202 vrf v1 sou lo1
    r2 tping 100 5 4321::102 vrf v1 sou lo1
    r1 tping 100 5 2.2.2.202 vrf v1 sou lo1
    r1 tping 100 5 4321::202 vrf v1 sou lo1
    r3 tping 100 5 2.2.2.102 vrf v1 sou lo1
    r3 tping 100 5 4321::102 vrf v1 sou lo1
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-static10](../clab/rout-static10/rout-static10.yml) file  
        3. Launch ContainerLab `rout-static10.yml` topology:  

        ```
           containerlab deploy --topo rout-static10.yml  
        ```
        4. Destroy ContainerLab `rout-static10.yml` topology:  

        ```
           containerlab destroy --topo rout-static10.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-static10.tst` file [here](../tst/rout-static10.tst)  
        3. Launch `rout-static10.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-static10 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-static10.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

