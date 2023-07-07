# Example: isis inter level egress filtering with routemap

=== "Topology"

    ![Alt text](../d2/rout-isis026/rout-isis026.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router isis4 1
     vrf v1
     net 22.4444.0000.1111.00
     is-type level2
     red conn
     exit
    router isis6 1
     vrf v1
     net 22.6666.0000.1111.00
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
     net 22.4444.0000.2222.00
     is-type both
     red conn
     both route-map-into p4
     exit
    router isis6 1
     vrf v1
     net 22.6666.0000.2222.00
     is-type both
     red conn
     both route-map-into p6
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
     is-type level1
     red conn
     exit
    router isis6 1
     vrf v1
     net 22.6666.0000.3333.00
     is-type level1
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
    r1 tping 100 20 2.2.2.2 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r1 tping 100 20 2.2.2.3 vrf v1
    r1 tping 100 20 4321::3 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r2 tping 100 20 4321::1 vrf v1
    r2 tping 100 20 2.2.2.3 vrf v1
    r2 tping 100 20 4321::3 vrf v1
    r3 tping 100 20 2.2.2.1 vrf v1
    r3 tping 100 20 4321::1 vrf v1
    r3 tping 100 20 2.2.2.2 vrf v1
    r3 tping 100 20 4321::2 vrf v1
    r1 tping 0 20 2.2.2.12 vrf v1
    r1 tping 0 20 4321::12 vrf v1
    r1 tping 0 20 2.2.2.13 vrf v1
    r1 tping 0 20 4321::13 vrf v1
    r2 tping 100 20 2.2.2.11 vrf v1
    r2 tping 100 20 4321::11 vrf v1
    r2 tping 100 20 2.2.2.13 vrf v1
    r2 tping 100 20 4321::13 vrf v1
    r3 tping 0 20 2.2.2.11 vrf v1
    r3 tping 0 20 4321::11 vrf v1
    r3 tping 0 20 2.2.2.12 vrf v1
    r3 tping 0 20 4321::12 vrf v1
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
        2. Fetch [rout-isis026](../clab/rout-isis026/rout-isis026.yml) file  
        3. Launch ContainerLab `rout-isis026.yml` topology:  

        ```
           containerlab deploy --topo rout-isis026.yml  
        ```
        4. Destroy ContainerLab `rout-isis026.yml` topology:  

        ```
           containerlab destroy --topo rout-isis026.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-isis026.tst` file [here](../tst/rout-isis026.tst)  
        3. Launch `rout-isis026.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-isis026 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-isis026.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

