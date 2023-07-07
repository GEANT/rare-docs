# Example: babel triangle connection

=== "Topology"

    ![Alt text](../d2/rout-babel23/rout-babel23.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router babel4 1
     vrf v1
     router 1111-2222-3333-0001
     red conn
     exit
    router babel6 1
     vrf v1
     router 1111-2222-3333-0001
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
     router babel4 1 ena
     router babel6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.10 255.255.255.252
     ipv6 addr 1234:3::2 ffff:ffff::
     router babel4 1 ena
     router babel6 1 ena
     router babel4 1 metric-in 40000
     router babel6 1 metric-in 40000
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router babel4 1
     vrf v1
     router 1111-2222-3333-0002
     red conn
     exit
    router babel6 1
     vrf v1
     router 1111-2222-3333-0002
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
     router babel4 1 ena
     router babel6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     router babel4 1 ena
     router babel6 1 ena
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    router babel4 1
     vrf v1
     router 1111-2222-3333-0003
     red conn
     exit
    router babel6 1
     vrf v1
     router 1111-2222-3333-0003
     red conn
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
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
     router babel4 1 ena
     router babel6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     ipv6 addr 1234:3::1 ffff:ffff::
     router babel4 1 ena
     router babel6 1 ena
     router babel4 1 metric-in 40000
     router babel6 1 metric-in 40000
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 40 2.2.2.2 vrf v1 sou lo1
    r1 tping 100 40 2.2.2.3 vrf v1 sou lo1
    r1 tping 100 40 4321::2 vrf v1 sou lo1
    r1 tping 100 40 4321::3 vrf v1 sou lo1
    r2 tping 100 40 2.2.2.1 vrf v1 sou lo1
    r2 tping 100 40 2.2.2.3 vrf v1 sou lo1
    r2 tping 100 40 4321::1 vrf v1 sou lo1
    r2 tping 100 40 4321::3 vrf v1 sou lo1
    r3 tping 100 40 2.2.2.1 vrf v1 sou lo1
    r3 tping 100 40 2.2.2.2 vrf v1 sou lo1
    r3 tping 100 40 4321::1 vrf v1 sou lo1
    r3 tping 100 40 4321::2 vrf v1 sou lo1
    r2 output show ipv4 babel 1 sum
    r2 output show ipv6 babel 1 sum
    r2 output show ipv4 babel 1 dat
    r2 output show ipv6 babel 1 dat
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-babel23](../clab/rout-babel23/rout-babel23.yml) file  
        3. Launch ContainerLab `rout-babel23.yml` topology:  

        ```
           containerlab deploy --topo rout-babel23.yml  
        ```
        4. Destroy ContainerLab `rout-babel23.yml` topology:  

        ```
           containerlab destroy --topo rout-babel23.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-babel23.tst` file [here](../tst/rout-babel23.tst)  
        3. Launch `rout-babel23.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-babel23 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-babel23.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

