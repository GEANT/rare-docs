# Example: interop9: mpls over pppoe

=== "Topology"

    ![Alt text](../d2/intop9-pppoe03/intop9-pppoe03.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int di1
     enc ppp
     ppp ip4cp open
     ppp ip6cp open
     ppp mplscp open
     ppp ip4cp local 1.1.1.1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff:ffff:ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int eth1
     p2poe server di1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.252
     pseudo v1 lo0 pweompls 2.2.2.3 1234
     exit
    ```

    **r2**

    ```
    hostname r2
    set interfaces ge-0/0/0.0 encapsulation ppp-over-ether
    set interfaces ge-0/0/1.0 encapsulation ppp-over-ether
    set interfaces pp0.0 pppoe-options underlying-interface ge-0/0/0.0
    set interfaces pp0.0 pppoe-options idle-timeout 0
    set interfaces pp0.0 pppoe-options auto-reconnect 1
    set interfaces pp0.0 pppoe-options client
    set interfaces pp0.0 family inet address 1.1.1.2/24
    set interfaces pp0.0 family inet6 address 1234::1:2/64
    set interfaces pp0.0 family mpls
    set interfaces pp0.1 pppoe-options underlying-interface ge-0/0/1.0
    set interfaces pp0.1 pppoe-options idle-timeout 0
    set interfaces pp0.1 pppoe-options auto-reconnect 1
    set interfaces pp0.1 pppoe-options client
    set interfaces pp0.1 family inet address 1.1.2.2/24
    set interfaces pp0.1 family inet6 address 1234::2:2/64
    set interfaces pp0.1 family mpls
    set interfaces lo0.0 family inet address 2.2.2.2/32
    set interfaces lo0.0 family inet6 address 4321::2/128
    set protocols ldp interface pp0.0
    set protocols ldp interface pp0.1
    set protocols mpls interface pp0.0
    set protocols mpls interface pp0.1
    set routing-options rib inet.0 static route 2.2.2.1/32 next-hop 1.1.1.1
    set routing-options rib inet.0 static route 2.2.2.3/32 next-hop 1.1.2.1
    set routing-options rib inet6.0 static route 4321::1/128 next-hop 1234:1::1
    set routing-options rib inet6.0 static route 4321::3/128 next-hop 1234:2::1
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int di1
     enc ppp
     ppp ip4cp open
     ppp ip6cp open
     ppp mplscp open
     ppp ip4cp local 1.1.2.1
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1234:2::1 ffff:ffff:ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int eth1
     p2poe server di1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.252
     pseudo v1 lo0 pweompls 2.2.2.1 1234
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 30 1.1.1.2 vrf v1
    !r1 tping 100 30 1234:1::2 vrf v1
    r3 tping 100 30 1.1.2.2 vrf v1
    !r3 tping 100 30 1234:2::2 vrf v1
    r1 tping 100 30 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 30 2.2.2.3 vrf v1 sou lo0
    !r1 tping 100 30 4321::2 vrf v1 sou lo0
    !r1 tping 100 30 4321::3 vrf v1 sou lo0
    r3 tping 100 30 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 30 2.2.2.1 vrf v1 sou lo0
    !r3 tping 100 30 4321::2 vrf v1 sou lo0
    !r3 tping 100 30 4321::1 vrf v1 sou lo0
    r1 tping 100 40 3.3.3.2 vrf v1
    r3 tping 100 40 3.3.3.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop9-pppoe03](../clab/intop9-pppoe03/intop9-pppoe03.yml) file  
        3. Launch ContainerLab `intop9-pppoe03.yml` topology:  

        ```
           containerlab deploy --topo intop9-pppoe03.yml  
        ```
        4. Destroy ContainerLab `intop9-pppoe03.yml` topology:  

        ```
           containerlab destroy --topo intop9-pppoe03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop9-pppoe03.tst` file [here](../tst/intop9-pppoe03.tst)  
        3. Launch `intop9-pppoe03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop9-pppoe03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop9-pppoe03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

