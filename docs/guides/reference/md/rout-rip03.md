# Example: rip ingress route filtering with prefixlist

=== "Topology"

    ![Alt text](../d2/rout-rip03/rout-rip03.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router rip4 1
     vrf v1
     red conn
     exit
    router rip6 1
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
    prefix-list p4
     sequence 10 deny 2.2.2.12/32
     sequence 20 permit 0.0.0.0/0 le 32
     exit
    prefix-list p6
     sequence 10 deny 4321::12/128
     sequence 20 permit ::/0 le 128
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     router rip4 1 ena
     router rip6 1 ena
     router rip4 1 prefix-list-in p4
     router rip6 1 prefix-list-in p6
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router rip4 1
     vrf v1
     red conn
     exit
    router rip6 1
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
     router rip4 1 ena
     router rip6 1 ena
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
    r2 output show ipv4 rip 1 sum
    r2 output show ipv6 rip 1 sum
    r2 output show ipv4 rip 1 dat
    r2 output show ipv6 rip 1 dat
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-rip03](../clab/rout-rip03/rout-rip03.yml) file  
        3. Launch ContainerLab `rout-rip03.yml` topology:  

        ```
           containerlab deploy --topo rout-rip03.yml  
        ```
        4. Destroy ContainerLab `rout-rip03.yml` topology:  

        ```
           containerlab destroy --topo rout-rip03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-rip03.tst` file [here](../tst/rout-rip03.tst)  
        3. Launch `rout-rip03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-rip03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-rip03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

