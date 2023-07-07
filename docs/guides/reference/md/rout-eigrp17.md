# Example: eigrp aggregation

=== "Topology"

    ![Alt text](../d2/rout-eigrp17/rout-eigrp17.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router eigrp4 1
     vrf v1
     router 4.4.4.1
     as 1
     red conn
     exit
    router eigrp6 1
     vrf v1
     router 6.6.6.1
     as 1
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
    route-map p4
     sequence 10 act deny
      match network 2.2.2.12/32
     sequence 20 act perm
      match network 0.0.0.0/0 le 32
     exit
    route-map p6
     sequence 10 act deny
      match network 4321::12/128
     sequence 20 act perm
      match network ::/0 le 128
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     router eigrp4 1 route-map-in p4
     router eigrp6 1 route-map-in p6
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router eigrp4 1
     vrf v1
     router 4.4.4.2
     as 1
     aggregate 2.2.2.0/24
     red conn
     exit
    router eigrp6 1
     vrf v1
     router 6.6.6.2
     as 1
     aggregate 4321::/32
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
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 40 2.2.2.2 vrf v1
    r1 tping 100 40 4321::2 vrf v1
    r1 tping 100 40 2.2.2.12 vrf v1
    r1 tping 100 40 4321::12 vrf v1
    r1 tping 100 40 2.2.2.22 vrf v1
    r1 tping 100 40 4321::22 vrf v1
    r2 tping 100 40 2.2.2.1 vrf v1
    r2 tping 100 40 4321::1 vrf v1
    r2 tping 100 40 2.2.2.11 vrf v1
    r2 tping 100 40 4321::11 vrf v1
    r2 tping 100 40 2.2.2.21 vrf v1
    r2 tping 100 40 4321::21 vrf v1
    r2 output show ipv4 eigrp 1 sum
    r2 output show ipv6 eigrp 1 sum
    r2 output show ipv4 eigrp 1 rou
    r2 output show ipv6 eigrp 1 rou
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-eigrp17](../clab/rout-eigrp17/rout-eigrp17.yml) file  
        3. Launch ContainerLab `rout-eigrp17.yml` topology:  

        ```
           containerlab deploy --topo rout-eigrp17.yml  
        ```
        4. Destroy ContainerLab `rout-eigrp17.yml` topology:  

        ```
           containerlab destroy --topo rout-eigrp17.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-eigrp17.tst` file [here](../tst/rout-eigrp17.tst)  
        3. Launch `rout-eigrp17.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-eigrp17 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-eigrp17.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

