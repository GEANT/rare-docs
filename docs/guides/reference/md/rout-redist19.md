# Example: redistribution prefix withdraw

=== "Topology"

    ![Alt text](../d2/rout-redist19/rout-redist19.svg)

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
     exit
    router isis6 1
     vrf v1
     net 11.6666.0000.1111.00
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     router isis4 1 ena
     exit
    int lo2
     vrf for v1
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis6 1 ena
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
     net 22.4444.0000.2222.00
     red conn
     red isis4 2
     exit
    router isis6 1
     vrf v1
     net 22.6666.0000.2222.00
     red conn
     red isis6 2
     exit
    router isis4 2
     vrf v1
     net 22.4444.0000.2222.00
     red conn
     red isis4 1
     exit
    router isis6 2
     vrf v1
     net 22.6666.0000.2222.00
     red conn
     red isis6 1
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     exit
    int lo2
     vrf for v1
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
     net 33.4444.0000.3333.00
     exit
    router isis6 1
     vrf v1
     net 33.6666.0000.3333.00
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     router isis4 1 ena
     exit
    int lo2
     vrf for v1
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis6 1 ena
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
    r2 tping 100 20 4321::1 vrf v1
    r2 tping 100 20 2.2.2.3 vrf v1
    r2 tping 100 20 4321::3 vrf v1
    r1 tping 100 20 2.2.2.2 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r1 tping 100 20 2.2.2.3 vrf v1
    r1 tping 100 20 4321::3 vrf v1
    r3 tping 100 20 2.2.2.2 vrf v1
    r3 tping 100 20 4321::2 vrf v1
    r3 tping 100 20 2.2.2.1 vrf v1
    r3 tping 100 20 4321::1 vrf v1
    r1 send conf t
    r1 send int lo1
    r1 send no router isis4 1 ena
    r1 send exit
    r1 send int lo2
    r1 send no router isis6 1 ena
    r1 send end
    r1 tping 100 20 2.2.2.2 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r1 tping 100 20 2.2.2.3 vrf v1
    r1 tping 100 20 4321::3 vrf v1
    r2 tping 0 20 2.2.2.1 vrf v1
    r2 tping 0 20 4321::1 vrf v1
    r2 tping 100 20 2.2.2.3 vrf v1
    r2 tping 100 20 4321::3 vrf v1
    r3 tping 0 20 2.2.2.1 vrf v1
    r3 tping 0 20 4321::1 vrf v1
    r3 tping 100 20 2.2.2.2 vrf v1
    r3 tping 100 20 4321::2 vrf v1
    r1 send conf t
    r1 send int lo1
    r1 send router isis4 1 ena
    r1 send exit
    r1 send int lo2
    r1 send router isis6 1 ena
    r1 send end
    r2 tping 100 20 2.2.2.1 vrf v1
    r2 tping 100 20 4321::1 vrf v1
    r2 tping 100 20 2.2.2.3 vrf v1
    r2 tping 100 20 4321::3 vrf v1
    r1 tping 100 20 2.2.2.2 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r1 tping 100 20 2.2.2.3 vrf v1
    r1 tping 100 20 4321::3 vrf v1
    r3 tping 100 20 2.2.2.2 vrf v1
    r3 tping 100 20 4321::2 vrf v1
    r3 tping 100 20 2.2.2.1 vrf v1
    r3 tping 100 20 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-redist19](../clab/rout-redist19/rout-redist19.yml) file  
        3. Launch ContainerLab `rout-redist19.yml` topology:  

        ```
           containerlab deploy --topo rout-redist19.yml  
        ```
        4. Destroy ContainerLab `rout-redist19.yml` topology:  

        ```
           containerlab destroy --topo rout-redist19.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-redist19.tst` file [here](../tst/rout-redist19.tst)  
        3. Launch `rout-redist19.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-redist19 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-redist19.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

