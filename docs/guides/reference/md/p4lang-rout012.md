# Example: p4lang: vpn with bgp over srv6

=== "Topology"

    ![Alt text](../d2/p4lang-rout012/p4lang-rout012.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    vrf def v2
     rd 1:2
     rt-both 1:2
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
    int lo1
     vrf for v2
     ipv4 addr 3.3.3.101 255.255.255.255
     ipv6 addr 3333::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int sdn1
     no autostat
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff:ffff::
     ipv6 ena
     exit
    int sdn2
     no autostat
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1234:2::1 ffff:ffff::
     ipv6 ena
     exit
    int sdn3
     no autostat
     vrf for v2
     ipv4 addr 1.1.3.1 255.255.255.0
     ipv6 addr 1234:3::1 ffff:ffff::
     ipv6 ena
     exit
    int sdn4
     no autostat
     vrf for v2
     ipv4 addr 1.1.4.1 255.255.255.0
     ipv6 addr 1234:4::1 ffff:ffff::
     ipv6 ena
     exit
    int tun1
     vrf for v1
     ipv6 addr 4444:1:: ffff:ffff::
     tun sour sdn1
     tun dest 4444:1::
     tun vrf v1
     tun mod srv6
     exit
    router bgp4 1
     vrf v1
     address vpnuni
     local-as 1
     router-id 4.4.4.1
     temp a remote-as 1
     temp a update lo0
     temp a send-comm both
     temp a segrou
     temp a route-reflect
     neigh 2.2.2.103 temp a
     neigh 2.2.2.104 temp a
     afi-vrf v2 ena
     afi-vrf v2 srv6 tun1
     afi-vrf v2 red conn
     afi-vrf v2 red stat
     exit
    router bgp6 1
     vrf v1
     address vpnuni
     local-as 1
     router-id 6.6.6.1
     temp a remote-as 1
     temp a update lo0
     temp a send-comm both
     temp a segrou
     temp a route-reflect
     neigh 4321::103 temp a
     neigh 4321::104 temp a
     afi-vrf v2 ena
     afi-vrf v2 srv6 tun1
     afi-vrf v2 red conn
     afi-vrf v2 red stat
     exit
    server p4lang p4
     interconnect eth2
     export-vrf v1
     export-vrf v2
     export-srv6 tun1
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
    ipv4 route v2 3.3.3.105 255.255.255.255 1.1.3.2
    ipv4 route v2 3.3.3.106 255.255.255.255 1.1.4.2
    ipv6 route v2 3333::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::2
    ipv6 route v2 3333::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::2
    ipv6 route v1 4444:3:: ffff:ffff:: 1234:1::2
    ipv6 route v1 4444:4:: ffff:ffff:: 1234:2::2
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
    vrf def v2
     rd 1:2
     rt-both 1:2
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.103 255.255.255.255
     ipv6 addr 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v2
     ipv4 addr 3.3.3.103 255.255.255.255
     ipv6 addr 3333::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234:1::2 ffff:ffff::
     exit
    int tun1
     vrf for v1
     ipv6 addr 4444:3:: ffff:ffff::
     tun sour eth1
     tun dest 4444:3::
     tun vrf v1
     tun mod srv6
     exit
    router bgp4 1
     vrf v1
     address vpnuni
     local-as 1
     router-id 4.4.4.3
     neigh 2.2.2.101 remote-as 1
     neigh 2.2.2.101 update lo0
     neigh 2.2.2.101 send-comm both
     neigh 2.2.2.101 segrou
     afi-vrf v2 ena
     afi-vrf v2 srv6 tun1
     afi-vrf v2 red conn
     afi-vrf v2 red stat
     exit
    router bgp6 1
     vrf v1
     address vpnuni
     local-as 1
     router-id 6.6.6.3
     neigh 4321::101 remote-as 1
     neigh 4321::101 update lo0
     neigh 4321::101 send-comm both
     neigh 4321::101 segrou
     afi-vrf v2 ena
     afi-vrf v2 srv6 tun1
     afi-vrf v2 red conn
     afi-vrf v2 red stat
     exit
    ipv4 route v1 1.1.2.0 255.255.255.0 1.1.1.1
    ipv6 route v1 1234:2:: ffff:ffff:: 1234:1::1
    ipv4 route v1 2.2.2.101 255.255.255.255 1.1.1.1
    ipv4 route v1 2.2.2.104 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    ipv6 route v1 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    ipv6 route v1 4444:1:: ffff:ffff:: 1234:1::1
    ipv6 route v1 4444:4:: ffff:ffff:: 1234:1::1
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    vrf def v2
     rd 1:2
     rt-both 1:2
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.104 255.255.255.255
     ipv6 addr 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v2
     ipv4 addr 3.3.3.104 255.255.255.255
     ipv6 addr 3333::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1234:2::2 ffff:ffff::
     exit
    int tun1
     vrf for v1
     ipv6 addr 4444:4:: ffff:ffff::
     tun sour eth1
     tun dest 4444:4::
     tun vrf v1
     tun mod srv6
     exit
    router bgp4 1
     vrf v1
     address vpnuni
     local-as 1
     router-id 4.4.4.4
     neigh 2.2.2.101 remote-as 1
     neigh 2.2.2.101 update lo0
     neigh 2.2.2.101 send-comm both
     neigh 2.2.2.101 segrou
     afi-vrf v2 ena
     afi-vrf v2 srv6 tun1
     afi-vrf v2 red conn
     afi-vrf v2 red stat
     exit
    router bgp6 1
     vrf v1
     address vpnuni
     local-as 1
     router-id 6.6.6.4
     neigh 4321::101 remote-as 1
     neigh 4321::101 update lo0
     neigh 4321::101 send-comm both
     neigh 4321::101 segrou
     afi-vrf v2 ena
     afi-vrf v2 srv6 tun1
     afi-vrf v2 red conn
     afi-vrf v2 red stat
     exit
    ipv4 route v1 1.1.1.0 255.255.255.0 1.1.2.1
    ipv6 route v1 1234:1:: ffff:ffff:: 1234:2::1
    ipv4 route v1 2.2.2.101 255.255.255.255 1.1.2.1
    ipv4 route v1 2.2.2.103 255.255.255.255 1.1.2.1
    ipv6 route v1 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    ipv6 route v1 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    ipv6 route v1 4444:1:: ffff:ffff:: 1234:2::1
    ipv6 route v1 4444:3:: ffff:ffff:: 1234:2::1
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
    int eth1
     vrf for v1
     ipv4 addr 1.1.3.2 255.255.255.0
     ipv6 addr 1234:3::2 ffff:ffff::
     exit
    ipv4 route v1 1.1.4.0 255.255.255.0 1.1.3.1
    ipv6 route v1 1234:4:: ffff:ffff:: 1234:3::1
    ipv4 route v1 3.3.3.101 255.255.255.255 1.1.3.1
    ipv4 route v1 3.3.3.103 255.255.255.255 1.1.3.1
    ipv4 route v1 3.3.3.104 255.255.255.255 1.1.3.1
    ipv4 route v1 3.3.3.106 255.255.255.255 1.1.3.1
    ipv6 route v1 3333::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::1
    ipv6 route v1 3333::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::1
    ipv6 route v1 3333::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::1
    ipv6 route v1 3333::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::1
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
    int eth1
     vrf for v1
     ipv4 addr 1.1.4.2 255.255.255.0
     ipv6 addr 1234:4::2 ffff:ffff::
     exit
    ipv4 route v1 1.1.3.0 255.255.255.0 1.1.4.1
    ipv6 route v1 1234:3:: ffff:ffff:: 1234:4::1
    ipv4 route v1 3.3.3.101 255.255.255.255 1.1.4.1
    ipv4 route v1 3.3.3.103 255.255.255.255 1.1.4.1
    ipv4 route v1 3.3.3.104 255.255.255.255 1.1.4.1
    ipv4 route v1 3.3.3.105 255.255.255.255 1.1.4.1
    ipv6 route v1 3333::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::1
    ipv6 route v1 3333::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::1
    ipv6 route v1 3333::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::1
    ipv6 route v1 3333::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::1
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
    r1 tping 100 10 3.3.3.101 vrf v2 sou lo1
    r1 tping 100 10 3333::101 vrf v2 sou lo1
    r1 tping 100 10 3.3.3.103 vrf v2 sou lo1
    r1 tping 100 10 3333::103 vrf v2 sou lo1
    r1 tping 100 10 3.3.3.104 vrf v2 sou lo1
    r1 tping 100 10 3333::104 vrf v2 sou lo1
    r1 tping 100 10 3.3.3.105 vrf v2 sou lo1
    r1 tping 100 10 3333::105 vrf v2 sou lo1
    r1 tping 100 10 3.3.3.106 vrf v2 sou lo1
    r1 tping 100 10 3333::106 vrf v2 sou lo1
    r3 tping 100 10 3.3.3.101 vrf v2 sou lo1
    r3 tping 100 10 3333::101 vrf v2 sou lo1
    r3 tping 100 10 3.3.3.103 vrf v2 sou lo1
    r3 tping 100 10 3333::103 vrf v2 sou lo1
    r3 tping 100 10 3.3.3.104 vrf v2 sou lo1
    r3 tping 100 10 3333::104 vrf v2 sou lo1
    r3 tping 100 10 3.3.3.105 vrf v2 sou lo1
    r3 tping 100 10 3333::105 vrf v2 sou lo1
    r3 tping 100 10 3.3.3.106 vrf v2 sou lo1
    r3 tping 100 10 3333::106 vrf v2 sou lo1
    r4 tping 100 10 3.3.3.101 vrf v2 sou lo1
    r4 tping 100 10 3333::101 vrf v2 sou lo1
    r4 tping 100 10 3.3.3.103 vrf v2 sou lo1
    r4 tping 100 10 3333::103 vrf v2 sou lo1
    r4 tping 100 10 3.3.3.104 vrf v2 sou lo1
    r4 tping 100 10 3333::104 vrf v2 sou lo1
    r4 tping 100 10 3.3.3.105 vrf v2 sou lo1
    r4 tping 100 10 3333::105 vrf v2 sou lo1
    r4 tping 100 10 3.3.3.106 vrf v2 sou lo1
    r4 tping 100 10 3333::106 vrf v2 sou lo1
    r5 tping 100 10 3.3.3.101 vrf v1 sou lo0
    r5 tping 100 10 3333::101 vrf v1 sou lo0
    r5 tping 100 10 3.3.3.103 vrf v1 sou lo0
    r5 tping 100 10 3333::103 vrf v1 sou lo0
    r5 tping 100 10 3.3.3.104 vrf v1 sou lo0
    r5 tping 100 10 3333::104 vrf v1 sou lo0
    r5 tping 100 10 3.3.3.105 vrf v1 sou lo0
    r5 tping 100 10 3333::105 vrf v1 sou lo0
    r5 tping 100 10 3.3.3.106 vrf v1 sou lo0
    r5 tping 100 10 3333::106 vrf v1 sou lo0
    r6 tping 100 10 3.3.3.101 vrf v1 sou lo0
    r6 tping 100 10 3333::101 vrf v1 sou lo0
    r6 tping 100 10 3.3.3.103 vrf v1 sou lo0
    r6 tping 100 10 3333::103 vrf v1 sou lo0
    r6 tping 100 10 3.3.3.104 vrf v1 sou lo0
    r6 tping 100 10 3333::104 vrf v1 sou lo0
    r6 tping 100 10 3.3.3.105 vrf v1 sou lo0
    r6 tping 100 10 3333::105 vrf v1 sou lo0
    r6 tping 100 10 3.3.3.106 vrf v1 sou lo0
    r6 tping 100 10 3333::106 vrf v1 sou lo0
    r1 dping sdn . r6 3.3.3.104 vrf v1 sou lo0
    r1 dping sdn . r6 3333::104 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [p4lang-rout012](../clab/p4lang-rout012/p4lang-rout012.yml) file  
        3. Launch ContainerLab `p4lang-rout012.yml` topology:  

        ```
           containerlab deploy --topo p4lang-rout012.yml  
        ```
        4. Destroy ContainerLab `p4lang-rout012.yml` topology:  

        ```
           containerlab destroy --topo p4lang-rout012.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `p4lang-rout012.tst` file [here](../tst/p4lang-rout012.tst)  
        3. Launch `p4lang-rout012.tst` test:  

        ```
           java -jar ../../rtr.jar test tester p4lang-rout012 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `p4lang-rout012.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

