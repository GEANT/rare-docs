# Example: isis updown bit with narrow metric

=== "Topology"

    ![Alt text](../d2/rout-isis015/rout-isis015.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router isis4 1
     vrf v1
     net 11.4444.0000.1111.00
     is-type level1
     no metric-wide
     red conn
     exit
    router isis6 1
     vrf v1
     net 11.6666.0000.1111.00
     is-type level1
     no metric-wide
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
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
    router isis4 1
     vrf v1
     net 11.4444.0000.2222.00
     is-type both
     no metric-wide
     red conn
     exit
    router isis6 1
     vrf v1
     net 11.6666.0000.2222.00
     is-type both
     no metric-wide
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
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
     router isis4 1 ena
     exit
    int eth2.12
     vrf for v1
     ipv6 addr 1234:2::1 ffff:ffff::
     router isis6 1 ena
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    router isis4 1
     vrf v1
     net 22.4444.0000.3333.00
     is-type both
     no metric-wide
     red conn
     exit
    router isis6 1
     vrf v1
     net 22.6666.0000.3333.00
     is-type both
     no metric-wide
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     router isis4 1 ena
     exit
    int eth1.12
     vrf for v1
     ipv6 addr 1234:2::2 ffff:ffff::
     router isis6 1 ena
     exit
    int eth2.11
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     router isis4 1 ena
     exit
    int eth2.12
     vrf for v1
     ipv6 addr 1234:3::1 ffff:ffff::
     router isis6 1 ena
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    router isis4 1
     vrf v1
     net 22.4444.0000.4444.00
     is-type level1
     no metric-wide
     red conn
     exit
    router isis6 1
     vrf v1
     net 22.6666.0000.4444.00
     is-type level1
     no metric-wide
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.10 255.255.255.252
     router isis4 1 ena
     exit
    int eth1.12
     vrf for v1
     ipv6 addr 1234:3::2 ffff:ffff::
     router isis6 1 ena
     exit
    int eth2.11
     vrf for v1
     ipv4 addr 1.1.1.13 255.255.255.252
     router isis4 1 ena
     exit
    int eth2.12
     vrf for v1
     ipv6 addr 1234:4::1 ffff:ffff::
     router isis6 1 ena
     exit
    ```

    **r5**

    ```
    hostname r5
    vrf def v1
     rd 1:1
     exit
    router isis4 1
     vrf v1
     net 22.4444.0000.5555.00
     is-type both
     no metric-wide
     red conn
     exit
    router isis6 1
     vrf v1
     net 22.6666.0000.5555.00
     is-type both
     no metric-wide
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.5 255.255.255.255
     ipv6 addr 4321::5 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.14 255.255.255.252
     router isis4 1 ena
     exit
    int eth1.12
     vrf for v1
     ipv6 addr 1234:4::2 ffff:ffff::
     router isis6 1 ena
     exit
    int eth2.11
     vrf for v1
     ipv4 addr 1.1.1.17 255.255.255.252
     router isis4 1 ena
     exit
    int eth2.12
     vrf for v1
     ipv6 addr 1234:5::1 ffff:ffff::
     router isis6 1 ena
     exit
    ```

    **r6**

    ```
    hostname r6
    vrf def v1
     rd 1:1
     exit
    router isis4 1
     vrf v1
     net 33.4444.0000.6666.00
     is-type level2
     no metric-wide
     red conn
     exit
    router isis6 1
     vrf v1
     net 33.6666.0000.6666.00
     is-type level2
     no metric-wide
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.6 255.255.255.255
     ipv6 addr 4321::6 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.18 255.255.255.252
     router isis4 1 ena
     exit
    int eth1.12
     vrf for v1
     ipv6 addr 1234:5::2 ffff:ffff::
     router isis6 1 ena
     exit
    ```

=== "Verification"

    ```
    r5 tping 100 20 2.2.2.1 vrf v1
    r5 tping 100 20 2.2.2.2 vrf v1
    r5 tping 100 20 2.2.2.3 vrf v1
    r5 tping 100 20 2.2.2.4 vrf v1
    r5 tping 100 20 2.2.2.6 vrf v1
    r5 tping 100 20 4321::1 vrf v1
    r5 tping 100 20 4321::2 vrf v1
    r5 tping 100 20 4321::3 vrf v1
    r5 tping 100 20 4321::4 vrf v1
    r5 tping 100 20 4321::6 vrf v1
    r6 tping 0 20 2.2.2.1 vrf v1
    r6 tping 0 20 2.2.2.2 vrf v1
    r6 tping 100 20 2.2.2.3 vrf v1
    r6 tping 100 20 2.2.2.4 vrf v1
    r6 tping 100 20 2.2.2.5 vrf v1
    r6 tping 0 20 4321::1 vrf v1
    r6 tping 0 20 4321::2 vrf v1
    r6 tping 100 20 4321::3 vrf v1
    r6 tping 100 20 4321::4 vrf v1
    r6 tping 100 20 4321::5 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r2 tping 100 20 2.2.2.3 vrf v1
    r2 tping 100 20 2.2.2.4 vrf v1
    r2 tping 100 20 2.2.2.5 vrf v1
    r2 tping 0 20 2.2.2.6 vrf v1
    r2 tping 100 20 4321::1 vrf v1
    r2 tping 100 20 4321::3 vrf v1
    r2 tping 100 20 4321::4 vrf v1
    r2 tping 100 20 4321::5 vrf v1
    r2 tping 0 20 4321::6 vrf v1
    r1 tping 100 20 2.2.2.2 vrf v1
    r1 tping 100 20 2.2.2.3 vrf v1
    r1 tping 100 20 2.2.2.4 vrf v1
    r1 tping 100 20 2.2.2.5 vrf v1
    r1 tping 0 20 2.2.2.6 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r1 tping 100 20 4321::3 vrf v1
    r1 tping 100 20 4321::4 vrf v1
    r1 tping 100 20 4321::5 vrf v1
    r1 tping 0 20 4321::6 vrf v1
    r4 tping 100 20 2.2.2.1 vrf v1
    r4 tping 100 20 2.2.2.2 vrf v1
    r4 tping 100 20 2.2.2.3 vrf v1
    r4 tping 100 20 2.2.2.5 vrf v1
    r4 tping 100 20 2.2.2.6 vrf v1
    r4 tping 100 20 4321::1 vrf v1
    r4 tping 100 20 4321::2 vrf v1
    r4 tping 100 20 4321::3 vrf v1
    r4 tping 100 20 4321::5 vrf v1
    r4 tping 100 20 4321::6 vrf v1
    r3 tping 100 20 2.2.2.1 vrf v1
    r3 tping 100 20 2.2.2.2 vrf v1
    r3 tping 100 20 2.2.2.4 vrf v1
    r3 tping 100 20 2.2.2.5 vrf v1
    r3 tping 100 20 2.2.2.6 vrf v1
    r3 tping 100 20 4321::1 vrf v1
    r3 tping 100 20 4321::2 vrf v1
    r3 tping 100 20 4321::4 vrf v1
    r3 tping 100 20 4321::5 vrf v1
    r3 tping 100 20 4321::6 vrf v1
    r2 output show ipv4 isis 1 nei
    r2 output show ipv6 isis 1 nei
    r2 output show ipv4 isis 1 dat 2
    r2 output show ipv6 isis 1 dat 2
    r2 output show ipv4 isis 1 tre 2
    r2 output show ipv6 isis 1 tre 2
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-isis015](../clab/rout-isis015/rout-isis015.yml) file  
        3. Launch ContainerLab `rout-isis015.yml` topology:  

        ```
           containerlab deploy --topo rout-isis015.yml  
        ```
        4. Destroy ContainerLab `rout-isis015.yml` topology:  

        ```
           containerlab destroy --topo rout-isis015.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-isis015.tst` file [here](../tst/rout-isis015.tst)  
        3. Launch `rout-isis015.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-isis015 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-isis015.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

