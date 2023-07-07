# Example: te over ethernet

=== "Topology"

    ![Alt text](../d2/mpls-te01/mpls-te01.svg)

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
     ipv4 addr 2.2.2.1 255.255.255.252
     exit
    int tun2
     tun sou eth1
     tun dest 1234::2
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv6 addr 4321::1 ffff::
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
    ```

=== "Verification"

    ```
    r1 tping 100 10 2.2.2.2 vrf v1
    r2 tping 100 10 2.2.2.1 vrf v1
    r1 tping 100 10 4321::2 vrf v1
    r2 tping 100 10 4321::1 vrf v1
    r1 tping 0 10 1.1.1.2 vrf v1
    r2 tping 0 10 1.1.1.1 vrf v1
    r1 output show mpls forw
    r1 output show ipv4 rsvp v1 sum
    r1 output show ipv6 rsvp v1 sum
    output ../binTmp/mpls-te.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the lib:
    here is the ipv4 database:
    here is the ipv6 database:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-te01](../clab/mpls-te01/mpls-te01.yml) file  
        3. Launch ContainerLab `mpls-te01.yml` topology:  

        ```
           containerlab deploy --topo mpls-te01.yml  
        ```
        4. Destroy ContainerLab `mpls-te01.yml` topology:  

        ```
           containerlab destroy --topo mpls-te01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-te01.tst` file [here](../tst/mpls-te01.tst)  
        3. Launch `mpls-te01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-te01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-te01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

