# Example: pvrp with selective sr

=== "Topology"

    ![Alt text](../d2/rout-pvrp51/rout-pvrp51.svg)

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
    router pvrp4 1
     vrf v1
     router 4.4.4.1
     segrout 10 0
     red conn
     exit
    router pvrp6 1
     vrf v1
     router 6.6.6.1
     segrout 10 0
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router pvrp4 1 ena
     router pvrp6 1 ena
     router pvrp4 1 segrou 1
     router pvrp6 1 segrou 1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     router pvrp4 1 ena
     router pvrp6 1 ena
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
    router pvrp4 1
     vrf v1
     router 4.4.4.2
     segrout 10 0
     red conn
     exit
    router pvrp6 1
     vrf v1
     router 6.6.6.2
     segrout 10 0
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router pvrp4 1 ena
     router pvrp6 1 ena
     router pvrp4 1 segrou 2
     router pvrp6 1 segrou 2
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     router pvrp4 1 ena
     router pvrp6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1235::2 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     router pvrp4 1 ena
     router pvrp6 1 ena
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
    router pvrp4 1
     vrf v1
     router 4.4.4.3
     segrout 10 0
     red conn
     exit
    router pvrp6 1
     vrf v1
     router 6.6.6.3
     segrout 10 0
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router pvrp4 1 ena
     router pvrp6 1 ena
     router pvrp4 1 segrou 3
     router pvrp6 1 segrou 3
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.3 255.255.255.0
     ipv6 addr 1235::3 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     router pvrp4 1 ena
     router pvrp6 1 ena
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r1 tping 100 20 2.2.2.3 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.3 vrf v1 sou lo1
    r3 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r3 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r1 tping 100 20 4321::2 vrf v1 sou lo1
    r1 tping 100 20 4321::3 vrf v1 sou lo1
    r2 tping 100 20 4321::1 vrf v1 sou lo1
    r2 tping 100 20 4321::3 vrf v1 sou lo1
    r3 tping 100 20 4321::1 vrf v1 sou lo1
    r3 tping 100 20 4321::2 vrf v1 sou lo1
    r2 output show ipv4 pvrp 1 sum
    r2 output show ipv6 pvrp 1 sum
    r2 output show ipv4 pvrp 1 rou
    r2 output show ipv6 pvrp 1 rou
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-pvrp51](../clab/rout-pvrp51/rout-pvrp51.yml) file  
        3. Launch ContainerLab `rout-pvrp51.yml` topology:  

        ```
           containerlab deploy --topo rout-pvrp51.yml  
        ```
        4. Destroy ContainerLab `rout-pvrp51.yml` topology:  

        ```
           containerlab destroy --topo rout-pvrp51.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-pvrp51.tst` file [here](../tst/rout-pvrp51.tst)  
        3. Launch `rout-pvrp51.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-pvrp51 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-pvrp51.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

