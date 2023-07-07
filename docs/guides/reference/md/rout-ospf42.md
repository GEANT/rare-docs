# Example: ospf with srgb sr

=== "Topology"

    ![Alt text](../d2/rout-ospf42/rout-ospf42.svg)

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
    router ospf4 1
     vrf v1
     router 4.4.4.1
     segrout 10 base 100
     area 0 ena
     area 0 segrout
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.1
     segrout 10 base 200
     area 0 ena
     area 0 segrout
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router ospf4 1 ena
     router ospf4 1 segrout index 1
     router ospf4 1 segrout node
     router ospf6 1 ena
     router ospf6 1 segrout index 1
     router ospf6 1 segrout node
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
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
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    router ospf4 1
     vrf v1
     router 4.4.4.2
     segrout 10 base 100
     area 0 ena
     area 0 segrout
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.2
     segrout 10 base 200
     area 0 ena
     area 0 segrout
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router ospf4 1 ena
     router ospf4 1 segrout index 2
     router ospf4 1 segrout node
     router ospf6 1 ena
     router ospf6 1 segrout index 2
     router ospf6 1 segrout node
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     router ospf4 1 ena
     router ospf6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     router ospf4 1 ena
     router ospf6 1 ena
     exit
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
    router ospf4 1
     vrf v1
     router 4.4.4.3
     segrout 10 base 100
     area 0 ena
     area 0 segrout
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.3
     segrout 10 base 200
     area 0 ena
     area 0 segrout
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router ospf4 1 ena
     router ospf4 1 segrout index 3
     router ospf4 1 segrout node
     router ospf6 1 ena
     router ospf6 1 segrout index 3
     router ospf6 1 segrout node
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     router ospf4 1 ena
     router ospf6 1 ena
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
    r2 output show ipv4 ospf 1 nei
    r2 output show ipv6 ospf 1 nei
    r2 output show ipv4 ospf 1 dat 0
    r2 output show ipv6 ospf 1 dat 0
    r2 output show ipv4 ospf 1 tre 0
    r2 output show ipv6 ospf 1 tre 0
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    r2 output show ipv4 segrou v1
    r2 output show ipv6 segrou v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-ospf42](../clab/rout-ospf42/rout-ospf42.yml) file  
        3. Launch ContainerLab `rout-ospf42.yml` topology:  

        ```
           containerlab deploy --topo rout-ospf42.yml  
        ```
        4. Destroy ContainerLab `rout-ospf42.yml` topology:  

        ```
           containerlab destroy --topo rout-ospf42.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-ospf42.tst` file [here](../tst/rout-ospf42.tst)  
        3. Launch `rout-ospf42.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-ospf42 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-ospf42.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

