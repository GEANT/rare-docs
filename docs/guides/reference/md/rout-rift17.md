# Example: rift prefix movement

=== "Topology"

    ![Alt text](../d2/rout-rift17/rout-rift17.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    route-map rm1
     set metric 10
     exit
    router rift4 1
     vrf v1
     router 41
     advertise 2.2.2.1/32 route-map rm1
     advertise 2.2.2.222/32 route-map rm1
     exit
    router rift6 1
     vrf v1
     router 61
     advertise 4321::1/128 route-map rm1
     advertise 4321::222/128 route-map rm1
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.222 255.255.255.255
     ipv6 addr 4321::222 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo3
     vrf for v1
     ipv4 addr 2.2.2.101 255.255.255.255
     ipv6 addr 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    server telnet tel
     vrf v1
     port 666
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
     advertise 2.2.2.2/32
     exit
    router rift6 1
     vrf v1
     router 62
     advertise 4321::2/128
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router rift4 1 ena
     router rift6 1 ena
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     router rift4 1 ena
     router rift6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     router rift4 1 ena
     router rift6 1 ena
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    route-map rm1
     set metric 20
     exit
    router rift4 1
     vrf v1
     router 43
     advertise 2.2.2.3/32 route-map rm1
     advertise 2.2.2.222/32 route-map rm1
     exit
    router rift6 1
     vrf v1
     router 63
     advertise 4321::3/128 route-map rm1
     advertise 4321::222/128 route-map rm1
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.222 255.255.255.255
     ipv6 addr 4321::222 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo3
     vrf for v1
     ipv4 addr 2.2.2.103 255.255.255.255
     ipv6 addr 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    server telnet tel
     vrf v1
     port 666
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     router rift4 1 ena
     router rift6 1 ena
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 40 2.2.2.2 vrf v1
    r1 tping 100 40 4321::2 vrf v1
    r1 tping 100 40 2.2.2.3 vrf v1
    r1 tping 100 40 4321::3 vrf v1
    r1 tping 100 40 2.2.2.222 vrf v1
    r1 tping 100 40 4321::222 vrf v1
    r2 tping 100 40 2.2.2.1 vrf v1
    r2 tping 100 40 4321::1 vrf v1
    r2 tping 100 40 2.2.2.3 vrf v1
    r2 tping 100 40 4321::3 vrf v1
    r2 tping 100 40 2.2.2.222 vrf v1
    r2 tping 100 40 4321::222 vrf v1
    r3 tping 100 40 2.2.2.1 vrf v1
    r3 tping 100 40 4321::1 vrf v1
    r3 tping 100 40 2.2.2.3 vrf v1
    r3 tping 100 40 4321::3 vrf v1
    r3 tping 100 40 2.2.2.222 vrf v1
    r3 tping 100 40 4321::222 vrf v1
    r2 tping 0 40 2.2.2.101 vrf v1
    r2 tping 0 40 4321::101 vrf v1
    r2 tping 0 40 2.2.2.103 vrf v1
    r2 tping 0 40 4321::103 vrf v1
    r2 send telnet 2.2.2.222 666 vrf v1
    r2 tping 100 40 2.2.2.101 vrf v1
    r2 send exit
    r2 read closed
    r2 tping 0 40 2.2.2.101 vrf v1
    r2 send telnet 4321::222 666 vrf v1
    r2 tping 100 40 2.2.2.101 vrf v1
    r2 send exit
    r2 read closed
    r2 tping 0 40 2.2.2.101 vrf v1
    r1 send conf t
    r1 send route-map rm1
    r1 send set metric 30
    r1 send end
    r1 send clear ipv4 route v1
    r1 send clear ipv6 route v1
    r1 tping 100 40 2.2.2.2 vrf v1
    r1 tping 100 40 4321::2 vrf v1
    r1 tping 100 40 2.2.2.3 vrf v1
    r1 tping 100 40 4321::3 vrf v1
    r1 tping 100 40 2.2.2.222 vrf v1
    r1 tping 100 40 4321::222 vrf v1
    r2 tping 100 40 2.2.2.1 vrf v1
    r2 tping 100 40 4321::1 vrf v1
    r2 tping 100 40 2.2.2.3 vrf v1
    r2 tping 100 40 4321::3 vrf v1
    r2 tping 100 40 2.2.2.222 vrf v1
    r2 tping 100 40 4321::222 vrf v1
    r3 tping 100 40 2.2.2.1 vrf v1
    r3 tping 100 40 4321::1 vrf v1
    r3 tping 100 40 2.2.2.3 vrf v1
    r3 tping 100 40 4321::3 vrf v1
    r3 tping 100 40 2.2.2.222 vrf v1
    r3 tping 100 40 4321::222 vrf v1
    r2 tping 0 40 2.2.2.101 vrf v1
    r2 tping 0 40 4321::101 vrf v1
    r2 tping 0 40 2.2.2.103 vrf v1
    r2 tping 0 40 4321::103 vrf v1
    r2 send telnet 2.2.2.222 666 vrf v1
    r2 tping 100 40 2.2.2.103 vrf v1
    r2 send exit
    r2 read closed
    r2 tping 0 40 2.2.2.103 vrf v1
    r2 send telnet 4321::222 666 vrf v1
    r2 tping 100 40 2.2.2.103 vrf v1
    r2 send exit
    r2 read closed
    r2 tping 0 40 2.2.2.103 vrf v1
    r1 send conf t
    r1 send route-map rm1
    r1 send set metric 10
    r1 send end
    r1 send clear ipv4 route v1
    r1 send clear ipv6 route v1
    r1 tping 100 40 2.2.2.2 vrf v1
    r1 tping 100 40 4321::2 vrf v1
    r1 tping 100 40 2.2.2.3 vrf v1
    r1 tping 100 40 4321::3 vrf v1
    r1 tping 100 40 2.2.2.222 vrf v1
    r1 tping 100 40 4321::222 vrf v1
    r2 tping 100 40 2.2.2.1 vrf v1
    r2 tping 100 40 4321::1 vrf v1
    r2 tping 100 40 2.2.2.3 vrf v1
    r2 tping 100 40 4321::3 vrf v1
    r2 tping 100 40 2.2.2.222 vrf v1
    r2 tping 100 40 4321::222 vrf v1
    r3 tping 100 40 2.2.2.1 vrf v1
    r3 tping 100 40 4321::1 vrf v1
    r3 tping 100 40 2.2.2.3 vrf v1
    r3 tping 100 40 4321::3 vrf v1
    r3 tping 100 40 2.2.2.222 vrf v1
    r3 tping 100 40 4321::222 vrf v1
    r2 tping 0 40 2.2.2.101 vrf v1
    r2 tping 0 40 4321::101 vrf v1
    r2 tping 0 40 2.2.2.103 vrf v1
    r2 tping 0 40 4321::103 vrf v1
    r2 send telnet 2.2.2.222 666 vrf v1
    r2 tping 100 40 2.2.2.101 vrf v1
    r2 send exit
    r2 read closed
    r2 tping 0 40 2.2.2.101 vrf v1
    r2 send telnet 4321::222 666 vrf v1
    r2 tping 100 40 2.2.2.101 vrf v1
    r2 send exit
    r2 read closed
    r2 tping 0 40 2.2.2.101 vrf v1
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
        2. Fetch [rout-rift17](../clab/rout-rift17/rout-rift17.yml) file  
        3. Launch ContainerLab `rout-rift17.yml` topology:  

        ```
           containerlab deploy --topo rout-rift17.yml  
        ```
        4. Destroy ContainerLab `rout-rift17.yml` topology:  

        ```
           containerlab destroy --topo rout-rift17.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-rift17.tst` file [here](../tst/rout-rift17.tst)  
        3. Launch `rout-rift17.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-rift17 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-rift17.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

