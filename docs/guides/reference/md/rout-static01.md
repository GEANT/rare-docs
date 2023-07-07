# Example: static routing

=== "Topology"

    ![Alt text](../d2/rout-static01/rout-static01.svg)

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
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.2
    ipv6 route v1 :: :: 1234:1::2
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     exit
    ipv4 route v1 2.2.2.101 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    ipv4 route v1 2.2.2.201 255.255.255.255 1.1.1.5
    ipv6 route v1 4321::201 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
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
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.6
    ipv6 route v1 :: :: 1234:2::2
    ```

=== "Verification"

    ```
    r2 tping 100 5 2.2.2.201 vrf v1
    r2 tping 100 5 2.2.2.101 vrf v1
    r2 tping 100 5 4321::201 vrf v1
    r2 tping 100 5 4321::101 vrf v1
    r1 tping 100 5 2.2.2.201 vrf v1
    r1 tping 100 5 4321::201 vrf v1
    r3 tping 100 5 2.2.2.101 vrf v1
    r3 tping 100 5 4321::101 vrf v1
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    output ../binTmp/rout-static.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here are the ipv4 routes:
    here are the ipv6 routes:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-static01](../clab/rout-static01/rout-static01.yml) file  
        3. Launch ContainerLab `rout-static01.yml` topology:  

        ```
           containerlab deploy --topo rout-static01.yml  
        ```
        4. Destroy ContainerLab `rout-static01.yml` topology:  

        ```
           containerlab destroy --topo rout-static01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-static01.tst` file [here](../tst/rout-static01.tst)  
        3. Launch `rout-static01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-static01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-static01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

