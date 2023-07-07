# Example: lsrp default address suppression

=== "Topology"

    ![Alt text](../d2/rout-lsrp28/rout-lsrp28.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.1
     suppress
     justadv lo1
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.1
     suppress
     justadv lo1
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router lsrp4 1 ena
     router lsrp4 1 passiv
     router lsrp6 1 ena
     router lsrp6 1 passiv
     exit
    int lo3
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router lsrp4 1 ena
     router lsrp4 1 passiv
     router lsrp6 1 ena
     router lsrp6 1 passiv
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
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
    router lsrp4 1
     vrf v1
     router 4.4.4.2
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.2
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 40 2.2.2.1 vrf v1
    r2 tping 0 40 2.2.2.2 vrf v1
    r2 tping 0 40 2.2.2.3 vrf v1
    r2 tping 100 40 4321::1 vrf v1
    r2 tping 0 40 4321::2 vrf v1
    r2 tping 0 40 4321::3 vrf v1
    r2 output show ipv4 lsrp 1 nei
    r2 output show ipv6 lsrp 1 nei
    r2 output show ipv4 lsrp 1 dat
    r2 output show ipv6 lsrp 1 dat
    r2 output show ipv4 lsrp 1 tre
    r2 output show ipv6 lsrp 1 tre
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-lsrp28](../clab/rout-lsrp28/rout-lsrp28.yml) file  
        3. Launch ContainerLab `rout-lsrp28.yml` topology:  

        ```
           containerlab deploy --topo rout-lsrp28.yml  
        ```
        4. Destroy ContainerLab `rout-lsrp28.yml` topology:  

        ```
           containerlab destroy --topo rout-lsrp28.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-lsrp28.tst` file [here](../tst/rout-lsrp28.tst)  
        3. Launch `rout-lsrp28.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-lsrp28 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-lsrp28.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

