# Example: interop9: isis p2mp te

=== "Topology"

    ![Alt text](../d2/intop9-isis06/intop9-isis06.svg)

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
     tun dest 9.9.9.9
     tun domain 2.2.2.2 2.2.2.3
     tun vrf v1
     tun mod p2mpte
     vrf for v1
     ipv4 addr 3.3.3.9 255.255.255.252
     exit
    ```

    **r2**

    ```
    hostname r2
    set interfaces ge-0/0/0.0 family inet address 1.1.1.2/24
    set interfaces ge-0/0/0.0 family iso
    set interfaces ge-0/0/0.0 family mpls
    set interfaces ge-0/0/1.0 family inet6
    set interfaces ge-0/0/1.0 family iso
    set interfaces ge-0/0/1.0 family mpls
    set interfaces ge-0/0/2.0 family inet address 1.1.2.2/24
    set interfaces ge-0/0/2.0 family iso
    set interfaces ge-0/0/2.0 family mpls
    set interfaces ge-0/0/3.0 family inet6
    set interfaces ge-0/0/3.0 family iso
    set interfaces ge-0/0/3.0 family mpls
    set interfaces lo0.0 family inet address 2.2.2.2/32
    set interfaces lo0.0 family inet6 address 4321::2/128
    set interfaces lo0.0 family iso address 48.0000.0000.1234.00
    set protocols rsvp interface lo0.0
    set protocols rsvp interface ge-0/0/0.0
    set protocols rsvp interface ge-0/0/1.0
    set protocols rsvp interface ge-0/0/2.0
    set protocols rsvp interface ge-0/0/3.0
    set protocols mpls interface ge-0/0/0.0
    set protocols mpls interface ge-0/0/1.0
    set protocols mpls interface ge-0/0/2.0
    set protocols mpls interface ge-0/0/3.0
    set protocols isis interface ge-0/0/0.0 point-to-point
    set protocols isis interface ge-0/0/1.0 point-to-point
    set protocols isis interface ge-0/0/2.0 point-to-point
    set protocols isis interface ge-0/0/3.0 point-to-point
    set protocols isis interface lo0.0
    set protocols isis traffic-engineering family inet shortcuts
    set protocols isis traffic-engineering family inet6 shortcuts
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
     tun dest 9.9.9.99
     tun domain 2.2.2.2 2.2.2.1
     tun vrf v1
     tun mod p2mpte
     vrf for v1
     ipv4 addr 3.3.3.10 255.255.255.252
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r3 tping 100 10 1.1.2.2 vrf v1
    r3 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 3.3.3.10 vrf v1
    r3 tping 100 60 3.3.3.9 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop9-isis06](../clab/intop9-isis06/intop9-isis06.yml) file  
        3. Launch ContainerLab `intop9-isis06.yml` topology:  

        ```
           containerlab deploy --topo intop9-isis06.yml  
        ```
        4. Destroy ContainerLab `intop9-isis06.yml` topology:  

        ```
           containerlab destroy --topo intop9-isis06.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop9-isis06.tst` file [here](../tst/intop9-isis06.tst)  
        3. Launch `intop9-isis06.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop9-isis06 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop9-isis06.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

