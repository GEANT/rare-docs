# Example: rift autoroute

=== "Topology"

    ![Alt text](../d2/rout-rift18/rout-rift18.svg)

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
     deny 58 any all any all
     permit all any all any all
     exit
    router rift4 1
     vrf v1
     router 41
     red conn
     exit
    router rift6 1
     vrf v1
     router 61
     red conn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.11 255.255.255.255
     ipv6 addr 4321::11 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int ser1
     vrf for v1
     ipv4 addr 9.9.9.1 255.255.255.0
     ipv6 addr 9999::1 ffff::
     router rift4 1 ena
     router rift6 1 ena
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    int ser2
     vrf for v1
     ipv4 addr 9.9.8.1 255.255.255.0
     ipv6 addr 9998::1 ffff::
     ipv4 autoroute rift4 1 2.2.2.2 9.9.8.2
     ipv6 autoroute rift6 1 4321::2 9998::2
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
     deny 58 any all any all
     permit all any all any all
     exit
    router rift4 1
     vrf v1
     router 42
     red conn
     exit
    router rift6 1
     vrf v1
     router 62
     red conn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.12 255.255.255.255
     ipv6 addr 4321::12 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int ser1
     vrf for v1
     ipv4 addr 9.9.9.2 255.255.255.0
     ipv6 addr 9999::2 ffff::
     router rift4 1 ena
     router rift6 1 ena
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    int ser2
     vrf for v1
     ipv4 addr 9.9.8.2 255.255.255.0
     ipv6 addr 9998::2 ffff::
     ipv4 autoroute rift4 1 2.2.2.1 9.9.8.1
     ipv6 autoroute rift6 1 4321::1 9998::1
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 40 2.2.2.12 vrf v1
    r1 tping 100 40 4321::12 vrf v1
    r2 tping 100 40 2.2.2.11 vrf v1
    r2 tping 100 40 4321::11 vrf v1
    r1 tping 100 40 2.2.2.2 vrf v1
    r1 tping 100 40 4321::2 vrf v1
    r2 tping 100 40 2.2.2.1 vrf v1
    r2 tping 100 40 4321::1 vrf v1
    r1 tping 0 40 9.9.9.2 vrf v1
    r1 tping 0 40 9999::2 vrf v1
    r2 tping 0 40 9.9.9.1 vrf v1
    r2 tping 0 40 9999::1 vrf v1
    r2 output show ipv4 rift 1 nei
    r2 output show ipv6 rift 1 nei
    r2 output show ipv4 rift 1 dat
    r2 output show ipv6 rift 1 dat
    r2 output show ipv4 rift 1 tre n
    r2 output show ipv6 rift 1 tre n
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-rift18](../clab/rout-rift18/rout-rift18.yml) file  
        3. Launch ContainerLab `rout-rift18.yml` topology:  

        ```
           containerlab deploy --topo rout-rift18.yml  
        ```
        4. Destroy ContainerLab `rout-rift18.yml` topology:  

        ```
           containerlab destroy --topo rout-rift18.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-rift18.tst` file [here](../tst/rout-rift18.tst)  
        3. Launch `rout-rift18.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-rift18 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-rift18.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

