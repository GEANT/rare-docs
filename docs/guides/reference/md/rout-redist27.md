# Example: redistribution with metric

=== "Topology"

    ![Alt text](../d2/rout-redist27/rout-redist27.svg)

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
     red conn metric 1000
     exit
    router isis6 1
     vrf v1
     net 22.6666.0000.1111.00
     red conn metric 1000
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
    route-map rm1
     sequence 10 act deny
     sequence 10 match metric 2000-4000
     sequence 20 act perm
     exit
    router isis4 1
     vrf v1
     net 22.4444.0000.2222.00
     red conn
     both route-map-from rm1
     exit
    router isis6 1
     vrf v1
     net 22.6666.0000.2222.00
     red conn
     both route-map-from rm1
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
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r2 tping 100 20 4321::1 vrf v1
    r1 send conf t
    r1 send router isis4 1
    r1 send red conn metric 3000
    r1 send exit
    r1 send router isis6 1
    r1 send red conn metric 3000
    r1 send exit
    r1 send end
    r1 tping 100 20 2.2.2.2 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r2 tping 0 20 2.2.2.1 vrf v1
    r2 tping 0 20 4321::1 vrf v1
    r1 send conf t
    r1 send router isis4 1
    r1 send red conn metric 5000
    r1 send exit
    r1 send router isis6 1
    r1 send red conn metric 5000
    r1 send exit
    r1 send end
    r1 tping 100 20 2.2.2.2 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r2 tping 100 20 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-redist27](../clab/rout-redist27/rout-redist27.yml) file  
        3. Launch ContainerLab `rout-redist27.yml` topology:  

        ```
           containerlab deploy --topo rout-redist27.yml  
        ```
        4. Destroy ContainerLab `rout-redist27.yml` topology:  

        ```
           containerlab destroy --topo rout-redist27.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-redist27.tst` file [here](../tst/rout-redist27.tst)  
        3. Launch `rout-redist27.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-redist27 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-redist27.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

