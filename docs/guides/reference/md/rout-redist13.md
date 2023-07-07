# Example: redistribution filtering with routemap

=== "Topology"

    ![Alt text](../d2/rout-redist13/rout-redist13.svg)

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
    route-map p4
     sequence 10 act deny
      match network 2.2.2.8/29 le 32
     sequence 20 act perm
      match network 0.0.0.0/0 le 32
     exit
    route-map p6
     sequence 10 act deny
      match network 4321::10/124 le 128
     sequence 20 act perm
      match network ::/0 le 128
     exit
    router isis4 1
     vrf v1
     net 48.4444.1111.2222.00
     is-type level2
     red conn route-map p4
     red isis4 2 route-map p4
     exit
    router isis6 1
     vrf v1
     net 48.6666.1111.2222.00
     is-type level2
     red conn route-map p6
     red isis6 2 route-map p6
     exit
    router isis4 2
     vrf v1
     net 48.4444.2222.2222.00
     is-type level2
     red conn route-map p4
     red isis4 1 route-map p4
     exit
    router isis6 2
     vrf v1
     net 48.6666.2222.2222.00
     is-type level2
     red conn route-map p6
     red isis6 1 route-map p6
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
        2. Fetch [rout-redist13](../clab/rout-redist13/rout-redist13.yml) file  
        3. Launch ContainerLab `rout-redist13.yml` topology:  

        ```
           containerlab deploy --topo rout-redist13.yml  
        ```
        4. Destroy ContainerLab `rout-redist13.yml` topology:  

        ```
           containerlab destroy --topo rout-redist13.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-redist13.tst` file [here](../tst/rout-redist13.tst)  
        3. Launch `rout-redist13.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-redist13 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-redist13.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

