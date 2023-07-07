# Example: pvrp with php labels

=== "Topology"

    ![Alt text](../d2/rout-pvrp33/rout-pvrp33.svg)

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
     deny 58 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    router pvrp4 1
     vrf v1
     router 4.4.4.1
     label
     red conn
     exit
    router pvrp6 1
     vrf v1
     router 6.6.6.1
     label
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     router pvrp4 1 ena
     router pvrp4 1 label-pop
     router pvrp6 1 ena
     router pvrp6 1 label-pop
     exit
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     pseudo v1 lo1 pweompls 2.2.2.3 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 3.3.4.1 255.255.255.0
     pseudo v1 lo1 pweompls 4321::3 1234
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
     deny 58 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    router pvrp4 1
     vrf v1
     router 4.4.4.2
     label
     red conn
     exit
    router pvrp6 1
     vrf v1
     router 6.6.6.2
     label
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     router pvrp4 1 ena
     router pvrp4 1 label-pop
     router pvrp6 1 ena
     router pvrp6 1 label-pop
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1235::2 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     router pvrp4 1 ena
     router pvrp4 1 label-pop
     router pvrp6 1 ena
     router pvrp6 1 label-pop
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny 58 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    router pvrp4 1
     vrf v1
     router 4.4.4.3
     label
     red conn
     exit
    router pvrp6 1
     vrf v1
     router 6.6.6.3
     label
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.3 255.255.255.0
     ipv6 addr 1235::3 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     router pvrp4 1 ena
     router pvrp4 1 label-pop
     router pvrp6 1 ena
     router pvrp6 1 label-pop
     exit
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     pseudo v1 lo1 pweompls 2.2.2.1 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 3.3.4.2 255.255.255.0
     pseudo v1 lo1 pweompls 4321::1 1234
     exit
    ```

=== "Verification"

    ```
    r1 tping 0 20 2.2.2.2 vrf v1 sou lo1
    r1 tping 0 20 2.2.2.3 vrf v1 sou lo1
    r2 tping 0 20 2.2.2.1 vrf v1 sou lo1
    r2 tping 0 20 2.2.2.3 vrf v1 sou lo1
    r3 tping 0 20 2.2.2.1 vrf v1 sou lo1
    r3 tping 0 20 2.2.2.2 vrf v1 sou lo1
    r1 tping 0 20 4321::2 vrf v1 sou lo1
    r1 tping 0 20 4321::3 vrf v1 sou lo1
    r2 tping 0 20 4321::1 vrf v1 sou lo1
    r2 tping 0 20 4321::3 vrf v1 sou lo1
    r3 tping 0 20 4321::1 vrf v1 sou lo1
    r3 tping 0 20 4321::2 vrf v1 sou lo1
    r1 tping 100 40 3.3.3.2 vrf v1
    r3 tping 100 40 3.3.3.1 vrf v1
    r1 tping 100 40 3.3.4.2 vrf v1
    r3 tping 100 40 3.3.4.1 vrf v1
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
        2. Fetch [rout-pvrp33](../clab/rout-pvrp33/rout-pvrp33.yml) file  
        3. Launch ContainerLab `rout-pvrp33.yml` topology:  

        ```
           containerlab deploy --topo rout-pvrp33.yml  
        ```
        4. Destroy ContainerLab `rout-pvrp33.yml` topology:  

        ```
           containerlab destroy --topo rout-pvrp33.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-pvrp33.tst` file [here](../tst/rout-pvrp33.tst)  
        3. Launch `rout-pvrp33.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-pvrp33 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-pvrp33.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

