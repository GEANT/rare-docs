# Example: integrated isis prefix withdraw

=== "Topology"

    ![Alt text](../d2/rout-isis086/rout-isis086.svg)

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
     afi-other enable
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis4 1 ena
     router isis4 1 other-ena
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     router isis4 1 ena
     router isis4 1 other-ena
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router isis6 1
     vrf v1
     net 22.6666.0000.2222.00
     afi-other enable
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis6 1 ena
     router isis6 1 other-ena
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     router isis6 1 ena
     router isis6 1 other-ena
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r2 tping 100 20 4321::1 vrf v1
    r1 send conf t
    r1 send int lo1
    r1 send no router isis4 1 ena
    r1 send no router isis4 1 other-ena
    r1 send exit
    r1 send exit
    r1 tping 100 20 2.2.2.2 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r2 tping 0 20 2.2.2.1 vrf v1
    r2 tping 0 20 4321::1 vrf v1
    r1 send conf t
    r1 send int lo1
    r1 send router isis4 1 ena
    r1 send router isis4 1 other-ena
    r1 send exit
    r1 send exit
    r1 tping 100 20 2.2.2.2 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r2 tping 100 20 4321::1 vrf v1
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
        2. Fetch [rout-isis086](../clab/rout-isis086/rout-isis086.yml) file  
        3. Launch ContainerLab `rout-isis086.yml` topology:  

        ```
           containerlab deploy --topo rout-isis086.yml  
        ```
        4. Destroy ContainerLab `rout-isis086.yml` topology:  

        ```
           containerlab destroy --topo rout-isis086.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-isis086.tst` file [here](../tst/rout-isis086.tst)  
        3. Launch `rout-isis086.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-isis086 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-isis086.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

