# Example: bgp over te

=== "Topology"

    ![Alt text](../d2/mpls-te20/mpls-te20.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    int lo1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.255
     ipv6 addr 3333::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
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
    ipv4 route v1 1.1.2.0 255.255.255.0 1.1.1.2
    ipv6 route v1 2345::0 ffff:: 1234::2
    int tun1
     tun sou eth1
     tun dest 1.1.2.2
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.252
     exit
    int tun2
     tun sou eth1
     tun dest 2345::2
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv6 addr 4321::1 ffff::
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.1
     neigh 2.2.2.2 remote-as 1
     red conn
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.1
     neigh 4321::2 remote-as 1
     red conn
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
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
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 2345::1 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    int lo1
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.255
     ipv6 addr 3333::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 2345::2 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    ipv4 route v1 1.1.1.0 255.255.255.0 1.1.2.1
    ipv6 route v1 1234::0 ffff:: 2345::1
    int tun1
     tun sou eth1
     tun dest 1.1.1.1
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.252
     exit
    int tun2
     tun sou eth1
     tun dest 1234::1
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv6 addr 4321::2 ffff::
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.3
     neigh 2.2.2.1 remote-as 1
     red conn
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.3
     neigh 4321::1 remote-as 1
     red conn
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 2.2.2.2 vrf v1
    r3 tping 100 10 2.2.2.1 vrf v1
    r1 tping 100 10 4321::2 vrf v1
    r3 tping 100 10 4321::1 vrf v1
    r1 tping 0 10 1.1.1.2 vrf v1
    r2 tping 0 10 1.1.1.1 vrf v1
    r2 tping 0 10 1.1.2.2 vrf v1
    r3 tping 0 10 1.1.2.1 vrf v1
    r1 tping 100 60 3.3.3.3 vrf v1 sou lo1
    r3 tping 100 60 3.3.3.1 vrf v1 sou lo1
    r1 tping 100 60 3333::3 vrf v1 sou lo1
    r3 tping 100 60 3333::1 vrf v1 sou lo1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-te20](../clab/mpls-te20/mpls-te20.yml) file  
        3. Launch ContainerLab `mpls-te20.yml` topology:  

        ```
           containerlab deploy --topo mpls-te20.yml  
        ```
        4. Destroy ContainerLab `mpls-te20.yml` topology:  

        ```
           containerlab destroy --topo mpls-te20.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-te20.tst` file [here](../tst/mpls-te20.tst)  
        3. Launch `mpls-te20.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-te20 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-te20.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

