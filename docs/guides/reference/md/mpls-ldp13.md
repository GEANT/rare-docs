# Example: p2mp ldp tunnel

=== "Topology"

    ![Alt text](../d2/mpls-ldp13/mpls-ldp13.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.2
    ipv6 route v1 :: :: 1234:1::2
    int tun1
     tun sou lo0
     tun dest 2.2.2.1
     tun vrf v1
     tun key 1234
     tun mod p2mpldp
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     exit
    int tun2
     tun sou lo0
     tun dest 4321::1
     tun vrf v1
     tun key 1234
     tun mod p2mpldp
     vrf for v1
     ipv6 addr 3333::1 ffff:ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234:1::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1234:2::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int eth3
     vrf for v1
     ipv4 addr 1.1.3.1 255.255.255.0
     ipv6 addr 1234:3::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.2.2
    ipv4 route v1 2.2.2.4 255.255.255.255 1.1.3.2
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    ipv6 route v1 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::2
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.2.1
    ipv6 route v1 :: :: 1234:2::1
    int tun1
     tun sou lo0
     tun dest 2.2.2.1
     tun vrf v1
     tun key 1234
     tun mod p2mpldp
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.0
     exit
    int tun2
     tun sou lo0
     tun dest 4321::1
     tun vrf v1
     tun key 1234
     tun mod p2mpldp
     vrf for v1
     ipv6 addr 3333::3 ffff:ffff::
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.3.2 255.255.255.0
     ipv6 addr 1234:3::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.3.1
    ipv6 route v1 :: :: 1234:3::1
    int tun1
     tun sou lo0
     tun dest 2.2.2.1
     tun vrf v1
     tun key 1234
     tun mod p2mpldp
     vrf for v1
     ipv4 addr 3.3.3.4 255.255.255.0
     exit
    int tun2
     tun sou lo0
     tun dest 4321::1
     tun vrf v1
     tun key 1234
     tun mod p2mpldp
     vrf for v1
     ipv6 addr 3333::4 ffff:ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.3 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.4 vrf v1 sou lo0
    r1 tping 100 10 4321::2 vrf v1 sou lo0
    r1 tping 100 10 4321::3 vrf v1 sou lo0
    r1 tping 100 10 4321::4 vrf v1 sou lo0
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 10 2.2.2.3 vrf v1 sou lo0
    r2 tping 100 10 2.2.2.4 vrf v1 sou lo0
    r2 tping 100 10 4321::1 vrf v1 sou lo0
    r2 tping 100 10 4321::3 vrf v1 sou lo0
    r2 tping 100 10 4321::4 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.4 vrf v1 sou lo0
    r3 tping 100 10 4321::1 vrf v1 sou lo0
    r3 tping 100 10 4321::2 vrf v1 sou lo0
    r3 tping 100 10 4321::4 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.3 vrf v1 sou lo0
    r4 tping 100 10 4321::1 vrf v1 sou lo0
    r4 tping 100 10 4321::2 vrf v1 sou lo0
    r4 tping 100 10 4321::3 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.1 vrf v1 sou tun1
    r3 tping 100 10 4321::1 vrf v1 sou tun2
    r4 tping 100 10 2.2.2.1 vrf v1 sou tun1
    r4 tping 100 10 4321::1 vrf v1 sou tun2
    r3 output show mpls forw
    r3 output show ipv4 ldp v1 sum
    r3 output show ipv6 ldp v1 sum
    r3 output show ipv4 ldp v1 mpdat
    r3 output show ipv6 ldp v1 mpdat
    r3 output show inter tun1 full
    r3 output show inter tun2 full
    output ../binTmp/mpls-ldp-p2mp.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the lib:
    here is the ipv4 neighbor:
    here is the ipv6 neighbor:
    here is the ipv4 database:
    here is the ipv6 database:
    here is the ipv4 interface:
    here is the ipv6 interface:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-ldp13](../clab/mpls-ldp13/mpls-ldp13.yml) file  
        3. Launch ContainerLab `mpls-ldp13.yml` topology:  

        ```
           containerlab deploy --topo mpls-ldp13.yml  
        ```
        4. Destroy ContainerLab `mpls-ldp13.yml` topology:  

        ```
           containerlab destroy --topo mpls-ldp13.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-ldp13.tst` file [here](../tst/mpls-ldp13.tst)  
        3. Launch `mpls-ldp13.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-ldp13 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-ldp13.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

