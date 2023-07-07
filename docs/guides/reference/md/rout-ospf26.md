# Example: ospf with bfd

=== "Topology"

    ![Alt text](../d2/rout-ospf26/rout-ospf26.svg)

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
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv4 bfd 100 100 3
     router ospf4 1 ena
     router ospf4 1 bfd
     ipv6 addr 1234:1::1 ffff:ffff::
     ipv6 bfd 100 100 3
     router ospf6 1 ena
     router ospf6 1 bfd
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv4 bfd 100 100 3
     router ospf4 1 ena
     router ospf4 1 bfd
     router ospf4 1 cost 10
     ipv6 addr 1234:2::1 ffff:ffff::
     ipv6 bfd 100 100 3
     router ospf6 1 ena
     router ospf6 1 bfd
     router ospf6 1 cost 10
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
     area 0 ena
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.2
     area 0 ena
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
     ipv4 bfd 100 100 3
     router ospf4 1 ena
     router ospf4 1 bfd
     ipv6 addr 1234:1::2 ffff:ffff::
     ipv6 bfd 100 100 3
     router ospf6 1 ena
     router ospf6 1 bfd
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv4 bfd 100 100 3
     router ospf4 1 ena
     router ospf4 1 bfd
     router ospf4 1 cost 10
     ipv6 addr 1234:2::2 ffff:ffff::
     ipv6 bfd 100 100 3
     router ospf6 1 ena
     router ospf6 1 bfd
     router ospf6 1 cost 10
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 40 2.2.2.2 vrf v1
    r1 tping 100 40 4321::2 vrf v1
    r2 tping 100 40 2.2.2.1 vrf v1
    r2 tping 100 40 4321::1 vrf v1
    sleep 3000
    r1 tping 100 5 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 5 4321::2 vrf v1 sou lo0
    r2 tping 100 5 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 5 4321::1 vrf v1 sou lo0
    r2 send conf t
    r2 send int eth1
    r2 send shut
    r2 send end
    r1 tping 100 5 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 5 4321::2 vrf v1 sou lo0
    r2 tping 100 5 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 5 4321::1 vrf v1 sou lo0
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
        2. Fetch [rout-ospf26](../clab/rout-ospf26/rout-ospf26.yml) file  
        3. Launch ContainerLab `rout-ospf26.yml` topology:  

        ```
           containerlab deploy --topo rout-ospf26.yml  
        ```
        4. Destroy ContainerLab `rout-ospf26.yml` topology:  

        ```
           containerlab destroy --topo rout-ospf26.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-ospf26.tst` file [here](../tst/rout-ospf26.tst)  
        3. Launch `rout-ospf26.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-ospf26 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-ospf26.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

