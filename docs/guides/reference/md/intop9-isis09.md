# Example: interop9: isis php sr

=== "Topology"

    ![Alt text](../d2/intop9-isis09/intop9-isis09.svg)

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
     sequence 10 deny 58 4321:: ffff:: all 4321:: ffff:: all
     sequence 20 permit all any all any all
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.1111.00
     traffeng 2.2.2.1
     segrout 10
     is-type level2
     both segrout
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.1111.00
     traffeng 6.6.6.1
     segrout 10
     is-type level2
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
    ! ipv6 access-group-out test6
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
    int pweth2
     vrf for v1
     ipv4 addr 3.3.3.5 255.255.255.252
     pseudo v1 lo2 pweompls 4321::3 1234
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
    set protocols mpls interface ge-0/0/0.0
    set protocols mpls interface ge-0/0/1.0
    set protocols mpls interface ge-0/0/2.0
    set protocols mpls interface ge-0/0/3.0
    set protocols isis interface ge-0/0/0.0 point-to-point
    set protocols isis interface ge-0/0/1.0 point-to-point
    set protocols isis interface ge-0/0/2.0 point-to-point
    set protocols isis interface ge-0/0/3.0 point-to-point
    set protocols isis interface lo0.0
    set protocols isis source-packet-routing node-segment ipv4-index 3
    set protocols isis source-packet-routing node-segment ipv6-index 4
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
     sequence 10 deny 58 4321:: ffff:: all 4321:: ffff:: all
     sequence 20 permit all any all any all
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.3333.00
     traffeng 2.2.2.3
     segrout 10
     is-type level2
     both segrout
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.3333.00
     traffeng 6.6.6.3
     segrout 10
     is-type level2
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
    ! ipv6 access-group-out test6
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
    int pweth2
     vrf for v1
     ipv4 addr 3.3.3.6 255.255.255.252
     pseudo v1 lo2 pweompls 4321::1 1234
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 3.3.3.2 vrf v1
    r3 tping 100 60 3.3.3.1 vrf v1
    r1 tping 100 60 3.3.3.6 vrf v1
    r3 tping 100 60 3.3.3.5 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop9-isis09](../clab/intop9-isis09/intop9-isis09.yml) file  
        3. Launch ContainerLab `intop9-isis09.yml` topology:  

        ```
           containerlab deploy --topo intop9-isis09.yml  
        ```
        4. Destroy ContainerLab `intop9-isis09.yml` topology:  

        ```
           containerlab destroy --topo intop9-isis09.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop9-isis09.tst` file [here](../tst/intop9-isis09.tst)  
        3. Launch `intop9-isis09.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop9-isis09 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop9-isis09.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

