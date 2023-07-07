# Example: lsrp stub interface

=== "Topology"

    ![Alt text](../d2/rout-lsrp26/rout-lsrp26.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.1
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.1
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
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.2
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.2
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
     router lsrp4 1 ena
     router lsrp4 1 stub
     router lsrp6 1 ena
     router lsrp6 1 stub
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     router lsrp4 1 ena
     router lsrp4 1 stub
     router lsrp6 1 ena
     router lsrp6 1 stub
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.3
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.3
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
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     ipv6 addr 1234:3::1 ffff:ffff::
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.4
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.4
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
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 40 2.2.2.1 vrf v1
    r2 tping 100 40 2.2.2.3 vrf v1
    r2 tping 100 40 2.2.2.4 vrf v1
    r2 tping 100 40 4321::1 vrf v1
    r2 tping 100 40 4321::3 vrf v1
    r2 tping 100 40 4321::4 vrf v1
    r1 tping 100 40 2.2.2.2 vrf v1
    r1 tping 0 40 2.2.2.3 vrf v1
    r1 tping 0 40 2.2.2.4 vrf v1
    r1 tping 100 40 4321::2 vrf v1
    r1 tping 0 40 4321::3 vrf v1
    r1 tping 0 40 4321::4 vrf v1
    r3 tping 0 40 2.2.2.1 vrf v1
    r3 tping 100 40 2.2.2.2 vrf v1
    r3 tping 100 40 2.2.2.4 vrf v1
    r3 tping 0 40 4321::1 vrf v1
    r3 tping 100 40 4321::2 vrf v1
    r3 tping 100 40 4321::4 vrf v1
    r4 tping 0 40 2.2.2.1 vrf v1
    r4 tping 100 40 2.2.2.2 vrf v1
    r4 tping 100 40 2.2.2.3 vrf v1
    r4 tping 0 40 4321::1 vrf v1
    r4 tping 100 40 4321::2 vrf v1
    r4 tping 100 40 4321::3 vrf v1
    r2 output show ipv4 lsrp 1 nei
    r2 output show ipv6 lsrp 1 nei
    r2 output show ipv4 lsrp 1 dat
    r2 output show ipv6 lsrp 1 dat
    r2 output show ipv4 lsrp 1 tre
    r2 output show ipv6 lsrp 1 tre
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-lsrp26](../clab/rout-lsrp26/rout-lsrp26.yml) file  
        3. Launch ContainerLab `rout-lsrp26.yml` topology:  

        ```
           containerlab deploy --topo rout-lsrp26.yml  
        ```
        4. Destroy ContainerLab `rout-lsrp26.yml` topology:  

        ```
           containerlab destroy --topo rout-lsrp26.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-lsrp26.tst` file [here](../tst/rout-lsrp26.tst)  
        3. Launch `rout-lsrp26.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-lsrp26 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-lsrp26.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

