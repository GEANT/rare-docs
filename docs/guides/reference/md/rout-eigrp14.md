# Example: eigrp with bfd

=== "Topology"

    ![Alt text](../d2/rout-eigrp14/rout-eigrp14.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router eigrp4 1
     vrf v1
     router 4.4.4.1
     as 1
     red conn
     exit
    router eigrp6 1
     vrf v1
     router 6.6.6.1
     as 1
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv4 bfd 100 100 3
     router eigrp4 1 ena
     router eigrp4 1 bfd
     ipv6 addr 1234:1::1 ffff:ffff::
     ipv6 bfd 100 100 3
     router eigrp6 1 ena
     router eigrp6 1 bfd
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv4 bfd 100 100 3
     router eigrp4 1 ena
     router eigrp4 1 bfd
     router eigrp4 1 delay-in 100
     ipv6 addr 1234:2::1 ffff:ffff::
     ipv6 bfd 100 100 3
     router eigrp6 1 ena
     router eigrp6 1 bfd
     router eigrp6 1 delay-in 100
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router eigrp4 1
     vrf v1
     router 4.4.4.2
     as 1
     red conn
     exit
    router eigrp6 1
     vrf v1
     router 6.6.6.2
     as 1
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv4 bfd 100 100 3
     router eigrp4 1 ena
     router eigrp4 1 bfd
     ipv6 addr 1234:1::2 ffff:ffff::
     ipv6 bfd 100 100 3
     router eigrp6 1 ena
     router eigrp6 1 bfd
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv4 bfd 100 100 3
     router eigrp4 1 ena
     router eigrp4 1 bfd
     router eigrp4 1 delay-in 100
     ipv6 addr 1234:2::2 ffff:ffff::
     ipv6 bfd 100 100 3
     router eigrp6 1 ena
     router eigrp6 1 bfd
     router eigrp6 1 delay-in 100
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 40 2.2.2.2 vrf v1
    r1 tping 100 40 4321::2 vrf v1
    r2 tping 100 40 2.2.2.1 vrf v1
    r2 tping 100 40 4321::1 vrf v1
    sleep 3000
    r1 tping 100 5 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 5 4321::2 vrf v1 sou lo0
    r2 tping 100 5 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 5 4321::1 vrf v1 sou lo0
    r2 send conf t
    r2 send int eth1
    r2 send shut
    r2 send end
    r1 tping 100 5 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 5 4321::2 vrf v1 sou lo0
    r2 tping 100 5 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 5 4321::1 vrf v1 sou lo0
    r2 output show ipv4 eigrp 1 sum
    r2 output show ipv6 eigrp 1 sum
    r2 output show ipv4 eigrp 1 rou
    r2 output show ipv6 eigrp 1 rou
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-eigrp14](../clab/rout-eigrp14/rout-eigrp14.yml) file  
        3. Launch ContainerLab `rout-eigrp14.yml` topology:  

        ```
           containerlab deploy --topo rout-eigrp14.yml  
        ```
        4. Destroy ContainerLab `rout-eigrp14.yml` topology:  

        ```
           containerlab destroy --topo rout-eigrp14.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-eigrp14.tst` file [here](../tst/rout-eigrp14.tst)  
        3. Launch `rout-eigrp14.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-eigrp14 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-eigrp14.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```
