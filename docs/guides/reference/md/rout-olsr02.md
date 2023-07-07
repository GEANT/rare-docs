# Example: olsr in chain

=== "Topology"

    ![Alt text](../d2/rout-olsr02/rout-olsr02.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router olsr4 1
     vrf v1
     red conn
     exit
    router olsr6 1
     vrf v1
     red conn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     router olsr4 1 ena
     router olsr6 1 ena
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router olsr4 1
     vrf v1
     red conn
     exit
    router olsr6 1
     vrf v1
     red conn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     router olsr4 1 ena
     router olsr6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     router olsr4 1 ena
     router olsr6 1 ena
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    router olsr4 1
     vrf v1
     red conn
     exit
    router olsr6 1
     vrf v1
     red conn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     router olsr4 1 ena
     router olsr6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     ipv6 addr 1234:3::1 ffff:ffff::
     router olsr4 1 ena
     router olsr6 1 ena
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    router olsr4 1
     vrf v1
     red conn
     exit
    router olsr6 1
     vrf v1
     red conn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.10 255.255.255.252
     ipv6 addr 1234:3::2 ffff:ffff::
     router olsr4 1 ena
     router olsr6 1 ena
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 130 2.2.2.2 vrf v1
    r1 tping 100 130 2.2.2.3 vrf v1
    r1 tping 100 130 2.2.2.4 vrf v1
    r1 tping 100 130 4321::2 vrf v1
    r1 tping 100 130 4321::3 vrf v1
    r1 tping 100 130 4321::4 vrf v1
    r2 tping 100 130 2.2.2.1 vrf v1
    r2 tping 100 130 2.2.2.3 vrf v1
    r2 tping 100 130 2.2.2.4 vrf v1
    r2 tping 100 130 4321::1 vrf v1
    r2 tping 100 130 4321::3 vrf v1
    r2 tping 100 130 4321::4 vrf v1
    r3 tping 100 130 2.2.2.1 vrf v1
    r3 tping 100 130 2.2.2.2 vrf v1
    r3 tping 100 130 2.2.2.4 vrf v1
    r3 tping 100 130 4321::1 vrf v1
    r3 tping 100 130 4321::2 vrf v1
    r3 tping 100 130 4321::4 vrf v1
    r4 tping 100 130 2.2.2.1 vrf v1
    r4 tping 100 130 2.2.2.2 vrf v1
    r4 tping 100 130 2.2.2.3 vrf v1
    r4 tping 100 130 4321::1 vrf v1
    r4 tping 100 130 4321::2 vrf v1
    r4 tping 100 130 4321::3 vrf v1
    r2 output show ipv4 olsr 1 sum
    r2 output show ipv6 olsr 1 sum
    r2 output show ipv4 olsr 1 dat
    r2 output show ipv6 olsr 1 dat
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    output ../binTmp/rout-olsr.html
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
        2. Fetch [rout-olsr02](../clab/rout-olsr02/rout-olsr02.yml) file  
        3. Launch ContainerLab `rout-olsr02.yml` topology:  

        ```
           containerlab deploy --topo rout-olsr02.yml  
        ```
        4. Destroy ContainerLab `rout-olsr02.yml` topology:  

        ```
           containerlab destroy --topo rout-olsr02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-olsr02.tst` file [here](../tst/rout-olsr02.tst)  
        3. Launch `rout-olsr02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-olsr02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-olsr02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

