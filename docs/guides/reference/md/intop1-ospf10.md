# Example: interop1: ospf p2mp te

=== "Topology"

    ![Alt text](../d2/intop1-ospf10/intop1-ospf10.svg)

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
     traffeng 2.2.2.1
     area 0 ena
     area 0 traff
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.1
     traffeng 6.6.6.1
     area 0 ena
     area 0 traff
     red conn
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr fe80::1 ffff::
     router ospf4 1 ena
     router ospf6 1 ena
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    interface tunnel1
     bandwidth 11
     tunnel source loopback0
     tunnel destination 9.9.9.9
     tunnel domain-name 2.2.2.3
     tunnel vrf v1
     tunnel mode p2mpte
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     exit
    ```

    **r2**

    ```
    hostname r2
    ip routing
    ipv6 unicast-routing
    mpls traffic-eng tunnels
    no mpls traffic-eng signalling advertise implicit-null
    interface loopback0
     ip addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2/128
     exit
    router ospf 1
     mpls traffic-eng router-id Loopback0
     mpls traffic-eng area 0
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
     ip rsvp bandwidth
     mpls traffic-eng tunnels
     no shutdown
     exit
    interface gigabit2
     ip address 1.1.2.2 255.255.255.0
     ipv6 enable
     ip ospf network point-to-point
     ip ospf 1 area 0
     ipv6 ospf network point-to-point
     ipv6 ospf 1 area 0
     ip rsvp bandwidth
     mpls traffic-eng tunnels
     no shutdown
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
     traffeng 2.2.2.3
     area 0 ena
     area 0 traff
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.3
     traffeng 6.6.6.3
     area 0 ena
     area 0 traff
     red conn
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr fe80::3 ffff::
     router ospf4 1 ena
     router ospf6 1 ena
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    interface tunnel1
     bandwidth 11
     tunnel source loopback0
     tunnel destination 9.9.9.9
     tunnel domain-name 2.2.2.1
     tunnel vrf v1
     tunnel mode p2mpte
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.0
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r1 tping 100 60 4321::3 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 60 4321::2 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r3 tping 100 60 4321::1 vrf v1 sou lo0
    r1 tping 100 60 3.3.3.3 vrf v1 sou lo0
    r3 tping 100 60 3.3.3.1 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-ospf10](../clab/intop1-ospf10/intop1-ospf10.yml) file  
        3. Launch ContainerLab `intop1-ospf10.yml` topology:  

        ```
           containerlab deploy --topo intop1-ospf10.yml  
        ```
        4. Destroy ContainerLab `intop1-ospf10.yml` topology:  

        ```
           containerlab destroy --topo intop1-ospf10.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-ospf10.tst` file [here](../tst/intop1-ospf10.tst)  
        3. Launch `intop1-ospf10.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-ospf10 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-ospf10.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

