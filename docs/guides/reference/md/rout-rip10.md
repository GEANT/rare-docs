# Example: rip tag

=== "Topology"

    ![Alt text](../d2/rout-rip10/rout-rip10.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    route-map rm1
     set tag 1234
     exit
    router rip4 1
     vrf v1
     red conn route-map rm1
     exit
    router rip6 1
     vrf v1
     red conn route-map rm1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     router rip4 1 ena
     router rip6 1 ena
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router rip4 1
     vrf v1
     red conn
     exit
    router rip6 1
     vrf v1
     red conn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    route-map rm1
     sequence 10 act perm
      match tag 1234
      set metric +9
     sequence 20 act perm
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     router rip4 1 ena
     router rip6 1 ena
     router rip4 1 route-map-in rm1
     router rip6 1 route-map-in rm1
     router rip4 1 route-map-out rm1
     router rip6 1 route-map-out rm1
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     router rip4 1 ena
     router rip6 1 ena
     router rip4 1 route-map-in rm1
     router rip6 1 route-map-in rm1
     router rip4 1 route-map-out rm1
     router rip6 1 route-map-out rm1
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    route-map rm1
     set tag 1234
     exit
    router rip4 1
     vrf v1
     red conn route-map rm1
     exit
    router rip6 1
     vrf v1
     red conn route-map rm1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     router rip4 1 ena
     router rip6 1 ena
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 130 2.2.2.1 vrf v1
    r2 tping 100 130 2.2.2.3 vrf v1
    r2 tping 100 130 4321::1 vrf v1
    r2 tping 100 130 4321::3 vrf v1
    r1 tping 100 130 2.2.2.2 vrf v1
    r1 tping 0 130 2.2.2.3 vrf v1
    r1 tping 100 130 4321::2 vrf v1
    r1 tping 0 130 4321::3 vrf v1
    r3 tping 0 130 2.2.2.1 vrf v1
    r3 tping 100 130 2.2.2.2 vrf v1
    r3 tping 0 130 4321::1 vrf v1
    r3 tping 100 130 4321::2 vrf v1
    r2 output show ipv4 rip 1 sum
    r2 output show ipv6 rip 1 sum
    r2 output show ipv4 rip 1 dat
    r2 output show ipv6 rip 1 dat
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-rip10](../clab/rout-rip10/rout-rip10.yml) file  
        3. Launch ContainerLab `rout-rip10.yml` topology:  

        ```
           containerlab deploy --topo rout-rip10.yml  
        ```
        4. Destroy ContainerLab `rout-rip10.yml` topology:  

        ```
           containerlab destroy --topo rout-rip10.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-rip10.tst` file [here](../tst/rout-rip10.tst)  
        3. Launch `rout-rip10.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-rip10 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-rip10.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

