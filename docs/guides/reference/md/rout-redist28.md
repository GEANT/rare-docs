# Example: redistribution filtering with hierarchical prefixlist

=== "Topology"

    ![Alt text](../d2/rout-redist28/rout-redist28.svg)

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
    prefix-list p4a
     sequence 10 permit 2.2.2.8/29 le 32
     exit
    prefix-list p6a
     sequence 10 permit 4321::10/124 le 128
     exit
    prefix-list p4b
     sequence 10 evaluate deny p4a
     sequence 20 permit 0.0.0.0/0 le 32
     exit
    prefix-list p6b
     sequence 10 evaluate deny p6a
     sequence 20 permit ::/0 le 128
     exit
    router isis4 1
     vrf v1
     net 48.4444.1111.2222.00
     is-type level2
     red conn prefix-list p4b
     red isis4 2 prefix-list p4b
     exit
    router isis6 1
     vrf v1
     net 48.6666.1111.2222.00
     is-type level2
     red conn prefix-list p6b
     red isis6 2 prefix-list p6b
     exit
    router isis4 2
     vrf v1
     net 48.4444.2222.2222.00
     is-type level2
     red conn prefix-list p4b
     red isis4 1 prefix-list p4b
     exit
    router isis6 2
     vrf v1
     net 48.6666.2222.2222.00
     is-type level2
     red conn prefix-list p6b
     red isis6 1 prefix-list p6b
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
     router isis4 2 ena
     exit
    int eth2.12
     vrf for v1
     ipv6 addr 1234:2::1 ffff:ffff::
     router isis6 2 ena
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
     net 48.4444.0000.3333.00
     is-type level2
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.3333.00
     is-type level2
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.13 255.255.255.255
     ipv6 addr 4321::13 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo3
     vrf for v1
     ipv4 addr 2.2.2.23 255.255.255.255
     ipv6 addr 4321::23 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
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
    ```

=== "Verification"

    ```
    r2 tping 100 20 2.2.2.1 vrf v1
    r2 tping 100 20 2.2.2.11 vrf v1
    r2 tping 100 20 2.2.2.21 vrf v1
    r2 tping 100 20 2.2.2.3 vrf v1
    r2 tping 100 20 2.2.2.13 vrf v1
    r2 tping 100 20 2.2.2.23 vrf v1
    r2 tping 100 20 4321::1 vrf v1
    r2 tping 100 20 4321::11 vrf v1
    r2 tping 100 20 4321::21 vrf v1
    r2 tping 100 20 4321::3 vrf v1
    r2 tping 100 20 4321::13 vrf v1
    r2 tping 100 20 4321::23 vrf v1
    r1 tping 100 20 2.2.2.2 vrf v1
    r1 tping 0 20 2.2.2.12 vrf v1
    r1 tping 100 20 2.2.2.22 vrf v1
    r1 tping 100 20 2.2.2.3 vrf v1
    r1 tping 0 20 2.2.2.13 vrf v1
    r1 tping 100 20 2.2.2.23 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r1 tping 0 20 4321::12 vrf v1
    r1 tping 100 20 4321::22 vrf v1
    r1 tping 100 20 4321::3 vrf v1
    r1 tping 0 20 4321::13 vrf v1
    r1 tping 100 20 4321::23 vrf v1
    r3 tping 100 20 2.2.2.1 vrf v1
    r3 tping 0 20 2.2.2.11 vrf v1
    r3 tping 100 20 2.2.2.21 vrf v1
    r3 tping 100 20 2.2.2.2 vrf v1
    r3 tping 0 20 2.2.2.12 vrf v1
    r3 tping 100 20 2.2.2.22 vrf v1
    r3 tping 100 20 4321::1 vrf v1
    r3 tping 0 20 4321::11 vrf v1
    r3 tping 100 20 4321::21 vrf v1
    r3 tping 100 20 4321::2 vrf v1
    r3 tping 0 20 4321::12 vrf v1
    r3 tping 100 20 4321::22 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-redist28](../clab/rout-redist28/rout-redist28.yml) file  
        3. Launch ContainerLab `rout-redist28.yml` topology:  

        ```
           containerlab deploy --topo rout-redist28.yml  
        ```
        4. Destroy ContainerLab `rout-redist28.yml` topology:  

        ```
           containerlab destroy --topo rout-redist28.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-redist28.tst` file [here](../tst/rout-redist28.tst)  
        3. Launch `rout-redist28.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-redist28 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-redist28.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

