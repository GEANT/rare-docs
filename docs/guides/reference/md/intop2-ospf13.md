# Example: interop2: ospf te with pcep

=== "Topology"

    ![Alt text](../d2/intop2-ospf13/intop2-ospf13.svg)

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
     tun dom 1.1.3.2 v1 lo0
     tun mod pcete
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.252
     exit
    int tun2
     bandwidth 11
     tun sou eth1
     tun dest 2.2.2.3
     tun vrf v1
     tun dom 1.1.3.2 v1 lo0
     tun mod pcete
     vrf for v1
     ipv4 addr 3.3.3.9 255.255.255.252
     exit
    ```

    **r2**

    ```
    hostname r2
    interface loopback0
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2/128
     exit
    interface gigabit0/0/0/0
     ipv4 address 1.1.1.2 255.255.255.0
     ipv6 enable
     no shutdown
     exit
    interface gigabit0/0/0/1
     ipv4 address 1.1.2.2 255.255.255.0
     ipv6 enable
     no shutdown
     exit
    interface tunnel-te1
     ipv4 address 3.3.3.2 255.255.255.252
     destination 2.2.2.1
     path-option 1 dynamic pce
     exit
    interface tunnel-te2
     ipv4 address 3.3.3.6 255.255.255.252
     destination 2.2.2.3
     path-option 1 dynamic pce
     exit
     interface gigabit0/0/0/0 bandwidth
     interface gigabit0/0/0/1 bandwidth
    mpls traffic-eng
     interface gigabit0/0/0/0
     interface gigabit0/0/0/1
     pce peer ipv4 1.1.3.2
    router ospf 1
     mpls traffic-eng router-id Loopback0
     redistribute connected
     area 0
      mpls traffic-eng
      interface gigabit0/0/0/0 network point-to-point
      interface gigabit0/0/0/1 network point-to-point
    router ospfv3 1
     redistribute connected
     area 0
      interface gigabit0/0/0/0 network point-to-point
      interface gigabit0/0/0/1 network point-to-point
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
     ipv6 addr fe80::1 ffff::
     router ospf4 1 ena
     router ospf6 1 ena
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    int ser1
     vrf for v1
     ipv4 addr 1.1.3.1 255.255.255.0
     ipv6 addr 4444::1 ffff::
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
     tun dom 1.1.3.2 v1 lo0
     tun mod pcete
     vrf for v1
     ipv4 addr 3.3.3.5 255.255.255.252
     exit
    int tun2
     bandwidth 11
     tun sou eth1
     tun dest 2.2.2.1
     tun vrf v1
     tun dom 1.1.3.2 v1 lo0
     tun mod pcete
     vrf for v1
     ipv4 addr 3.3.3.10 255.255.255.252
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    serv pcep p
     export-vrf v1
     vrf v1
     exit
    router ospf4 1
     vrf v1
     router 4.4.4.4
     traffeng 2.2.2.4
     area 0 ena
     area 0 traff
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.4
     traffeng 6.6.6.4
     area 0 ena
     area 0 traff
     red conn
     exit
    int ser1
     vrf for v1
     ipv4 addr 1.1.3.2 255.255.255.0
     ipv6 addr 4444::2 ffff::
     router ospf4 1 ena
     router ospf6 1 ena
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    ```

=== "Verification"

    ```
    r4 tping 100 60 2.2.2.3 vrf v1
    r4 tping 100 60 2.2.2.2 vrf v1
    r4 tping 100 60 2.2.2.1 vrf v1
    r4 tping 100 60 4321::3 vrf v1
    r4 tping 100 60 4321::2 vrf v1
    r4 tping 100 60 4321::1 vrf v1
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 3.3.3.2 vrf v1
    r3 tping 100 10 1.1.2.2 vrf v1
    r3 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 60 4321::2 vrf v1 sou lo0
    r3 tping 100 60 3.3.3.6 vrf v1
    r1 tping 100 60 3.3.3.10 vrf v1
    r3 tping 100 60 3.3.3.9 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop2-ospf13](../clab/intop2-ospf13/intop2-ospf13.yml) file  
        3. Launch ContainerLab `intop2-ospf13.yml` topology:  

        ```
           containerlab deploy --topo intop2-ospf13.yml  
        ```
        4. Destroy ContainerLab `intop2-ospf13.yml` topology:  

        ```
           containerlab destroy --topo intop2-ospf13.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop2-ospf13.tst` file [here](../tst/intop2-ospf13.tst)  
        3. Launch `intop2-ospf13.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop2-ospf13 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop2-ospf13.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

