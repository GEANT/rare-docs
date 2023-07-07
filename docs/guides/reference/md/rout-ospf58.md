# Example: ospf with mpolka

=== "Topology"

    ![Alt text](../d2/rout-ospf58/rout-ospf58.svg)

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
     segrout 10
     area 0 ena
     area 0 segrout
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.1
     segrout 10
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
     mpls enable
     mpolka enable 1 65536 10
     router ospf4 1 ena
     router ospf6 1 ena
     exit
    interface tun1
     tunnel vrf v1
     tunnel source loopback1
     tunnel destination 2.2.2.3
     tunnel domain-name 2.2.2.2 2.2.2.3 , 2.2.2.3 2.2.2.3
     tunnel mode mpolka
     vrf forwarding v1
     ipv4 address 3.3.3.1 255.255.255.252
     exit
    interface tun2
     tunnel vrf v1
     tunnel source loopback1
     tunnel destination 4321::3
     tunnel domain-name 4321::2 4321::3 , 4321::3 4321::3
     tunnel mode mpolka
     vrf forwarding v1
     ipv6 address 3333::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router ospf4 1
     vrf v1
     router 4.4.4.2
     segrout 10
     area 0 ena
     area 0 segrout
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.2
     segrout 10
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
     mpls enable
     mpolka enable 2 65536 10
     router ospf4 1 ena
     router ospf6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     mpls enable
     mpolka enable 2 65536 10
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
    router ospf4 1
     vrf v1
     router 4.4.4.3
     segrout 10
     area 0 ena
     area 0 segrout
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.3
     segrout 10
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
     mpls enable
     mpolka enable 3 65536 10
     router ospf4 1 ena
     router ospf6 1 ena
     exit
    interface tun1
     tunnel vrf v1
     tunnel source loopback1
     tunnel destination 2.2.2.1
     tunnel domain-name 2.2.2.2 2.2.2.1 , 2.2.2.1 2.2.2.1
     tunnel mode mpolka
     vrf forwarding v1
     ipv4 address 3.3.3.2 255.255.255.252
     exit
    interface tun2
     tunnel vrf v1
     tunnel source loopback1
     tunnel destination 4321::1
     tunnel domain-name 4321::2 4321::1 , 4321::1 4321::1
     tunnel mode mpolka
     vrf forwarding v1
     ipv6 address 3333::2 ffff::
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
    r1 tping 100 20 3.3.3.2 vrf v1 sou tun1
    r3 tping 100 20 3.3.3.1 vrf v1 sou tun1
    r1 tping 100 20 3333::2 vrf v1 sou tun2
    r3 tping 100 20 3333::1 vrf v1 sou tun2
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
        2. Fetch [rout-ospf58](../clab/rout-ospf58/rout-ospf58.yml) file  
        3. Launch ContainerLab `rout-ospf58.yml` topology:  

        ```
           containerlab deploy --topo rout-ospf58.yml  
        ```
        4. Destroy ContainerLab `rout-ospf58.yml` topology:  

        ```
           containerlab destroy --topo rout-ospf58.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-ospf58.tst` file [here](../tst/rout-ospf58.tst)  
        3. Launch `rout-ospf58.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-ospf58 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-ospf58.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

