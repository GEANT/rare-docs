# Example: lsrp flexalgo

=== "Topology"

    ![Alt text](../d2/rout-lsrp49/rout-lsrp49.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    vrf def v2
     rd 1:1
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.1
     flexalgo 128 v2
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.1
     flexalgo 128 v2
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
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    vrf def v2
     rd 1:1
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.2
     flexalgo 128 v2
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.2
     flexalgo 128 v2
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
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r2 tping 100 20 4321::1 vrf v1
    r2 output show ipv4 lsrp 1 nei
    r2 output show ipv6 lsrp 1 nei
    r2 output show ipv4 lsrp 1 dat
    r2 output show ipv6 lsrp 1 dat
    r2 output show ipv4 lsrp 1 tre
    r2 output show ipv6 lsrp 1 tre
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    r2 output show ipv4 route v2
    r2 output show ipv6 route v2
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-lsrp49](../clab/rout-lsrp49/rout-lsrp49.yml) file  
        3. Launch ContainerLab `rout-lsrp49.yml` topology:  

        ```
           containerlab deploy --topo rout-lsrp49.yml  
        ```
        4. Destroy ContainerLab `rout-lsrp49.yml` topology:  

        ```
           containerlab destroy --topo rout-lsrp49.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-lsrp49.tst` file [here](../tst/rout-lsrp49.tst)  
        3. Launch `rout-lsrp49.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-lsrp49 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-lsrp49.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

