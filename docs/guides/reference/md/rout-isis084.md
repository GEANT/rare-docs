# Example: integrated isis inter-level with sr

=== "Topology"

    ![Alt text](../d2/rout-isis084/rout-isis084.svg)

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
    router isis4 1
     vrf v1
     net 11.4444.0000.1111.00
     is-type level2
     traffeng 4.4.4.1
     segrout 10
     both segrout
     red conn
     afi-other enable
     afi-other red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis4 1 ena
     router isis4 1 other-ena
     router isis4 1 segrout index 1
     router isis4 1 segrout other-index 2
     router isis4 1 segrout node
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv4 access-group-in test4
     ipv6 addr 1234:1::1 ffff:ffff::
     ipv6 access-group-in test6
     mpls enable
     router isis4 1 ena
     router isis4 1 other-ena
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
    router isis6 1
     vrf v1
     net 22.6666.0000.2222.00
     is-type both
     traffeng 6.6.6.2
     segrout 10
     both segrout
     red conn
     afi-other enable
     afi-other red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis6 1 ena
     router isis6 1 other-ena
     router isis6 1 segrout index 3
     router isis6 1 segrout other-index 4
     router isis6 1 segrout node
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv4 access-group-in test4
     ipv6 addr 1234:1::2 ffff:ffff::
     ipv6 access-group-in test6
     mpls enable
     router isis6 1 ena
     router isis6 1 other-ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv4 access-group-in test4
     ipv6 addr 1234:2::1 ffff:ffff::
     ipv6 access-group-in test6
     mpls enable
     router isis6 1 ena
     router isis6 1 other-ena
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
    router isis4 1
     vrf v1
     net 22.4444.0000.3333.00
     is-type level1
     traffeng 4.4.4.3
     segrout 10
     both segrout
     red conn
     afi-other enable
     afi-other red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis4 1 ena
     router isis4 1 other-ena
     router isis4 1 segrout index 5
     router isis4 1 segrout other-index 6
     router isis4 1 segrout node
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv4 access-group-in test4
     ipv6 addr 1234:2::2 ffff:ffff::
     ipv6 access-group-in test6
     mpls enable
     router isis4 1 ena
     router isis4 1 other-ena
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r1 tping 100 20 4321::2 vrf v1 sou lo1
    r1 tping 100 20 2.2.2.3 vrf v1 sou lo1
    r1 tping 100 20 4321::3 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r2 tping 100 20 4321::1 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.3 vrf v1 sou lo1
    r2 tping 100 20 4321::3 vrf v1 sou lo1
    r3 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r3 tping 100 20 4321::1 vrf v1 sou lo1
    r3 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r3 tping 100 20 4321::2 vrf v1 sou lo1
    r2 output show ipv4 isis 1 nei
    r2 output show ipv6 isis 1 nei
    r2 output show ipv4 isis 1 dat 2
    r2 output show ipv6 isis 1 dat 2
    r2 output show ipv4 isis 1 tre 2
    r2 output show ipv6 isis 1 tre 2
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    r2 output show ipv4 segrou v1
    r2 output show ipv6 segrou v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-isis084](../clab/rout-isis084/rout-isis084.yml) file  
        3. Launch ContainerLab `rout-isis084.yml` topology:  

        ```
           containerlab deploy --topo rout-isis084.yml  
        ```
        4. Destroy ContainerLab `rout-isis084.yml` topology:  

        ```
           containerlab destroy --topo rout-isis084.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-isis084.tst` file [here](../tst/rout-isis084.tst)  
        3. Launch `rout-isis084.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-isis084 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-isis084.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

