# Example: olsr ingress route filtering with routepolicy

=== "Topology"

    ![Alt text](../d2/rout-olsr07/rout-olsr07.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router olsr4 1
     vrf v1
     red conn
     exit
    router olsr6 1
     vrf v1
     red conn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.11 255.255.255.255
     ipv6 addr 4321::11 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.21 255.255.255.255
     ipv6 addr 4321::21 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    route-policy p4
     if network 2.2.2.12/32
      drop
     else
      pass
     enif
     exit
    route-policy p6
     if network 4321::12/128
      drop
     else
      pass
     enif
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     router olsr4 1 ena
     router olsr6 1 ena
     router olsr4 1 route-policy-in p4
     router olsr6 1 route-policy-in p6
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router olsr4 1
     vrf v1
     red conn
     exit
    router olsr6 1
     vrf v1
     red conn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.12 255.255.255.255
     ipv6 addr 4321::12 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.22 255.255.255.255
     ipv6 addr 4321::22 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     router olsr4 1 ena
     router olsr6 1 ena
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 130 2.2.2.2 vrf v1
    r1 tping 100 130 4321::2 vrf v1
    r1 tping 0 130 2.2.2.12 vrf v1
    r1 tping 0 130 4321::12 vrf v1
    r1 tping 100 130 2.2.2.22 vrf v1
    r1 tping 100 130 4321::22 vrf v1
    r2 tping 100 130 2.2.2.1 vrf v1
    r2 tping 100 130 4321::1 vrf v1
    r2 tping 100 130 2.2.2.11 vrf v1
    r2 tping 100 130 4321::11 vrf v1
    r2 tping 100 130 2.2.2.21 vrf v1
    r2 tping 100 130 4321::21 vrf v1
    r2 output show ipv4 olsr 1 sum
    r2 output show ipv6 olsr 1 sum
    r2 output show ipv4 olsr 1 dat
    r2 output show ipv6 olsr 1 dat
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-olsr07](../clab/rout-olsr07/rout-olsr07.yml) file  
        3. Launch ContainerLab `rout-olsr07.yml` topology:  

        ```
           containerlab deploy --topo rout-olsr07.yml  
        ```
        4. Destroy ContainerLab `rout-olsr07.yml` topology:  

        ```
           containerlab destroy --topo rout-olsr07.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-olsr07.tst` file [here](../tst/rout-olsr07.tst)  
        3. Launch `rout-olsr07.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-olsr07 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-olsr07.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

