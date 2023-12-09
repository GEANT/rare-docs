# Example: rift with pmtud

=== "Topology"

    ![Alt text](../d2/rout-rift29/rout-rift29.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router rift4 1
     vrf v1
     router 41
     red conn
     exit
    router rift6 1
     vrf v1
     router 61
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     router rift4 1 ena
     router rift6 1 ena
     router rift4 1 ipinfo pmtud 512 1024 666
     router rift6 1 ipinfo pmtud 512 1024 666
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router rift4 1
     vrf v1
     router 42
     red conn
     exit
    router rift6 1
     vrf v1
     router 62
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     router rift4 1 ena
     router rift6 1 ena
     router rift4 1 ipinfo pmtud 512 1024 666
     router rift6 1 ipinfo pmtud 512 1024 666
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r2 tping 100 20 4321::1 vrf v1
    r2 output show ipv4 rift 1 nei
    r2 output show ipv6 rift 1 nei
    r2 output show ipv4 rift 1 dat
    r2 output show ipv6 rift 1 dat
    r2 output show ipv4 rift 1 tre n
    r2 output show ipv6 rift 1 tre n
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-rift29](../clab/rout-rift29/rout-rift29.yml) file  
        3. Launch ContainerLab `rout-rift29.yml` topology:  

        ```
           containerlab deploy --topo rout-rift29.yml  
        ```
        4. Destroy ContainerLab `rout-rift29.yml` topology:  

        ```
           containerlab destroy --topo rout-rift29.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-rift29.tst` file [here](../tst/rout-rift29.tst)  
        3. Launch `rout-rift29.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-rift29 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-rift29.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

