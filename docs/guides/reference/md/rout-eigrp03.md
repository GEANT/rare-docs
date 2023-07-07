# Example: eigrp point2point chain

=== "Topology"

    ![Alt text](../d2/rout-eigrp03/rout-eigrp03.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router eigrp4 1
     vrf v1
     router 4.4.4.1
     as 1
     red conn
     exit
    router eigrp6 1
     vrf v1
     router 6.6.6.1
     as 1
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router eigrp4 1
     vrf v1
     router 4.4.4.2
     as 1
     red conn
     exit
    router eigrp6 1
     vrf v1
     router 6.6.6.2
     as 1
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    router eigrp4 1
     vrf v1
     router 4.4.4.3
     as 1
     red conn
     exit
    router eigrp6 1
     vrf v1
     router 6.6.6.3
     as 1
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     ipv6 addr 1234:3::1 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    router eigrp4 1
     vrf v1
     router 4.4.4.4
     as 1
     red conn
     exit
    router eigrp6 1
     vrf v1
     router 6.6.6.4
     as 1
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.10 255.255.255.252
     ipv6 addr 1234:3::2 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 40 2.2.2.2 vrf v1
    r1 tping 100 40 2.2.2.3 vrf v1
    r1 tping 100 40 2.2.2.4 vrf v1
    r1 tping 100 40 4321::2 vrf v1
    r1 tping 100 40 4321::3 vrf v1
    r1 tping 100 40 4321::4 vrf v1
    r2 tping 100 40 2.2.2.1 vrf v1
    r2 tping 100 40 2.2.2.3 vrf v1
    r2 tping 100 40 2.2.2.4 vrf v1
    r2 tping 100 40 4321::1 vrf v1
    r2 tping 100 40 4321::3 vrf v1
    r2 tping 100 40 4321::4 vrf v1
    r3 tping 100 40 2.2.2.1 vrf v1
    r3 tping 100 40 2.2.2.2 vrf v1
    r3 tping 100 40 2.2.2.4 vrf v1
    r3 tping 100 40 4321::1 vrf v1
    r3 tping 100 40 4321::2 vrf v1
    r3 tping 100 40 4321::4 vrf v1
    r4 tping 100 40 2.2.2.1 vrf v1
    r4 tping 100 40 2.2.2.2 vrf v1
    r4 tping 100 40 2.2.2.3 vrf v1
    r4 tping 100 40 4321::1 vrf v1
    r4 tping 100 40 4321::2 vrf v1
    r4 tping 100 40 4321::3 vrf v1
    r2 output show ipv4 eigrp 1 sum
    r2 output show ipv6 eigrp 1 sum
    r2 output show ipv4 eigrp 1 rou
    r2 output show ipv6 eigrp 1 rou
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    output ../binTmp/rout-eigrp.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here are the ipv4 neighbors:
    here are the ipv6 neighbors:
    here is the ipv4 database:
    here is the ipv6 database:
    here are the ipv4 routes:
    here are the ipv6 routes:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-eigrp03](../clab/rout-eigrp03/rout-eigrp03.yml) file  
        3. Launch ContainerLab `rout-eigrp03.yml` topology:  

        ```
           containerlab deploy --topo rout-eigrp03.yml  
        ```
        4. Destroy ContainerLab `rout-eigrp03.yml` topology:  

        ```
           containerlab destroy --topo rout-eigrp03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-eigrp03.tst` file [here](../tst/rout-eigrp03.tst)  
        3. Launch `rout-eigrp03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-eigrp03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-eigrp03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

