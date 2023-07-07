# Example: interop9: ldp mp2mp lsp

=== "Topology"

    ![Alt text](../d2/intop9-ldp04/intop9-ldp04.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
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
    int tun1
     tun sou lo0
     tun dest 2.2.2.2
     tun vrf v1
     tun key 1234
     tun mod mp2mpldp
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     exit
    ```

    **r2**

    ```
    hostname r2
    set interfaces ge-0/0/0.0 family inet address 1.1.1.2/24
    set interfaces ge-0/0/0.0 family inet6 address 1234:1::2/64
    set interfaces ge-0/0/0.0 family mpls
    set interfaces ge-0/0/1.0 family inet address 1.1.2.2/24
    set interfaces ge-0/0/1.0 family inet6 address 1234:2::2/64
    set interfaces ge-0/0/1.0 family mpls
    set interfaces lo0.0 family inet address 2.2.2.2/32
    set interfaces lo0.0 family inet6 address 4321::2/128
    set protocols ldp interface ge-0/0/0.0
    set protocols ldp interface ge-0/0/1.0
    set protocols ldp interface lo0.0
    set protocols ldp p2mp
    set protocols mpls interface ge-0/0/0.0
    set protocols mpls interface ge-0/0/1.0
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
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1234:2::1 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    int tun1
     tun sou lo0
     tun dest 2.2.2.2
     tun vrf v1
     tun key 1234
     tun mod mp2mpldp
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.0
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234:1::2 vrf v1
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 10 4321::2 vrf v1 sou lo0
    r3 tping 100 10 1.1.2.2 vrf v1
    r3 tping 100 10 1234:2::2 vrf v1
    r3 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 10 4321::2 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.3 vrf v1 sou lo0
    r1 tping 100 10 4321::3 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r3 tping 100 10 4321::1 vrf v1 sou lo0
    r1 tping 100 10 3.3.3.3 vrf v1 sou tun1
    r3 tping 100 10 3.3.3.1 vrf v1 sou tun1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop9-ldp04](../clab/intop9-ldp04/intop9-ldp04.yml) file  
        3. Launch ContainerLab `intop9-ldp04.yml` topology:  

        ```
           containerlab deploy --topo intop9-ldp04.yml  
        ```
        4. Destroy ContainerLab `intop9-ldp04.yml` topology:  

        ```
           containerlab destroy --topo intop9-ldp04.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop9-ldp04.tst` file [here](../tst/intop9-ldp04.tst)  
        3. Launch `intop9-ldp04.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop9-ldp04 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop9-ldp04.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

