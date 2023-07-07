# Example: eigrp ecmp connection

=== "Topology"

    ![Alt text](../d2/rout-eigrp23/rout-eigrp23.svg)

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
     ecmp
     exit
    router eigrp6 1
     vrf v1
     router 6.6.6.1
     as 1
     red conn
     ecmp
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    int eth1.22
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.252
     ipv6 addr 1234:21::1 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    int eth2.11
     vrf for v1
     ipv4 addr 1.1.1.10 255.255.255.252
     ipv6 addr 1234:3::2 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    int eth2.22
     vrf for v1
     ipv4 addr 1.1.2.10 255.255.255.252
     ipv6 addr 1234:23::2 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
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
     ecmp
     exit
    router eigrp6 1
     vrf v1
     router 6.6.6.2
     as 1
     red conn
     ecmp
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    int eth1.22
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.252
     ipv6 addr 1234:21::2 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    int eth2.11
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    int eth2.22
     vrf for v1
     ipv4 addr 1.1.2.5 255.255.255.252
     ipv6 addr 1234:22::1 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    router eigrp4 1
     vrf v1
     router 4.4.4.3
     as 1
     red conn
     ecmp
     exit
    router eigrp6 1
     vrf v1
     router 6.6.6.3
     as 1
     red conn
     ecmp
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    int eth1.22
     vrf for v1
     ipv4 addr 1.1.2.6 255.255.255.252
     ipv6 addr 1234:22::2 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    int eth2.11
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     ipv6 addr 1234:3::1 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    int eth2.22
     vrf for v1
     ipv4 addr 1.1.2.9 255.255.255.252
     ipv6 addr 1234:23::1 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 40 2.2.2.2 vrf v1 sou lo1
    r1 tping 100 40 2.2.2.3 vrf v1 sou lo1
    r1 tping 100 40 4321::2 vrf v1 sou lo1
    r1 tping 100 40 4321::3 vrf v1 sou lo1
    r2 tping 100 40 2.2.2.1 vrf v1 sou lo1
    r2 tping 100 40 2.2.2.3 vrf v1 sou lo1
    r2 tping 100 40 4321::1 vrf v1 sou lo1
    r2 tping 100 40 4321::3 vrf v1 sou lo1
    r3 tping 100 40 2.2.2.1 vrf v1 sou lo1
    r3 tping 100 40 2.2.2.2 vrf v1 sou lo1
    r3 tping 100 40 4321::1 vrf v1 sou lo1
    r3 tping 100 40 4321::2 vrf v1 sou lo1
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
        2. Fetch [rout-eigrp23](../clab/rout-eigrp23/rout-eigrp23.yml) file  
        3. Launch ContainerLab `rout-eigrp23.yml` topology:  

        ```
           containerlab deploy --topo rout-eigrp23.yml  
        ```
        4. Destroy ContainerLab `rout-eigrp23.yml` topology:  

        ```
           containerlab destroy --topo rout-eigrp23.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-eigrp23.tst` file [here](../tst/rout-eigrp23.tst)  
        3. Launch `rout-eigrp23.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-eigrp23 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-eigrp23.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

