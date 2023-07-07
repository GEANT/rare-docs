# Example: static routing with lpm

=== "Topology"

    ![Alt text](../d2/rout-static21/rout-static21.svg)

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
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     exit
    int eth3
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     ipv6 addr 1234:3::1 ffff:ffff::
     exit
    int eth4
     vrf for v1
     ipv4 addr 1.1.1.13 255.255.255.252
     ipv6 addr 1234:4::1 ffff:ffff::
     exit
    ipv4 route v1 2.2.2.102 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::102 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    ipv4 route v1 2.2.2.0 255.255.255.0 1.1.1.6
    ipv6 route v1 4321:: ffff:: 1234:2::2
    ipv4 route v1 2.2.0.0 255.255.0.0 1.1.1.10
    ipv6 route v1 4320:: fff0:: 1234:3::2
    ipv4 route v1 2.0.0.0 255.0.0.0 1.1.1.14
    ipv6 route v1 4300:: ff00:: 1234:4::2
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.102 255.255.255.255
     ipv6 addr 4321::102 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.1
    ipv6 route v1 :: :: 1234:1::1
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.103 255.255.255.255
     ipv6 addr 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.23 255.255.255.255
     ipv6 addr 4321::23 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.5
    ipv6 route v1 :: :: 1234:2::1
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.1.104 255.255.255.255
     ipv6 addr 4320::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.3.104 255.255.255.255
     ipv6 addr 4322::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.10 255.255.255.252
     ipv6 addr 1234:3::2 ffff:ffff::
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.9
    ipv6 route v1 :: :: 1234:3::1
    ```

    **r5**

    ```
    hostname r5
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.1.2.105 255.255.255.255
     ipv6 addr 4311::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.3.2.105 255.255.255.255
     ipv6 addr 4331::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.14 255.255.255.252
     ipv6 addr 1234:4::2 ffff:ffff::
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.13
    ipv6 route v1 :: :: 1234:4::1
    ```

=== "Verification"

    ```
    r1 tping 100 5 2.2.2.101 vrf v1 sou lo0
    r1 tping 100 5 4321::101 vrf v1 sou lo0
    r1 tping 100 5 2.2.2.102 vrf v1 sou lo0
    r1 tping 100 5 4321::102 vrf v1 sou lo0
    r1 tping 100 5 2.2.2.103 vrf v1 sou lo0
    r1 tping 100 5 4321::103 vrf v1 sou lo0
    r1 tping 100 5 2.2.2.23 vrf v1 sou lo0
    r1 tping 100 5 4321::23 vrf v1 sou lo0
    r1 tping 100 5 2.2.1.104 vrf v1 sou lo0
    r1 tping 100 5 4320::104 vrf v1 sou lo0
    r1 tping 100 5 2.2.3.104 vrf v1 sou lo0
    r1 tping 100 5 4322::104 vrf v1 sou lo0
    r1 tping 100 5 2.1.2.105 vrf v1 sou lo0
    r1 tping 100 5 4311::105 vrf v1 sou lo0
    r1 tping 100 5 2.3.2.105 vrf v1 sou lo0
    r1 tping 100 5 4331::105 vrf v1 sou lo0
    r2 tping 100 5 2.2.2.101 vrf v1 sou lo0
    r2 tping 100 5 4321::101 vrf v1 sou lo0
    r2 tping 100 5 2.2.2.102 vrf v1 sou lo0
    r2 tping 100 5 4321::102 vrf v1 sou lo0
    r2 tping 100 5 2.2.2.103 vrf v1 sou lo0
    r2 tping 100 5 4321::103 vrf v1 sou lo0
    r2 tping 100 5 2.2.2.23 vrf v1 sou lo0
    r2 tping 100 5 4321::23 vrf v1 sou lo0
    r2 tping 100 5 2.2.1.104 vrf v1 sou lo0
    r2 tping 100 5 4320::104 vrf v1 sou lo0
    r2 tping 100 5 2.2.3.104 vrf v1 sou lo0
    r2 tping 100 5 4322::104 vrf v1 sou lo0
    r2 tping 100 5 2.1.2.105 vrf v1 sou lo0
    r2 tping 100 5 4311::105 vrf v1 sou lo0
    r2 tping 100 5 2.3.2.105 vrf v1 sou lo0
    r2 tping 100 5 4331::105 vrf v1 sou lo0
    r3 tping 100 5 2.2.2.101 vrf v1 sou lo0
    r3 tping 100 5 4321::101 vrf v1 sou lo0
    r3 tping 100 5 2.2.2.102 vrf v1 sou lo0
    r3 tping 100 5 4321::102 vrf v1 sou lo0
    r3 tping 100 5 2.2.2.103 vrf v1 sou lo0
    r3 tping 100 5 4321::103 vrf v1 sou lo0
    r3 tping 100 5 2.2.2.23 vrf v1 sou lo0
    r3 tping 100 5 4321::23 vrf v1 sou lo0
    r3 tping 100 5 2.2.1.104 vrf v1 sou lo0
    r3 tping 100 5 4320::104 vrf v1 sou lo0
    r3 tping 100 5 2.2.3.104 vrf v1 sou lo0
    r3 tping 100 5 4322::104 vrf v1 sou lo0
    r3 tping 100 5 2.1.2.105 vrf v1 sou lo0
    r3 tping 100 5 4311::105 vrf v1 sou lo0
    r3 tping 100 5 2.3.2.105 vrf v1 sou lo0
    r3 tping 100 5 4331::105 vrf v1 sou lo0
    r4 tping 100 5 2.2.2.101 vrf v1 sou lo0
    r4 tping 100 5 4321::101 vrf v1 sou lo0
    r4 tping 100 5 2.2.2.102 vrf v1 sou lo0
    r4 tping 100 5 4321::102 vrf v1 sou lo0
    r4 tping 100 5 2.2.2.103 vrf v1 sou lo0
    r4 tping 100 5 4321::103 vrf v1 sou lo0
    r4 tping 100 5 2.2.2.23 vrf v1 sou lo0
    r4 tping 100 5 4321::23 vrf v1 sou lo0
    r4 tping 100 5 2.2.1.104 vrf v1 sou lo0
    r4 tping 100 5 4320::104 vrf v1 sou lo0
    r4 tping 100 5 2.2.3.104 vrf v1 sou lo0
    r4 tping 100 5 4322::104 vrf v1 sou lo0
    r4 tping 100 5 2.1.2.105 vrf v1 sou lo0
    r4 tping 100 5 4311::105 vrf v1 sou lo0
    r4 tping 100 5 2.3.2.105 vrf v1 sou lo0
    r4 tping 100 5 4331::105 vrf v1 sou lo0
    r5 tping 100 5 2.2.2.101 vrf v1 sou lo0
    r5 tping 100 5 4321::101 vrf v1 sou lo0
    r5 tping 100 5 2.2.2.102 vrf v1 sou lo0
    r5 tping 100 5 4321::102 vrf v1 sou lo0
    r5 tping 100 5 2.2.2.103 vrf v1 sou lo0
    r5 tping 100 5 4321::103 vrf v1 sou lo0
    r5 tping 100 5 2.2.2.23 vrf v1 sou lo0
    r5 tping 100 5 4321::23 vrf v1 sou lo0
    r5 tping 100 5 2.2.1.104 vrf v1 sou lo0
    r5 tping 100 5 4320::104 vrf v1 sou lo0
    r5 tping 100 5 2.2.3.104 vrf v1 sou lo0
    r5 tping 100 5 4322::104 vrf v1 sou lo0
    r5 tping 100 5 2.1.2.105 vrf v1 sou lo0
    r5 tping 100 5 4311::105 vrf v1 sou lo0
    r5 tping 100 5 2.3.2.105 vrf v1 sou lo0
    r5 tping 100 5 4331::105 vrf v1 sou lo0
    r3 tping 100 5 2.2.2.101 vrf v1 sou lo1
    r3 tping 100 5 4321::101 vrf v1 sou lo1
    r3 tping 100 5 2.2.2.102 vrf v1 sou lo1
    r3 tping 100 5 4321::102 vrf v1 sou lo1
    r3 tping 100 5 2.2.2.103 vrf v1 sou lo1
    r3 tping 100 5 4321::103 vrf v1 sou lo1
    r3 tping 100 5 2.2.2.23 vrf v1 sou lo1
    r3 tping 100 5 4321::23 vrf v1 sou lo1
    r3 tping 100 5 2.2.1.104 vrf v1 sou lo1
    r3 tping 100 5 4320::104 vrf v1 sou lo1
    r3 tping 100 5 2.2.3.104 vrf v1 sou lo1
    r3 tping 100 5 4322::104 vrf v1 sou lo1
    r3 tping 100 5 2.1.2.105 vrf v1 sou lo1
    r3 tping 100 5 4311::105 vrf v1 sou lo1
    r3 tping 100 5 2.3.2.105 vrf v1 sou lo1
    r3 tping 100 5 4331::105 vrf v1 sou lo1
    r4 tping 100 5 2.2.2.101 vrf v1 sou lo1
    r4 tping 100 5 4321::101 vrf v1 sou lo1
    r4 tping 100 5 2.2.2.102 vrf v1 sou lo1
    r4 tping 100 5 4321::102 vrf v1 sou lo1
    r4 tping 100 5 2.2.2.103 vrf v1 sou lo1
    r4 tping 100 5 4321::103 vrf v1 sou lo1
    r4 tping 100 5 2.2.2.23 vrf v1 sou lo1
    r4 tping 100 5 4321::23 vrf v1 sou lo1
    r4 tping 100 5 2.2.1.104 vrf v1 sou lo1
    r4 tping 100 5 4320::104 vrf v1 sou lo1
    r4 tping 100 5 2.2.3.104 vrf v1 sou lo1
    r4 tping 100 5 4322::104 vrf v1 sou lo1
    r4 tping 100 5 2.1.2.105 vrf v1 sou lo1
    r4 tping 100 5 4311::105 vrf v1 sou lo1
    r4 tping 100 5 2.3.2.105 vrf v1 sou lo1
    r4 tping 100 5 4331::105 vrf v1 sou lo1
    r5 tping 100 5 2.2.2.101 vrf v1 sou lo1
    r5 tping 100 5 4321::101 vrf v1 sou lo1
    r5 tping 100 5 2.2.2.102 vrf v1 sou lo1
    r5 tping 100 5 4321::102 vrf v1 sou lo1
    r5 tping 100 5 2.2.2.103 vrf v1 sou lo1
    r5 tping 100 5 4321::103 vrf v1 sou lo1
    r5 tping 100 5 2.2.2.23 vrf v1 sou lo1
    r5 tping 100 5 4321::23 vrf v1 sou lo1
    r5 tping 100 5 2.2.1.104 vrf v1 sou lo1
    r5 tping 100 5 4320::104 vrf v1 sou lo1
    r5 tping 100 5 2.2.3.104 vrf v1 sou lo1
    r5 tping 100 5 4322::104 vrf v1 sou lo1
    r5 tping 100 5 2.1.2.105 vrf v1 sou lo1
    r5 tping 100 5 4311::105 vrf v1 sou lo1
    r5 tping 100 5 2.3.2.105 vrf v1 sou lo1
    r5 tping 100 5 4331::105 vrf v1 sou lo1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-static21](../clab/rout-static21/rout-static21.yml) file  
        3. Launch ContainerLab `rout-static21.yml` topology:  

        ```
           containerlab deploy --topo rout-static21.yml  
        ```
        4. Destroy ContainerLab `rout-static21.yml` topology:  

        ```
           containerlab destroy --topo rout-static21.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-static21.tst` file [here](../tst/rout-static21.tst)  
        3. Launch `rout-static21.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-static21 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-static21.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

