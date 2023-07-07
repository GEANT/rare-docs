# Example: static routing with interface tracker

=== "Topology"

    ![Alt text](../d2/rout-static14/rout-static14.svg)

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
     exit
    tracker t1
     targ eth2
     mod inter
     inter 1000
     time 500
     start
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.2 dist 22
    ipv6 route v1 :: :: 1234:1::2 dist 22
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.2.2 dist 11 track t1
    ipv6 route v1 :: :: 1234:2::2 dist 11 track t1
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
     exit
    tracker t1
     targ eth2
     mod inter
     inter 1000
     time 500
     start
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.1 dist 22
    ipv6 route v1 :: :: 1234:1::1 dist 22
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.2.1 dist 11 track t1
    ipv6 route v1 :: :: 1234:2::1 dist 11 track t1
    ```

=== "Verification"

    ```
    r2 tping 100 5 2.2.2.101 vrf v1
    r2 tping 100 5 4321::101 vrf v1
    r1 tping 100 5 2.2.2.201 vrf v1
    r1 tping 100 5 4321::201 vrf v1
    r1 send conf t
    r1 send int eth1
    r1 send no shut
    r1 send exit
    r1 send int eth2
    r1 send shut
    r1 send end
    r2 send conf t
    r2 send int eth2
    r2 send shut
    r2 send end
    r2 tping 100 5 2.2.2.101 vrf v1
    r2 tping 100 5 4321::101 vrf v1
    r1 tping 100 5 2.2.2.201 vrf v1
    r1 tping 100 5 4321::201 vrf v1
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-static14](../clab/rout-static14/rout-static14.yml) file  
        3. Launch ContainerLab `rout-static14.yml` topology:  

        ```
           containerlab deploy --topo rout-static14.yml  
        ```
        4. Destroy ContainerLab `rout-static14.yml` topology:  

        ```
           containerlab destroy --topo rout-static14.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-static14.tst` file [here](../tst/rout-static14.tst)  
        3. Launch `rout-static14.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-static14 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-static14.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

