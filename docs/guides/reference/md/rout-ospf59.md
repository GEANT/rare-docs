# Example: ospf flexalgo

=== "Topology"

    ![Alt text](../d2/rout-ospf59/rout-ospf59.svg)

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
    router ospf4 1
     vrf v1
     router 4.4.4.1
     flexalgo 128 v2
     area 0 ena
     segrout 10
     area 0 segrout
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.1
     flexalgo 128 v2
     area 0 ena
     segrout 10
     area 0 segrout
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
     router ospf4 1 ena
     router ospf6 1 ena
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
    router ospf4 1
     vrf v1
     router 4.4.4.2
     flexalgo 128 v2
     area 0 ena
     segrout 10
     area 0 segrout
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.2
     flexalgo 128 v2
     area 0 ena
     segrout 10
     area 0 segrout
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
     router ospf4 1 ena
     router ospf6 1 ena
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r2 tping 100 20 4321::1 vrf v1
    r2 output show ipv4 ospf 1 nei
    r2 output show ipv6 ospf 1 nei
    r2 output show ipv4 ospf 1 dat 0
    r2 output show ipv6 ospf 1 dat 0
    r2 output show ipv4 ospf 1 tre 0
    r2 output show ipv6 ospf 1 tre 0
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    r2 output show ipv4 route v2
    r2 output show ipv6 route v2
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-ospf59](../clab/rout-ospf59/rout-ospf59.yml) file  
        3. Launch ContainerLab `rout-ospf59.yml` topology:  

        ```
           containerlab deploy --topo rout-ospf59.yml  
        ```
        4. Destroy ContainerLab `rout-ospf59.yml` topology:  

        ```
           containerlab destroy --topo rout-ospf59.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-ospf59.tst` file [here](../tst/rout-ospf59.tst)  
        3. Launch `rout-ospf59.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-ospf59 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-ospf59.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

