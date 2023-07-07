# Example: ospf autoroute

=== "Topology"

    ![Alt text](../d2/rout-ospf40/rout-ospf40.svg)

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
    router ospf4 1
     vrf v1
     router 4.4.4.1
     area 0 ena
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.1
     area 0 ena
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
     router ospf4 1 ena
     router ospf6 1 ena
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    int ser2
     vrf for v1
     ipv4 addr 9.9.8.1 255.255.255.0
     ipv6 addr 9998::1 ffff::
     ipv4 autoroute ospf4 1 2.2.2.2 9.9.8.2
     ipv6 autoroute ospf6 1 4321::2 9998::2
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
    router ospf4 1
     vrf v1
     router 4.4.4.2
     area 0 ena
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.2
     area 0 ena
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
     router ospf4 1 ena
     router ospf6 1 ena
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    int ser2
     vrf for v1
     ipv4 addr 9.9.8.2 255.255.255.0
     ipv6 addr 9998::2 ffff::
     ipv4 autoroute ospf4 1 2.2.2.1 9.9.8.1
     ipv6 autoroute ospf6 1 4321::1 9998::1
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
    r2 output show ipv4 ospf 1 nei
    r2 output show ipv6 ospf 1 nei
    r2 output show ipv4 ospf 1 dat 0
    r2 output show ipv6 ospf 1 dat 0
    r2 output show ipv4 ospf 1 tre 0
    r2 output show ipv6 ospf 1 tre 0
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-ospf40](../clab/rout-ospf40/rout-ospf40.yml) file  
        3. Launch ContainerLab `rout-ospf40.yml` topology:  

        ```
           containerlab deploy --topo rout-ospf40.yml  
        ```
        4. Destroy ContainerLab `rout-ospf40.yml` topology:  

        ```
           containerlab destroy --topo rout-ospf40.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-ospf40.tst` file [here](../tst/rout-ospf40.tst)  
        3. Launch `rout-ospf40.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-ospf40 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-ospf40.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

