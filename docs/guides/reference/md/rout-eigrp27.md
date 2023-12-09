# Example: eigrp with pmtud

=== "Topology"

    ![Alt text](../d2/rout-eigrp27/rout-eigrp27.svg)

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
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     router eigrp4 1 ipinfo pmtud 512 1024 666
     router eigrp6 1 ipinfo pmtud 512 1024 666
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
     red conn
     exit
    router eigrp6 1
     vrf v1
     router 6.6.6.2
     as 1
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
     router eigrp4 1 ena
     router eigrp6 1 ena
     router eigrp4 1 ipinfo pmtud 512 1024 666
     router eigrp6 1 ipinfo pmtud 512 1024 666
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r2 tping 100 20 4321::1 vrf v1
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
        2. Fetch [rout-eigrp27](../clab/rout-eigrp27/rout-eigrp27.yml) file  
        3. Launch ContainerLab `rout-eigrp27.yml` topology:  

        ```
           containerlab deploy --topo rout-eigrp27.yml  
        ```
        4. Destroy ContainerLab `rout-eigrp27.yml` topology:  

        ```
           containerlab destroy --topo rout-eigrp27.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-eigrp27.tst` file [here](../tst/rout-eigrp27.tst)  
        3. Launch `rout-eigrp27.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-eigrp27 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-eigrp27.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

