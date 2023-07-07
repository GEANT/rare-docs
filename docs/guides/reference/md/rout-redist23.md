# Example: redistribution with deaggr

=== "Topology"

    ![Alt text](../d2/rout-redist23/rout-redist23.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.1111.00
     is-type level2
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.1111.00
     is-type level2
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.11 255.255.255.255
     ipv6 addr 4321::11 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo3
     vrf for v1
     ipv4 addr 2.2.2.21 255.255.255.255
     ipv6 addr 4321::21 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     router isis4 1 ena
     exit
    int eth1.12
     vrf for v1
     ipv6 addr 1234:1::1 ffff:ffff::
     router isis6 1 ena
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.12 255.255.255.255
     ipv6 addr 4321::12 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo3
     vrf for v1
     ipv4 addr 2.2.2.22 255.255.255.255
     ipv6 addr 4321::22 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.2222.00
     is-type level2
     red deaggr4 1
     just lo1
     just lo2
     just lo3
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.2222.00
     is-type level2
     red deaggr6 1
     just lo1
     just lo2
     just lo3
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     router isis4 1 ena
     exit
    int eth1.12
     vrf for v1
     ipv6 addr 1234:1::2 ffff:ffff::
     router isis6 1 ena
     exit
    int eth2.11
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     exit
    int eth2.12
     vrf for v1
     ipv6 addr 1234:2::1 ffff:ffff::
     exit
    router deaggr4 1
     vrf v1
     just eth2.11
     exit
    router deaggr6 1
     vrf v1
     just eth2.12
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     exit
    int eth1.12
     vrf for v1
     ipv6 addr 1234:2::2 ffff:ffff::
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.5
    ipv6 route v1 :: :: 1234:2::1
    ```

=== "Verification"

    ```
    r1 tping 100 40 2.2.2.2 vrf v1
    r1 tping 100 40 2.2.2.12 vrf v1
    r1 tping 100 40 2.2.2.22 vrf v1
    r1 tping 100 40 4321::2 vrf v1
    r1 tping 100 40 4321::12 vrf v1
    r1 tping 100 40 4321::22 vrf v1
    r2 tping 100 40 2.2.2.1 vrf v1
    r2 tping 100 40 2.2.2.11 vrf v1
    r2 tping 100 40 2.2.2.21 vrf v1
    r2 tping 100 40 4321::1 vrf v1
    r2 tping 100 40 4321::11 vrf v1
    r2 tping 100 40 4321::21 vrf v1
    !r3 tping 100 40 2.2.2.1 vrf v1
    !r3 tping 100 40 2.2.2.11 vrf v1
    !r3 tping 100 40 2.2.2.21 vrf v1
    r3 tping 100 40 2.2.2.2 vrf v1
    r3 tping 100 40 2.2.2.12 vrf v1
    r3 tping 100 40 2.2.2.22 vrf v1
    !r3 tping 100 40 4321::1 vrf v1
    !r3 tping 100 40 4321::11 vrf v1
    !r3 tping 100 40 4321::21 vrf v1
    r3 tping 100 40 4321::2 vrf v1
    r3 tping 100 40 4321::12 vrf v1
    r3 tping 100 40 4321::22 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-redist23](../clab/rout-redist23/rout-redist23.yml) file  
        3. Launch ContainerLab `rout-redist23.yml` topology:  

        ```
           containerlab deploy --topo rout-redist23.yml  
        ```
        4. Destroy ContainerLab `rout-redist23.yml` topology:  

        ```
           containerlab destroy --topo rout-redist23.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-redist23.tst` file [here](../tst/rout-redist23.tst)  
        3. Launch `rout-redist23.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-redist23 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-redist23.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

