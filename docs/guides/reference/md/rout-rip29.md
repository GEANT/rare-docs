# Example: rip default address suppression

=== "Topology"

    ![Alt text](../d2/rout-rip29/rout-rip29.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router rip4 1
     vrf v1
     suppress
     exit
    router rip6 1
     vrf v1
     suppress
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router rip4 1 ena
     router rip6 1 ena
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.11 255.255.255.255
     ipv6 addr 4321::11 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router rip4 1 ena
     router rip6 1 ena
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.21 255.255.255.255
     ipv6 addr 4321::21 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router rip4 1 ena
     router rip6 1 ena
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
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.12 255.255.255.255
     ipv6 addr 4321::12 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.22 255.255.255.255
     ipv6 addr 4321::22 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     router rip4 1 ena
     router rip6 1 ena
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 130 2.2.2.2 vrf v1
    r1 tping 100 130 4321::2 vrf v1
    r1 tping 100 130 2.2.2.12 vrf v1
    r1 tping 100 130 4321::12 vrf v1
    r1 tping 100 130 2.2.2.22 vrf v1
    r1 tping 100 130 4321::22 vrf v1
    r2 tping 0 130 2.2.2.1 vrf v1
    r2 tping 0 130 4321::1 vrf v1
    r2 tping 0 130 2.2.2.11 vrf v1
    r2 tping 0 130 4321::11 vrf v1
    r2 tping 0 130 2.2.2.21 vrf v1
    r2 tping 0 130 4321::21 vrf v1
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
        2. Fetch [rout-rip29](../clab/rout-rip29/rout-rip29.yml) file  
        3. Launch ContainerLab `rout-rip29.yml` topology:  

        ```
           containerlab deploy --topo rout-rip29.yml  
        ```
        4. Destroy ContainerLab `rout-rip29.yml` topology:  

        ```
           containerlab destroy --topo rout-rip29.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-rip29.tst` file [here](../tst/rout-rip29.tst)  
        3. Launch `rout-rip29.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-rip29 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-rip29.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

