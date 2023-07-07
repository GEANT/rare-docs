# Example: interop1: point2point ospf

=== "Topology"

    ![Alt text](../d2/intop1-ospf01/intop1-ospf01.svg)

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
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr fe80::1 ffff::
     router ospf4 1 ena
     router ospf6 1 ena
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    ```

    **r2**

    ```
    hostname r2
    ip routing
    ipv6 unicast-routing
    interface loopback0
     ip addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2/128
     exit
    router ospf 1
     redistribute connected subnets
     exit
    ipv6 router ospf 1
     redistribute connected
     exit
    interface gigabit1
     ip address 1.1.1.2 255.255.255.0
     ipv6 enable
     ip ospf network point-to-point
     ip ospf 1 area 0
     ipv6 ospf network point-to-point
     ipv6 ospf 1 area 0
     no shutdown
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-ospf01](../clab/intop1-ospf01/intop1-ospf01.yml) file  
        3. Launch ContainerLab `intop1-ospf01.yml` topology:  

        ```
           containerlab deploy --topo intop1-ospf01.yml  
        ```
        4. Destroy ContainerLab `intop1-ospf01.yml` topology:  

        ```
           containerlab destroy --topo intop1-ospf01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-ospf01.tst` file [here](../tst/intop1-ospf01.tst)  
        3. Launch `intop1-ospf01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-ospf01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-ospf01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

