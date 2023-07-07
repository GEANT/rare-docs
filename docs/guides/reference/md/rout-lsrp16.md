# Example: lsrp with sr

=== "Topology"

    ![Alt text](../d2/rout-lsrp16/rout-lsrp16.svg)

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
    router lsrp4 1
     vrf v1
     router 4.4.4.1
     segrout 10 1
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.1
     segrout 10 1
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
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.2
     segrout 10 2
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.2
     segrout 10 2
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
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1235::2 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     router lsrp4 1 ena
     router lsrp6 1 ena
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
    router lsrp4 1
     vrf v1
     router 4.4.4.3
     segrout 10 3
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.3
     segrout 10 3
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
     router lsrp4 1 ena
     router lsrp6 1 ena
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
    r2 output show ipv4 lsrp 1 nei
    r2 output show ipv6 lsrp 1 nei
    r2 output show ipv4 lsrp 1 dat
    r2 output show ipv6 lsrp 1 dat
    r2 output show ipv4 lsrp 1 tre
    r2 output show ipv6 lsrp 1 tre
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    r2 output show ipv4 segrou v1
    r2 output show ipv6 segrou v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-lsrp16](../clab/rout-lsrp16/rout-lsrp16.yml) file  
        3. Launch ContainerLab `rout-lsrp16.yml` topology:  

        ```
           containerlab deploy --topo rout-lsrp16.yml  
        ```
        4. Destroy ContainerLab `rout-lsrp16.yml` topology:  

        ```
           containerlab destroy --topo rout-lsrp16.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-lsrp16.tst` file [here](../tst/rout-lsrp16.tst)  
        3. Launch `rout-lsrp16.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-lsrp16 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-lsrp16.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

