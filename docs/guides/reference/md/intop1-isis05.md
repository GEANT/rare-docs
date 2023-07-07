# Example: interop1: isis te

=== "Topology"

    ![Alt text](../d2/intop1-isis05/intop1-isis05.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.1111.00
     traffeng 2.2.2.1
     both traff
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.1111.00
     traffeng 6.6.6.1
     both traff
     red conn
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     router isis4 1 ena
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    int eth2
     vrf for v1
     ipv6 addr fe80::1 ffff::
     router isis6 1 ena
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
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
    ip routing
    ipv6 unicast-routing
    mpls traffic-eng tunnels
    no mpls traffic-eng signalling advertise implicit-null
    interface loopback0
     ip addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2/128
     exit
    router isis
     net 48.0000.0000.1234.00
     metric-style wide
     mpls traffic-eng router-id Loopback0
     mpls traffic-eng level-2
     redistribute connected
     address-family ipv6
      redistribute connected
     exit
    interface gigabit1
     ip address 1.1.1.2 255.255.255.0
     isis network point-to-point
     ip router isis
     ip rsvp bandwidth
     mpls traffic-eng tunnels
     no shutdown
     exit
    interface gigabit2
     ipv6 enable
     isis network point-to-point
     ipv6 router isis
     ip rsvp bandwidth
     mpls traffic-eng tunnels
     no shutdown
     exit
    interface gigabit3
     ip address 1.1.2.2 255.255.255.0
     isis network point-to-point
     ip router isis
     ip rsvp bandwidth
     mpls traffic-eng tunnels
     no shutdown
     exit
    interface gigabit4
     ipv6 enable
     isis network point-to-point
     ipv6 router isis
     ip rsvp bandwidth
     mpls traffic-eng tunnels
     no shutdown
     exit
    interface Tunnel1
     ip address 3.3.3.2 255.255.255.252
     tunnel mode mpls traffic-eng
     tunnel destination 2.2.2.1
     tunnel mpls traffic-eng path-option 1 dynamic
     exit
    interface Tunnel2
     ip address 3.3.3.6 255.255.255.252
     tunnel mode mpls traffic-eng
     tunnel destination 2.2.2.3
     tunnel mpls traffic-eng path-option 1 dynamic
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.3333.00
     traffeng 2.2.2.3
     both traff
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.3333.00
     traffeng 6.6.6.3
     both traff
     red conn
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     router isis4 1 ena
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    int eth2
     vrf for v1
     ipv6 addr fe80::1 ffff::
     router isis6 1 ena
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
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
        2. Fetch [intop1-isis05](../clab/intop1-isis05/intop1-isis05.yml) file  
        3. Launch ContainerLab `intop1-isis05.yml` topology:  

        ```
           containerlab deploy --topo intop1-isis05.yml  
        ```
        4. Destroy ContainerLab `intop1-isis05.yml` topology:  

        ```
           containerlab destroy --topo intop1-isis05.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-isis05.tst` file [here](../tst/intop1-isis05.tst)  
        3. Launch `intop1-isis05.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-isis05 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-isis05.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

