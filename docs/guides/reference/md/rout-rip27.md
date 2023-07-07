# Example: rip over point2point ethernet

=== "Topology"

    ![Alt text](../d2/rout-rip27/rout-rip27.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router rip4 1
     vrf v1
     exit
    router rip6 1
     vrf v1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router rip4 1 ena
     router rip6 1 ena
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.254
     ipv6 addr 1234:1::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffe
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
     exit
    router rip6 1
     vrf v1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router rip4 1 ena
     router rip6 1 ena
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.254
     ipv6 addr 1234:1::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffe
     router rip4 1 ena
     router rip6 1 ena
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 130 2.2.2.2 vrf v1
    r1 tping 100 130 4321::2 vrf v1
    r2 tping 100 130 2.2.2.1 vrf v1
    r2 tping 100 130 4321::1 vrf v1
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
        2. Fetch [rout-rip27](../clab/rout-rip27/rout-rip27.yml) file  
        3. Launch ContainerLab `rout-rip27.yml` topology:  

        ```
           containerlab deploy --topo rout-rip27.yml  
        ```
        4. Destroy ContainerLab `rout-rip27.yml` topology:  

        ```
           containerlab destroy --topo rout-rip27.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-rip27.tst` file [here](../tst/rout-rip27.tst)  
        3. Launch `rout-rip27.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-rip27 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-rip27.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

