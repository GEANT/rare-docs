# Example: static routing with bfd tracker

=== "Topology"

    ![Alt text](../d2/rout-static05/rout-static05.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.101 255.255.255.255
     ipv6 addr 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     shut
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     ipv4 bfd 100 100 3
     ipv6 bfd 100 100 3
     exit
    server tel tel
     vrf v1
     exit
    tracker t1
     vrf v1
     targ 1.1.2.2
     mod bfd
     inter 1000
     time 500
     start
     exit
    tracker t2
     vrf v1
     targ 1234:2::2
     mod bfd
     inter 1000
     time 500
     start
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.2 dist 22
    ipv6 route v1 :: :: 1234:1::2 dist 22
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.2.2 dist 11 track t1
    ipv6 route v1 :: :: 1234:2::2 dist 11 track t2
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.201 255.255.255.255
     ipv6 addr 4321::201 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     ipv4 bfd 100 100 3
     ipv6 bfd 100 100 3
     exit
    server tel tel
     vrf v1
     exit
    tracker t1
     vrf v1
     targ 1.1.2.1
     mod bfd
     inter 1000
     time 500
     start
     exit
    tracker t2
     vrf v1
     targ 1234:2::1
     mod bfd
     inter 1000
     time 500
     start
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.1 dist 22
    ipv6 route v1 :: :: 1234:1::1 dist 22
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.2.1 dist 11 track t1
    ipv6 route v1 :: :: 1234:2::1 dist 11 track t2
    ```

=== "Verification"

    ```
    r2 tping 100 5 2.2.2.101 vrf v1
    r2 tping 100 5 4321::101 vrf v1
    r1 tping 100 5 2.2.2.201 vrf v1
    r1 tping 100 5 4321::201 vrf v1
    r2 output show tracker
    r2 output show ipv4 bfd v1 nei
    r2 output show ipv6 bfd v1 nei
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    r1 send conf t
    r1 send int eth1
    r1 send no shut
    r1 send exit
    r1 send int eth2
    r1 send shut
    r1 send end
    r2 tping 100 5 2.2.2.101 vrf v1
    r2 tping 100 5 4321::101 vrf v1
    r1 tping 100 5 2.2.2.201 vrf v1
    r1 tping 100 5 4321::201 vrf v1
    output ../binTmp/rout-bfd.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here are the trackers:
    here is the ipv4 neighbor:
    here is the ipv6 neighbor:
    here are the ipv4 routes:
    here are the ipv6 routes:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-static05](../clab/rout-static05/rout-static05.yml) file  
        3. Launch ContainerLab `rout-static05.yml` topology:  

        ```
           containerlab deploy --topo rout-static05.yml  
        ```
        4. Destroy ContainerLab `rout-static05.yml` topology:  

        ```
           containerlab destroy --topo rout-static05.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-static05.tst` file [here](../tst/rout-static05.tst)  
        3. Launch `rout-static05.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-static05 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-static05.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

