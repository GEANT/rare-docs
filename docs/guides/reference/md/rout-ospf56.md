# Example: ospf dynamic udp cost

=== "Topology"

    ![Alt text](../d2/rout-ospf56/rout-ospf56.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    server echo e
     vrf v1
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
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     router ospf4 1 ena
     router ospf4 1 cost 100
     router ospf6 1 ena
     router ospf6 1 cost 100
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1235::1 ffff::
     router ospf4 1 ena
     router ospf4 1 cost 1
     router ospf6 1 ena
     router ospf6 1 cost 1
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
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     router ospf4 1 ena
     router ospf4 1 cost 2
     router ospf4 1 dynamic-met mod udp
     router ospf6 1 ena
     router ospf6 1 cost 2
     router ospf6 1 dynamic-met mod udp
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1235::2 ffff::
     router ospf4 1 ena
     router ospf4 1 cost 200
     router ospf4 1 dynamic-met mod udp
     router ospf6 1 ena
     router ospf6 1 cost 200
     router ospf6 1 dynamic-met mod udp
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r1 tping 100 20 4321::2 vrf v1 sou lo1
    r2 tping 100 20 4321::1 vrf v1 sou lo1
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
        2. Fetch [rout-ospf56](../clab/rout-ospf56/rout-ospf56.yml) file  
        3. Launch ContainerLab `rout-ospf56.yml` topology:  

        ```
           containerlab deploy --topo rout-ospf56.yml  
        ```
        4. Destroy ContainerLab `rout-ospf56.yml` topology:  

        ```
           containerlab destroy --topo rout-ospf56.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-ospf56.tst` file [here](../tst/rout-ospf56.tst)  
        3. Launch `rout-ospf56.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-ospf56 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-ospf56.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

