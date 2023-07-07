# Example: ebgp over common subnet

=== "Topology"

    ![Alt text](../d2/rout-bgp571/rout-bgp571.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int ser1
     enc ppp
     ppp ip4cp open
     ppp ip6cp open
     ppp ip4cp local 1.1.1.1
     ppp ip6cp keep
     ppp ip6cp local 0000-0000-0000-0001
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.255
     ipv6 addr 1234::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 2
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 1
     router-id 6.6.6.1
     neigh 1234::2 remote-as 2
     red conn
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo9
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.255
     ipv6 addr 1234::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int ser1
     enc ppp
     ppp ip4cp open
     ppp ip6cp open
     ppp ip4cp local 1.1.1.2
     ppp ip6cp keep
     ppp ip6cp local 0000-0000-0000-0002
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.255
     ipv6 addr 1234::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     no ipv4 gateway-local
     no ipv4 gateway-connect
     no ipv6 gateway-local
     no ipv6 gateway-connect
     exit
    int ser2
     enc ppp
     ppp ip4cp open
     ppp ip6cp open
     ppp ip4cp local 1.1.1.2
     ppp ip6cp keep
     ppp ip6cp local 0000-0000-0000-0002
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.255
     ipv6 addr 1234::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     no ipv4 gateway-local
     no ipv4 gateway-connect
     no ipv6 gateway-local
     no ipv6 gateway-connect
     exit
    int ser3
     enc ppp
     ppp ip4cp open
     ppp ip6cp open
     ppp ip4cp local 1.1.1.2
     ppp ip6cp keep
     ppp ip6cp local 0000-0000-0000-0002
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.255
     ipv6 addr 1234::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     no ipv4 gateway-local
     no ipv4 gateway-connect
     no ipv6 gateway-local
     no ipv6 gateway-connect
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 2
     router-id 4.4.4.2
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 update lo9
     neigh 1.1.1.3 remote-as 3
     neigh 1.1.1.3 update lo9
     neigh 1.1.1.4 remote-as 4
     neigh 1.1.1.4 update lo9
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 2
     router-id 6.6.6.2
     neigh 1234::1 remote-as 1
     neigh 1234::1 update lo9
     neigh 1234::3 remote-as 3
     neigh 1234::3 update lo9
     neigh 1234::4 remote-as 4
     neigh 1234::4 update lo9
     red conn
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int ser1
     enc ppp
     ppp ip4cp open
     ppp ip6cp open
     ppp ip4cp local 1.1.1.3
     ppp ip6cp keep
     ppp ip6cp local 0000-0000-0000-0003
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.255
     ipv6 addr 1234::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 3
     router-id 4.4.4.3
     neigh 1.1.1.2 remote-as 2
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 3
     router-id 6.6.6.3
     neigh 1234::2 remote-as 2
     red conn
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int ser1
     enc ppp
     ppp ip4cp open
     ppp ip6cp open
     ppp ip4cp local 1.1.1.4
     ppp ip6cp keep
     ppp ip6cp local 0000-0000-0000-0004
     vrf for v1
     ipv4 addr 1.1.1.4 255.255.255.255
     ipv6 addr 1234::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 4
     router-id 4.4.4.4
     neigh 1.1.1.2 remote-as 2
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 4
     router-id 6.6.6.4
     neigh 1234::2 remote-as 2
     red conn
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1
    r1 tping 100 60 2.2.2.3 vrf v1
    r1 tping 100 60 2.2.2.4 vrf v1
    r1 tping 100 60 4321::2 vrf v1
    r1 tping 100 60 4321::3 vrf v1
    r1 tping 100 60 4321::4 vrf v1
    r2 tping 100 60 2.2.2.1 vrf v1
    r2 tping 100 60 2.2.2.3 vrf v1
    r2 tping 100 60 2.2.2.4 vrf v1
    r2 tping 100 60 4321::1 vrf v1
    r2 tping 100 60 4321::3 vrf v1
    r2 tping 100 60 4321::4 vrf v1
    r3 tping 100 60 2.2.2.1 vrf v1
    r3 tping 100 60 2.2.2.2 vrf v1
    r3 tping 100 60 2.2.2.4 vrf v1
    r3 tping 100 60 4321::1 vrf v1
    r3 tping 100 60 4321::2 vrf v1
    r3 tping 100 60 4321::4 vrf v1
    r4 tping 100 60 2.2.2.1 vrf v1
    r4 tping 100 60 2.2.2.2 vrf v1
    r4 tping 100 60 2.2.2.3 vrf v1
    r4 tping 100 60 4321::1 vrf v1
    r4 tping 100 60 4321::2 vrf v1
    r4 tping 100 60 4321::3 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp571](../clab/rout-bgp571/rout-bgp571.yml) file  
        3. Launch ContainerLab `rout-bgp571.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp571.yml  
        ```
        4. Destroy ContainerLab `rout-bgp571.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp571.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp571.tst` file [here](../tst/rout-bgp571.tst)  
        3. Launch `rout-bgp571.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp571 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp571.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

