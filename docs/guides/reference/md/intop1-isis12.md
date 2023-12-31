# Example: interop1: isis php sr

=== "Topology"

    ![Alt text](../d2/intop1-isis12/intop1-isis12.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    access-list test4
     sequence 10 deny 1 any all any all
     sequence 20 permit all any all any all
     exit
    access-list test6
     sequence 10 deny all 4321:: ffff:: all 4321:: ffff:: all
     sequence 20 permit all any all any all
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.1111.00
     traffeng 2.2.2.1
     segrout 10
     both segrout
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.1111.00
     traffeng 6.6.6.1
     segrout 10
     both segrout
     red conn
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     router isis4 1 ena
     mpls enable
     ipv4 access-group-in test4
    ! ipv4 access-group-out test4
     exit
    int eth2
     vrf for v1
     ipv6 addr fe80::1 ffff::
     router isis6 1 ena
     mpls enable
     ipv6 access-group-in test6
     ipv6 access-group-out test6
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     router isis4 1 ena
     router isis4 1 segrout index 1
     router isis4 1 segrout node
     router isis4 1 segrout pop
     exit
    int lo2
     vrf for v1
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis6 1 ena
     router isis6 1 segrout index 2
     router isis6 1 segrout node
     router isis6 1 segrout pop
     exit
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.252
     pseudo v1 lo1 pweompls 2.2.2.3 1234
     exit
    ```

    **r2**

    ```
    hostname r2
    ip routing
    ipv6 unicast-routing
    mpls traffic-eng tunnels
    interface loopback0
     ip addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2/128
     exit
    segment-routing mpls
     set-attributes
      address-family ipv4
       explicit-null
     connected-prefix-sid-map
      address-family ipv4
       2.2.2.2/32 index 3
    router isis
     net 48.0000.0000.1234.00
     metric-style wide
     mpls traffic-eng router-id Loopback0
     mpls traffic-eng level-2
     redistribute connected
     is-type level-2-only
     segment-routing mpls
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
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    access-list test4
     sequence 10 deny 1 any all any all
     sequence 20 permit all any all any all
     exit
    access-list test6
     sequence 10 deny all 4321:: ffff:: all 4321:: ffff:: all
     sequence 20 permit all any all any all
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.3333.00
     traffeng 2.2.2.3
     segrout 10
     both segrout
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.3333.00
     traffeng 6.6.6.3
     segrout 10
     both segrout
     red conn
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     router isis4 1 ena
     mpls enable
     ipv4 access-group-in test4
    ! ipv4 access-group-out test4
     exit
    int eth2
     vrf for v1
     ipv6 addr fe80::1 ffff::
     router isis6 1 ena
     mpls enable
     ipv6 access-group-in test6
     ipv6 access-group-out test6
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     router isis4 1 ena
     router isis4 1 segrout index 5
     router isis4 1 segrout node
     router isis4 1 segrout pop
     exit
    int lo2
     vrf for v1
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis6 1 ena
     router isis6 1 segrout index 6
     router isis6 1 segrout node
     router isis6 1 segrout pop
     exit
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.252
     pseudo v1 lo1 pweompls 2.2.2.1 1234
     exit
    ```

=== "Verification"

    ```
    r1 tping 0 10 1.1.1.2 vrf v1
    r1 tping 0 60 2.2.2.2 vrf v1 sou lo1
    r1 tping 0 60 4321::2 vrf v1 sou lo2
    r3 tping 0 10 1.1.2.2 vrf v1
    r3 tping 0 60 2.2.2.2 vrf v1 sou lo1
    r3 tping 0 60 4321::2 vrf v1 sou lo2
    r1 tping 100 40 3.3.3.2 vrf v1
    r3 tping 100 40 3.3.3.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-isis12](../clab/intop1-isis12/intop1-isis12.yml) file  
        3. Launch ContainerLab `intop1-isis12.yml` topology:  

        ```
           containerlab deploy --topo intop1-isis12.yml  
        ```
        4. Destroy ContainerLab `intop1-isis12.yml` topology:  

        ```
           containerlab destroy --topo intop1-isis12.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-isis12.tst` file [here](../tst/intop1-isis12.tst)  
        3. Launch `intop1-isis12.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-isis12 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-isis12.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

