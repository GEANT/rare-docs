# Example: multicast routing with igmp/mld

=== "Topology"

    ![Alt text](../d2/rout-mcast03/rout-mcast03.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     ipv4 multi host-ena
     ipv4 multi host-pro
     ipv6 multi host-ena
     ipv6 multi host-pro
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.2
    ipv6 route v1 :: :: 1234:1::2
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     ipv4 multi host-ena
     ipv4 multi host-pro
     ipv6 multi host-ena
     ipv6 multi host-pro
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     ipv4 multi host-ena
     ipv4 multi host-pro
     ipv6 multi host-ena
     ipv6 multi host-pro
     exit
    int eth3
     vrf for v1
     ipv4 addr 1.1.1.10 255.255.255.252
     ipv6 addr 1234:3::2 ffff:ffff::
     ipv4 multi host-ena
     ipv4 multi host-pro
     ipv6 multi host-ena
     ipv6 multi host-pro
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     ipv4 multi host-ena
     ipv4 multi host-pro
     ipv6 multi host-ena
     ipv6 multi host-pro
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.6
    ipv6 route v1 :: :: 1234:2::2
    ipv4 mroute v1 0.0.0.0 0.0.0.0 1.1.1.6
    ipv6 mroute v1 :: :: 1234:2::2
    ipv4 multi v1 join 232.2.2.2 1.1.1.1
    ipv6 multi v1 join ff06::1 1234:1::1
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     ipv6 addr 1234:3::1 ffff:ffff::
     ipv4 multi host-ena
     ipv4 multi host-pro
     ipv6 multi host-ena
     ipv6 multi host-pro
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.10
    ipv6 route v1 :: :: 1234:3::2
    ipv4 mroute v1 0.0.0.0 0.0.0.0 1.1.1.10
    ipv6 mroute v1 :: :: 1234:3::2
    ipv4 multi v1 join 232.2.2.2 1.1.1.1
    ipv6 multi v1 join ff06::1 1234:1::1
    ```

=== "Verification"

    ```
    r2 tping 100 5 1.1.1.9 vrf v1
    r2 tping 100 5 1.1.1.5 vrf v1
    r2 tping 100 5 1.1.1.1 vrf v1
    r2 tping 100 5 1234:3::1 vrf v1
    r2 tping 100 5 1234:2::1 vrf v1
    r2 tping 100 5 1234:1::1 vrf v1
    r1 tping 100 5 1.1.1.9 vrf v1
    r1 tping 100 5 1.1.1.5 vrf v1
    r1 tping 100 5 1234:3::1 vrf v1
    r1 tping 100 5 1234:2::1 vrf v1
    r3 tping 100 5 1.1.1.1 vrf v1
    r3 tping 100 5 1234:1::1 vrf v1
    r4 tping 100 5 1.1.1.1 vrf v1
    r4 tping 100 5 1234:1::1 vrf v1
    r1 tping 200 5 232.2.2.2 vrf v1 sou eth1 multi
    r1 tping 200 5 ff06::1 vrf v1 sou eth1 multi
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-mcast03](../clab/rout-mcast03/rout-mcast03.yml) file  
        3. Launch ContainerLab `rout-mcast03.yml` topology:  

        ```
           containerlab deploy --topo rout-mcast03.yml  
        ```
        4. Destroy ContainerLab `rout-mcast03.yml` topology:  

        ```
           containerlab destroy --topo rout-mcast03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-mcast03.tst` file [here](../tst/rout-mcast03.tst)  
        3. Launch `rout-mcast03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-mcast03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-mcast03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

