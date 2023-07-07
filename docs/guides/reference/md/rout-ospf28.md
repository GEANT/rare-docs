# Example: ospf peer template

=== "Topology"

    ![Alt text](../d2/rout-ospf28/rout-ospf28.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router ospf4 1
     vrf v1
     router 4.4.4.1
     area 0 ena
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.1
     area 0 ena
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int temp1
     vrf for v1
     ipv4 addr 9.9.9.9 255.255.255.0
     ipv6 addr 9999::9 ffff::
     router ospf4 1 ena
     router ospf6 1 ena
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     temp temp1
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router ospf4 1
     vrf v1
     router 4.4.4.2
     area 0 ena
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.2
     area 0 ena
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int temp1
     vrf for v1
     ipv4 addr 9.9.9.9 255.255.255.0
     ipv6 addr 9999::9 ffff::
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     temp temp1
     exit
    int temp1
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
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-ospf28](../clab/rout-ospf28/rout-ospf28.yml) file  
        3. Launch ContainerLab `rout-ospf28.yml` topology:  

        ```
           containerlab deploy --topo rout-ospf28.yml  
        ```
        4. Destroy ContainerLab `rout-ospf28.yml` topology:  

        ```
           containerlab destroy --topo rout-ospf28.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-ospf28.tst` file [here](../tst/rout-ospf28.tst)  
        3. Launch `rout-ospf28.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-ospf28 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-ospf28.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

