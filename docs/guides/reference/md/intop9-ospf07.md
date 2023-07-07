# Example: interop9: ospf te

=== "Topology"

    ![Alt text](../d2/intop9-ospf07/intop9-ospf07.svg)

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
    int tun1
     bandwidth 11
     tun sou eth1
     tun dest 2.2.2.2
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.252
     exit
    int tun2
     bandwidth 11
     tun sou eth1
     tun dest 2.2.2.3
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 3.3.3.9 255.255.255.252
     exit
    ```

    **r2**

    ```
    hostname r2
    set interfaces ge-0/0/0.0 family inet address 1.1.1.2/24
    set interfaces ge-0/0/0.0 family inet6
    set interfaces ge-0/0/0.0 family mpls
    set interfaces ge-0/0/1.0 family inet address 1.1.2.2/24
    set interfaces ge-0/0/1.0 family inet6
    set interfaces ge-0/0/1.0 family mpls
    set interfaces lo0.0 family inet address 2.2.2.2/32
    set interfaces lo0.0 family inet6 address 4321::2/128
    set interfaces lo0.0 family inet address 3.3.3.2/32
    set interfaces lo0.0 family inet address 3.3.3.6/32
    set protocols rsvp interface lo0.0
    set protocols rsvp interface ge-0/0/0.0
    set protocols rsvp interface ge-0/0/1.0
    set protocols mpls interface ge-0/0/0.0
    set protocols mpls interface ge-0/0/1.0
    set protocols ospf area 0 interface ge-0/0/0.0 interface-type p2p
    set protocols ospf area 0 interface ge-0/0/1.0 interface-type p2p
    set protocols ospf area 0 interface lo0.0
    set protocols ospf traffic-engineering shortcuts
    set protocols ospf3 area 0 interface ge-0/0/0.0 interface-type p2p
    set protocols ospf3 area 0 interface ge-0/0/1.0 interface-type p2p
    set protocols ospf3 area 0 interface lo0.0
    set protocols ospf3 traffic-engineering shortcuts
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
    int tun1
     bandwidth 11
     tun sou eth1
     tun dest 2.2.2.2
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 3.3.3.5 255.255.255.252
     exit
    int tun2
     bandwidth 11
     tun sou eth1
     tun dest 2.2.2.1
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 3.3.3.10 255.255.255.252
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 3.3.3.2 vrf v1 sou lo0
    r3 tping 100 10 1.1.2.2 vrf v1
    r3 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 60 4321::2 vrf v1 sou lo0
    r3 tping 100 60 3.3.3.6 vrf v1 sou lo0
    r1 tping 100 60 3.3.3.10 vrf v1
    r3 tping 100 60 3.3.3.9 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop9-ospf07](../clab/intop9-ospf07/intop9-ospf07.yml) file  
        3. Launch ContainerLab `intop9-ospf07.yml` topology:  

        ```
           containerlab deploy --topo intop9-ospf07.yml  
        ```
        4. Destroy ContainerLab `intop9-ospf07.yml` topology:  

        ```
           containerlab destroy --topo intop9-ospf07.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop9-ospf07.tst` file [here](../tst/intop9-ospf07.tst)  
        3. Launch `intop9-ospf07.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop9-ospf07 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop9-ospf07.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

