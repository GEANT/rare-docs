# Example: p4lang: vlan vpls/ldp with bgp

=== "Topology"

    ![Alt text](../d2/p4lang-rout023/p4lang-rout023.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    bridge 1
     rd 1:1
     rt-both 1:1
     mac-learn
     exit
    vrf def v9
     rd 1:1
     exit
    int lo9
     vrf for v9
     ipv4 addr 10.10.10.227 255.255.255.255
     exit
    int eth1
     vrf for v9
     ipv4 addr 10.11.12.254 255.255.255.0
     exit
    int eth2
     exit
    server dhcp4 eth1
     pool 10.11.12.1 10.11.12.99
     gateway 10.11.12.254
     netmask 255.255.255.0
     dns-server 10.10.10.227
     domain-name p4l
     static 0000.0000.2222 10.11.12.111
     interface eth1
     vrf v9
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.101 255.255.255.255
     ipv6 addr 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int sdn1
     no autostat
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff:ffff::
     ipv6 ena
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int sdn2
     no autostat
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1234:2::1 ffff:ffff::
     ipv6 ena
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int sdn3
     no autostat
     exit
    int sdn3.111
     bridge-gr 1
     exit
    int sdn4
     no autostat
     exit
    int sdn4.222
     bridge-gr 1
     exit
    router bgp4 1
     vrf v1
     address vpls
     local-as 1
     router-id 4.4.4.1
     temp a remote-as 1
     temp a update lo0
     temp a send-comm both
     temp a route-reflect
     neigh 2.2.2.103 temp a
     neigh 2.2.2.104 temp a
     afi-vpls 1:1 bridge 1
     afi-vpls 1:1 update lo0
     exit
    router bgp6 1
     vrf v1
     address vpls
     local-as 1
     router-id 6.6.6.1
     temp a remote-as 1
     temp a update lo0
     temp a send-comm both
     temp a route-reflect
     neigh 4321::103 temp a
     neigh 4321::104 temp a
     exit
    server p4lang p4
     interconnect eth2
     export-vrf v1
     export-br 1
     export-port sdn1 1 10
     export-port sdn2 2 10
     export-port sdn3 3 10
     export-port sdn4 4 10
     vrf v9
     exit
    ipv4 route v1 2.2.2.103 255.255.255.255 1.1.1.2
    ipv4 route v1 2.2.2.104 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    ipv6 route v1 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    ```

    **r2**

    ```
    hostname r2
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    bridge 1
     rd 1:1
     rt-both 1:1
     mac-learn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.103 255.255.255.255
     ipv6 addr 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 3.3.3.103 255.255.255.255
     ipv6 addr 3333::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.3.3 255.255.255.0
     ipv6 addr 1234:3::3 ffff:ffff::
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234:1::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    router bgp4 1
     vrf v1
     address vpls
     local-as 1
     router-id 4.4.4.3
     neigh 2.2.2.101 remote-as 1
     neigh 2.2.2.101 update lo0
     neigh 2.2.2.101 send-comm both
     afi-vpls 1:1 bridge 1
     afi-vpls 1:1 update lo0
     exit
    router bgp6 1
     vrf v1
     address vpls
     local-as 1
     router-id 6.6.6.3
     neigh 4321::101 remote-as 1
     neigh 4321::101 update lo0
     neigh 4321::101 send-comm both
     exit
    ipv4 route v1 1.1.2.0 255.255.255.0 1.1.1.1
    ipv6 route v1 1234:2:: ffff:ffff:: 1234:1::1
    ipv4 route v1 2.2.2.101 255.255.255.255 1.1.1.1
    ipv4 route v1 2.2.2.104 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    ipv6 route v1 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    ipv4 route v1 3.3.3.104 255.255.255.255 1.1.3.4
    ipv4 route v1 3.3.3.105 255.255.255.255 1.1.3.5
    ipv4 route v1 3.3.3.106 255.255.255.255 1.1.3.6
    ipv6 route v1 3333::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::4
    ipv6 route v1 3333::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::5
    ipv6 route v1 3333::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::6
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    bridge 1
     rd 1:1
     rt-both 1:1
     mac-learn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.104 255.255.255.255
     ipv6 addr 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 3.3.3.104 255.255.255.255
     ipv6 addr 3333::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.3.4 255.255.255.0
     ipv6 addr 1234:3::4 ffff:ffff::
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    router bgp4 1
     vrf v1
     address vpls
     local-as 1
     router-id 4.4.4.4
     neigh 2.2.2.101 remote-as 1
     neigh 2.2.2.101 update lo0
     neigh 2.2.2.101 send-comm both
     afi-vpls 1:1 bridge 1
     afi-vpls 1:1 update lo0
     exit
    router bgp6 1
     vrf v1
     address vpls
     local-as 1
     router-id 6.6.6.4
     neigh 4321::101 remote-as 1
     neigh 4321::101 update lo0
     neigh 4321::101 send-comm both
     exit
    ipv4 route v1 1.1.1.0 255.255.255.0 1.1.2.1
    ipv6 route v1 1234:1:: ffff:ffff:: 1234:2::1
    ipv4 route v1 2.2.2.101 255.255.255.255 1.1.2.1
    ipv4 route v1 2.2.2.103 255.255.255.255 1.1.2.1
    ipv6 route v1 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    ipv6 route v1 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    ipv4 route v1 3.3.3.103 255.255.255.255 1.1.3.3
    ipv4 route v1 3.3.3.105 255.255.255.255 1.1.3.5
    ipv4 route v1 3.3.3.106 255.255.255.255 1.1.3.6
    ipv6 route v1 3333::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::3
    ipv6 route v1 3333::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::5
    ipv6 route v1 3333::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::6
    ```

    **r5**

    ```
    hostname r5
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 3.3.3.105 255.255.255.255
     ipv6 addr 3333::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.111
     vrf for v1
     ipv4 addr 1.1.3.5 255.255.255.0
     ipv6 addr 1234:3::5 ffff:ffff::
     exit
    ipv4 route v1 3.3.3.103 255.255.255.255 1.1.3.3
    ipv4 route v1 3.3.3.104 255.255.255.255 1.1.3.4
    ipv4 route v1 3.3.3.106 255.255.255.255 1.1.3.6
    ipv6 route v1 3333::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::3
    ipv6 route v1 3333::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::4
    ipv6 route v1 3333::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::6
    ```

    **r6**

    ```
    hostname r6
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 3.3.3.106 255.255.255.255
     ipv6 addr 3333::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.222
     vrf for v1
     ipv4 addr 1.1.3.6 255.255.255.0
     ipv6 addr 1234:3::6 ffff:ffff::
     exit
    ipv4 route v1 3.3.3.103 255.255.255.255 1.1.3.3
    ipv4 route v1 3.3.3.104 255.255.255.255 1.1.3.4
    ipv4 route v1 3.3.3.105 255.255.255.255 1.1.3.5
    ipv6 route v1 3333::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::3
    ipv6 route v1 3333::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::4
    ipv6 route v1 3333::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::5
    ```

=== "Verification"

    ```
    r1 tping 100 10 2.2.2.101 vrf v1 sou lo0
    r1 tping 100 10 4321::101 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r1 tping 100 10 4321::103 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r1 tping 100 10 4321::104 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.101 vrf v1 sou lo0
    r3 tping 100 10 4321::101 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r3 tping 100 10 4321::103 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r3 tping 100 10 4321::104 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.101 vrf v1 sou lo0
    r4 tping 100 10 4321::101 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r4 tping 100 10 4321::103 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r4 tping 100 10 4321::104 vrf v1 sou lo0
    r5 tping 100 10 3.3.3.103 vrf v1 sou lo0
    r5 tping 100 10 3333::103 vrf v1 sou lo0
    r5 tping 100 10 3.3.3.104 vrf v1 sou lo0
    r5 tping 100 10 3333::104 vrf v1 sou lo0
    r5 tping 100 10 3.3.3.105 vrf v1 sou lo0
    r5 tping 100 10 3333::105 vrf v1 sou lo0
    r5 tping 100 10 3.3.3.106 vrf v1 sou lo0
    r5 tping 100 10 3333::106 vrf v1 sou lo0
    r6 tping 100 10 3.3.3.103 vrf v1 sou lo0
    r6 tping 100 10 3333::103 vrf v1 sou lo0
    r6 tping 100 10 3.3.3.104 vrf v1 sou lo0
    r6 tping 100 10 3333::104 vrf v1 sou lo0
    r6 tping 100 10 3.3.3.105 vrf v1 sou lo0
    r6 tping 100 10 3333::105 vrf v1 sou lo0
    r6 tping 100 10 3.3.3.106 vrf v1 sou lo0
    r6 tping 100 10 3333::106 vrf v1 sou lo0
    r3 tping 100 10 3.3.3.103 vrf v1 sou lo1
    r3 tping 100 10 3333::103 vrf v1 sou lo1
    r3 tping 100 10 3.3.3.104 vrf v1 sou lo1
    r3 tping 100 10 3333::104 vrf v1 sou lo1
    r3 tping 100 10 3.3.3.105 vrf v1 sou lo1
    r3 tping 100 10 3333::105 vrf v1 sou lo1
    r3 tping 100 10 3.3.3.106 vrf v1 sou lo1
    r3 tping 100 10 3333::106 vrf v1 sou lo1
    r4 tping 100 10 3.3.3.103 vrf v1 sou lo1
    r4 tping 100 10 3333::103 vrf v1 sou lo1
    r4 tping 100 10 3.3.3.104 vrf v1 sou lo1
    r4 tping 100 10 3333::104 vrf v1 sou lo1
    r4 tping 100 10 3.3.3.105 vrf v1 sou lo1
    r4 tping 100 10 3333::105 vrf v1 sou lo1
    r4 tping 100 10 3.3.3.106 vrf v1 sou lo1
    r4 tping 100 10 3333::106 vrf v1 sou lo1
    r1 dping sdn . r6 3.3.3.104 vrf v1 sou lo0
    r1 dping sdn . r6 3333::104 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [p4lang-rout023](../clab/p4lang-rout023/p4lang-rout023.yml) file  
        3. Launch ContainerLab `p4lang-rout023.yml` topology:  

        ```
           containerlab deploy --topo p4lang-rout023.yml  
        ```
        4. Destroy ContainerLab `p4lang-rout023.yml` topology:  

        ```
           containerlab destroy --topo p4lang-rout023.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `p4lang-rout023.tst` file [here](../tst/p4lang-rout023.tst)  
        3. Launch `p4lang-rout023.tst` test:  

        ```
           java -jar ../../rtr.jar test tester p4lang-rout023 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `p4lang-rout023.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

