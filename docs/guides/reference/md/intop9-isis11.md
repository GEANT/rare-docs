# Example: interop9: isis bier

=== "Topology"

    ![Alt text](../d2/intop9-isis11/intop9-isis11.svg)

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
     bier 256 10
     is-type level2
     both bier
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.1111.00
     traffeng 6.6.6.1
     bier 256 10
     is-type level2
     both bier
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
     router isis4 1 bier index 1
     exit
    int lo2
     vrf for v1
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis6 1 ena
     router isis6 1 bier index 2
     exit
    int tun1
     tun sou lo1
     tun dest 9.9.9.9
     tun doma 2.2.2.3
     tun vrf v1
     tun key 1
     tun mod bier
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.252
     exit
    int tun2
     tun sou lo2
     tun dest 9999::9
     tun doma 4321::3
     tun vrf v1
     tun key 1
     tun mod bier
     vrf for v1
     ipv4 addr 3.3.3.5 255.255.255.252
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
    set protocols isis traffic-engineering shortcuts
    set protocols isis bier-sub-domain 0
    set protocols bier sub-domain 0 bfr-id 3
    set protocols bier sub-domain 0 bfr-prefix 2.2.2.2
    set protocols bier sub-domain 0 encapsulation mpls
    set protocols bier sub-domain 0 encapsulation bitstringlen 256
    set protocols bier sub-domain 0 encapsulation number-sets 4
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
     bier 256 10
     is-type level2
     both bier
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.3333.00
     traffeng 6.6.6.3
     bier 256 10
     is-type level2
     both bier
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
     router isis4 1 bier index 5
     exit
    int lo2
     vrf for v1
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis6 1 ena
     router isis6 1 bier index 6
     exit
    int tun1
     tun sou lo1
     tun dest 9.9.9.9
     tun doma 2.2.2.1
     tun vrf v1
     tun key 3
     tun mod bier
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.252
     exit
    int tun2
     tun sou lo2
     tun dest 9999::9
     tun doma 4321::1
     tun vrf v1
     tun key 3
     tun mod bier
     vrf for v1
     ipv4 addr 3.3.3.6 255.255.255.252
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
        2. Fetch [intop9-isis11](../clab/intop9-isis11/intop9-isis11.yml) file  
        3. Launch ContainerLab `intop9-isis11.yml` topology:  

        ```
           containerlab deploy --topo intop9-isis11.yml  
        ```
        4. Destroy ContainerLab `intop9-isis11.yml` topology:  

        ```
           containerlab destroy --topo intop9-isis11.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop9-isis11.tst` file [here](../tst/intop9-isis11.tst)  
        3. Launch `intop9-isis11.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop9-isis11 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop9-isis11.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

