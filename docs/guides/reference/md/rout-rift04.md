# Example: rift address suppression

=== "Topology"

    ![Alt text](../d2/rout-rift04/rout-rift04.svg)

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
     exit
    router rift6 1
     vrf v1
     router 61
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router rift4 1 ena
     router rift4 1 passiv
     router rift6 1 ena
     router rift6 1 passiv
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router rift4 1 ena
     router rift4 1 passiv
     router rift4 1 suppress
     router rift6 1 ena
     router rift6 1 passiv
     router rift6 1 suppress
     exit
    int lo3
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router rift4 1 ena
     router rift4 1 passiv
     router rift6 1 ena
     router rift6 1 passiv
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
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
     exit
    router rift6 1
     vrf v1
     router 62
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     router rift4 1 ena
     router rift6 1 ena
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 40 2.2.2.1 vrf v1
    r2 tping 0 40 2.2.2.2 vrf v1
    r2 tping 100 40 2.2.2.3 vrf v1
    r2 tping 100 40 4321::1 vrf v1
    r2 tping 0 40 4321::2 vrf v1
    r2 tping 100 40 4321::3 vrf v1
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
        2. Fetch [rout-rift04](../clab/rout-rift04/rout-rift04.yml) file  
        3. Launch ContainerLab `rout-rift04.yml` topology:  

        ```
           containerlab deploy --topo rout-rift04.yml  
        ```
        4. Destroy ContainerLab `rout-rift04.yml` topology:  

        ```
           containerlab destroy --topo rout-rift04.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-rift04.tst` file [here](../tst/rout-rift04.tst)  
        3. Launch `rout-rift04.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-rift04 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-rift04.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

