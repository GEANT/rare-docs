# Example: interop2: ospf sr

=== "Topology"

    ![Alt text](../d2/intop2-ospf11/intop2-ospf11.svg)

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
    router ospf4 1
     vrf v1
     router 4.4.4.1
     traffeng 2.2.2.1
     segrout 10
     area 0 ena
     area 0 segrout
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.1
     traffeng 6.6.6.1
     segrout 10
     area 0 ena
     area 0 segrout
     red conn
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr fe80::1 ffff::
     router ospf4 1 ena
     router ospf6 1 ena
     mpls enable
     ipv4 access-group-in test4
     ipv6 access-group-in test6
    ! ipv4 access-group-out test4
    ! ipv6 access-group-out test6
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     mpls enable
     router ospf4 1 ena
     router ospf4 1 segrout index 1
     router ospf4 1 segrout node
     router ospf6 1 ena
     router ospf6 1 segrout index 2
     router ospf6 1 segrout node
     exit
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.252
     pseudo v1 lo0 pweompls 2.2.2.3 1234
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
    router ospf 1
     redistribute connected
     mpls traffic-eng router-id Loopback0
     area 0
      segment-routing forwarding mpls
      mpls traffic-eng
      segment-routing mpls
      interface Loopback0
       passive enable
       prefix-sid index 3
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
    access-list test4
     sequence 10 deny 1 any all any all
     sequence 20 permit all any all any all
     exit
    access-list test6
     sequence 10 deny all 4321:: ffff:: all 4321:: ffff:: all
     sequence 20 permit all any all any all
     exit
    router ospf4 1
     vrf v1
     router 4.4.4.3
     traffeng 2.2.2.3
     segrout 10
     area 0 ena
     area 0 segrout
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.3
     traffeng 6.6.6.3
     segrout 10
     area 0 ena
     area 0 segrout
     red conn
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr fe80::1 ffff::
     router ospf4 1 ena
     router ospf6 1 ena
     mpls enable
     ipv4 access-group-in test4
     ipv6 access-group-in test6
    ! ipv4 access-group-out test4
    ! ipv6 access-group-out test6
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     mpls enable
     router ospf4 1 ena
     router ospf4 1 segrout index 5
     router ospf4 1 segrout node
     router ospf6 1 ena
     router ospf6 1 segrout index 6
     router ospf6 1 segrout node
     exit
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.252
     pseudo v1 lo0 pweompls 2.2.2.1 1234
     exit
    ```

=== "Verification"

    ```
    r1 tping 0 10 1.1.1.2 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 0 60 4321::2 vrf v1 sou lo0
    r3 tping 0 10 1.1.2.2 vrf v1
    r3 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r3 tping 0 60 4321::2 vrf v1 sou lo0
    r1 tping 100 40 3.3.3.2 vrf v1
    r3 tping 100 40 3.3.3.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop2-ospf11](../clab/intop2-ospf11/intop2-ospf11.yml) file  
        3. Launch ContainerLab `intop2-ospf11.yml` topology:  

        ```
           containerlab deploy --topo intop2-ospf11.yml  
        ```
        4. Destroy ContainerLab `intop2-ospf11.yml` topology:  

        ```
           containerlab destroy --topo intop2-ospf11.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop2-ospf11.tst` file [here](../tst/intop2-ospf11.tst)  
        3. Launch `intop2-ospf11.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop2-ospf11 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop2-ospf11.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

