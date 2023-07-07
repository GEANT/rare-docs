# Example: rift point2point connection with bidir check

=== "Topology"

    ![Alt text](../d2/rout-rift22/rout-rift22.svg)

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
     spf-bidir
     exit
    router rift6 1
     vrf v1
     router 61
     red conn
     spf-bidir
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
     spf-bidir
     exit
    router rift6 1
     vrf v1
     router 62
     red conn
     spf-bidir
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
        2. Fetch [rout-rift22](../clab/rout-rift22/rout-rift22.yml) file  
        3. Launch ContainerLab `rout-rift22.yml` topology:  

        ```
           containerlab deploy --topo rout-rift22.yml  
        ```
        4. Destroy ContainerLab `rout-rift22.yml` topology:  

        ```
           containerlab destroy --topo rout-rift22.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-rift22.tst` file [here](../tst/rout-rift22.tst)  
        3. Launch `rout-rift22.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-rift22 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-rift22.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

