# Example: babel prefix withdraw

=== "Topology"

    ![Alt text](../d2/rout-babel20/rout-babel20.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router babel4 1
     vrf v1
     router 1111-2222-3333-0001
     exit
    router babel6 1
     vrf v1
     router 1111-2222-3333-0001
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router babel4 1 ena
     router babel6 1 ena
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     router babel4 1 ena
     router babel6 1 ena
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router babel4 1
     vrf v1
     router 1111-2222-3333-0002
     exit
    router babel6 1
     vrf v1
     router 1111-2222-3333-0002
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router babel4 1 ena
     router babel6 1 ena
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     router babel4 1 ena
     router babel6 1 ena
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 130 2.2.2.2 vrf v1
    r1 tping 100 130 4321::2 vrf v1
    r2 tping 100 130 2.2.2.1 vrf v1
    r2 tping 100 130 4321::1 vrf v1
    r1 send conf t
    r1 send int lo0
    r1 send no router babel4 1 ena
    r1 send no router babel6 1 ena
    r1 send end
    r1 tping 100 130 2.2.2.2 vrf v1
    r1 tping 100 130 4321::2 vrf v1
    r2 tping 0 130 2.2.2.1 vrf v1
    r2 tping 0 130 4321::1 vrf v1
    r1 send conf t
    r1 send int lo0
    r1 send router babel4 1 ena
    r1 send router babel6 1 ena
    r1 send end
    r1 tping 100 130 2.2.2.2 vrf v1
    r1 tping 100 130 4321::2 vrf v1
    r2 tping 100 130 2.2.2.1 vrf v1
    r2 tping 100 130 4321::1 vrf v1
    r2 output show ipv4 babel 1 sum
    r2 output show ipv6 babel 1 sum
    r2 output show ipv4 babel 1 dat
    r2 output show ipv6 babel 1 dat
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-babel20](../clab/rout-babel20/rout-babel20.yml) file  
        3. Launch ContainerLab `rout-babel20.yml` topology:  

        ```
           containerlab deploy --topo rout-babel20.yml  
        ```
        4. Destroy ContainerLab `rout-babel20.yml` topology:  

        ```
           containerlab destroy --topo rout-babel20.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-babel20.tst` file [here](../tst/rout-babel20.tst)  
        3. Launch `rout-babel20.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-babel20 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-babel20.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

