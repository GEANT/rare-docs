# Example: ospf point2multipoint connection

=== "Topology"

    ![Alt text](../d2/rout-ospf02/rout-ospf02.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    bridge 1
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
    int eth1
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     ipv4 resend-packet
     ipv6 resend-packet
     router ospf4 1 ena
     router ospf4 1 net point2multi
     router ospf6 1 ena
     router ospf6 1 net point2multi
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    bridge 1
     mac-learn
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
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     ipv4 resend-packet
     ipv6 resend-packet
     router ospf4 1 ena
     router ospf4 1 net point2multi
     router ospf6 1 ena
     router ospf6 1 net point2multi
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    bridge 1
     mac-learn
     exit
    router ospf4 1
     vrf v1
     router 4.4.4.3
     area 0 ena
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.3
     area 0 ena
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff::
     ipv4 resend-packet
     ipv6 resend-packet
     router ospf4 1 ena
     router ospf4 1 net point2multi
     router ospf6 1 ena
     router ospf6 1 net point2multi
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    bridge 1
     exit
    router ospf4 1
     vrf v1
     router 4.4.4.4
     area 0 ena
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.4
     area 0 ena
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.4 255.255.255.0
     ipv6 addr 1234::4 ffff::
     ipv4 resend-packet
     ipv6 resend-packet
     router ospf4 1 ena
     router ospf4 1 net point2multi
     router ospf6 1 ena
     router ospf6 1 net point2multi
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 80 2.2.2.2 vrf v1
    r1 tping 100 80 2.2.2.3 vrf v1
    r1 tping 100 80 2.2.2.4 vrf v1
    r1 tping 100 80 4321::2 vrf v1
    r1 tping 100 80 4321::3 vrf v1
    r1 tping 100 80 4321::4 vrf v1
    r2 tping 100 80 2.2.2.1 vrf v1
    r2 tping 100 80 2.2.2.3 vrf v1
    r2 tping 100 80 2.2.2.4 vrf v1
    r2 tping 100 80 4321::1 vrf v1
    r2 tping 100 80 4321::3 vrf v1
    r2 tping 100 80 4321::4 vrf v1
    r3 tping 100 80 2.2.2.1 vrf v1
    r3 tping 100 80 2.2.2.2 vrf v1
    r3 tping 100 80 2.2.2.4 vrf v1
    r3 tping 100 80 4321::1 vrf v1
    r3 tping 100 80 4321::2 vrf v1
    r3 tping 100 80 4321::4 vrf v1
    r4 tping 100 80 2.2.2.1 vrf v1
    r4 tping 100 80 2.2.2.2 vrf v1
    r4 tping 100 80 2.2.2.3 vrf v1
    r4 tping 100 80 4321::1 vrf v1
    r4 tping 100 80 4321::2 vrf v1
    r4 tping 100 80 4321::3 vrf v1
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
        2. Fetch [rout-ospf02](../clab/rout-ospf02/rout-ospf02.yml) file  
        3. Launch ContainerLab `rout-ospf02.yml` topology:  

        ```
           containerlab deploy --topo rout-ospf02.yml  
        ```
        4. Destroy ContainerLab `rout-ospf02.yml` topology:  

        ```
           containerlab destroy --topo rout-ospf02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-ospf02.tst` file [here](../tst/rout-ospf02.tst)  
        3. Launch `rout-ospf02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-ospf02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-ospf02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

