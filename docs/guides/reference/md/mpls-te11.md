# Example: pwe over te

=== "Topology"

    ![Alt text](../d2/mpls-te11/mpls-te11.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    int tun1
     tun sou eth1
     tun dest 1.1.1.2
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.252
     mpls enable
     mpls ldp4
     exit
    int tun2
     tun sou eth1
     tun dest 1234::2
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv6 addr 2345::1 ffff::
     mpls enable
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2345::2
    int tun3
     tun vrf v1
     tun sou lo0
     tun dest 2.2.2.2
     tun key 1234
     tun mod pweompls
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     ipv6 addr 3333::1 ffff::
     exit
    int tun4
     tun vrf v1
     tun sou lo0
     tun dest 4321::2
     tun key 4321
     tun mod pweompls
     vrf for v1
     ipv4 addr 4.4.4.1 255.255.255.0
     ipv6 addr 4444::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    int tun1
     tun sou eth1
     tun dest 1.1.1.1
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.252
     mpls enable
     mpls ldp4
     exit
    int tun2
     tun sou eth1
     tun dest 1234::1
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv6 addr 2345::2 ffff::
     mpls enable
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.2.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2345::1
    int tun3
     tun vrf v1
     tun sou lo0
     tun dest 2.2.2.1
     tun key 1234
     tun mod pweompls
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     ipv6 addr 3333::2 ffff::
     exit
    int tun4
     tun vrf v1
     tun sou lo0
     tun dest 4321::1
     tun key 4321
     tun mod pweompls
     vrf for v1
     ipv4 addr 4.4.4.2 255.255.255.0
     ipv6 addr 4444::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.2.2 vrf v1
    r2 tping 100 10 1.1.2.1 vrf v1
    r1 tping 100 10 2345::2 vrf v1
    r2 tping 100 10 2345::1 vrf v1
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r1 tping 100 10 4321::2 vrf v1 sou lo0
    r2 tping 100 10 4321::1 vrf v1 sou lo0
    r1 tping 100 10 3.3.3.2 vrf v1
    r1 tping 100 10 3333::2 vrf v1
    r2 tping 100 10 3.3.3.1 vrf v1
    r2 tping 100 10 3333::1 vrf v1
    r1 tping 100 10 4.4.4.2 vrf v1
    r1 tping 100 10 4444::2 vrf v1
    r2 tping 100 10 4.4.4.1 vrf v1
    r2 tping 100 10 4444::1 vrf v1
    r1 tping 0 10 1.1.1.2 vrf v1
    r2 tping 0 10 1.1.1.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-te11](../clab/mpls-te11/mpls-te11.yml) file  
        3. Launch ContainerLab `mpls-te11.yml` topology:  

        ```
           containerlab deploy --topo mpls-te11.yml  
        ```
        4. Destroy ContainerLab `mpls-te11.yml` topology:  

        ```
           containerlab destroy --topo mpls-te11.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-te11.tst` file [here](../tst/mpls-te11.tst)  
        3. Launch `mpls-te11.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-te11 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-te11.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

