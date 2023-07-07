# Example: ospf inter area egress filtering with routepolicy

=== "Topology"

    ![Alt text](../d2/rout-ospf24/rout-ospf24.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
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
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.11 255.255.255.255
     ipv6 addr 4321::11 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     router ospf4 1 ena
     router ospf6 1 ena
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    route-policy p4
     if network 2.2.2.8/29 le 32
      drop
     else
      pass
     enif
     exit
    route-policy p6
     if network 4321::10/124 le 128
      drop
     else
      pass
     enif
     exit
    router ospf4 1
     vrf v1
     router 4.4.4.2
     area 0 ena
     area 1 ena
     red conn
     area 0 route-policy-into p4
     area 1 route-policy-into p4
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.2
     area 0 ena
     area 1 ena
     red conn
     area 0 route-policy-into p6
     area 1 route-policy-into p6
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.12 255.255.255.255
     ipv6 addr 4321::12 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     router ospf4 1 ena
     router ospf6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     router ospf4 1 ena
     router ospf4 1 area 1
     router ospf6 1 ena
     router ospf6 1 area 1
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    router ospf4 1
     vrf v1
     router 4.4.4.3
     area 1 ena
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.3
     area 1 ena
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.13 255.255.255.255
     ipv6 addr 4321::13 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     router ospf4 1 ena
     router ospf6 1 ena
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r1 tping 100 20 2.2.2.3 vrf v1
    r1 tping 100 20 4321::3 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r2 tping 100 20 4321::1 vrf v1
    r2 tping 100 20 2.2.2.3 vrf v1
    r2 tping 100 20 4321::3 vrf v1
    r3 tping 100 20 2.2.2.1 vrf v1
    r3 tping 100 20 4321::1 vrf v1
    r3 tping 100 20 2.2.2.2 vrf v1
    r3 tping 100 20 4321::2 vrf v1
    r1 tping 0 20 2.2.2.12 vrf v1
    r1 tping 0 20 4321::12 vrf v1
    r1 tping 0 20 2.2.2.13 vrf v1
    r1 tping 0 20 4321::13 vrf v1
    r2 tping 100 20 2.2.2.11 vrf v1
    r2 tping 100 20 4321::11 vrf v1
    r2 tping 100 20 2.2.2.13 vrf v1
    r2 tping 100 20 4321::13 vrf v1
    r3 tping 0 20 2.2.2.11 vrf v1
    r3 tping 0 20 4321::11 vrf v1
    r3 tping 0 20 2.2.2.12 vrf v1
    r3 tping 0 20 4321::12 vrf v1
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
        2. Fetch [rout-ospf24](../clab/rout-ospf24/rout-ospf24.yml) file  
        3. Launch ContainerLab `rout-ospf24.yml` topology:  

        ```
           containerlab deploy --topo rout-ospf24.yml  
        ```
        4. Destroy ContainerLab `rout-ospf24.yml` topology:  

        ```
           containerlab destroy --topo rout-ospf24.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-ospf24.tst` file [here](../tst/rout-ospf24.tst)  
        3. Launch `rout-ospf24.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-ospf24 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-ospf24.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

