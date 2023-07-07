# Example: conditional redistribution with routemap

=== "Topology"

    ![Alt text](../d2/rout-redist24/rout-redist24.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    track t
     force up
     exit
    route-map rm1
     sequence 10 act perm
      match track t
     exit
    router isis4 1
     vrf v1
     net 11.4444.0000.1111.00
     red conn route-map rm1
     exit
    router isis6 1
     vrf v1
     net 11.6666.0000.1111.00
     red conn route-map rm1
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     exit
    int lo2
     vrf for v1
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
     net 22.4444.0000.2222.00
     red conn
     exit
    router isis6 1
     vrf v1
     net 22.6666.0000.2222.00
     red conn
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
    ```

=== "Verification"

    ```
    r2 tping 100 20 2.2.2.1 vrf v1
    r2 tping 100 20 4321::1 vrf v1
    r1 tping 100 20 2.2.2.2 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r1 send conf t
    r1 send track t
    r1 send force down
    r1 send exit
    r1 send end
    r1 send clear ipv4 route v1
    r1 send clear ipv6 route v1
    r1 tping 100 20 2.2.2.2 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r2 tping 0 20 2.2.2.1 vrf v1
    r2 tping 0 20 4321::1 vrf v1
    r1 send conf t
    r1 send track t
    r1 send force up
    r1 send exit
    r1 send end
    r1 send clear ipv4 route v1
    r1 send clear ipv6 route v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r2 tping 100 20 4321::1 vrf v1
    r1 tping 100 20 2.2.2.2 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-redist24](../clab/rout-redist24/rout-redist24.yml) file  
        3. Launch ContainerLab `rout-redist24.yml` topology:  

        ```
           containerlab deploy --topo rout-redist24.yml  
        ```
        4. Destroy ContainerLab `rout-redist24.yml` topology:  

        ```
           containerlab destroy --topo rout-redist24.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-redist24.tst` file [here](../tst/rout-redist24.tst)  
        3. Launch `rout-redist24.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-redist24 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-redist24.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

