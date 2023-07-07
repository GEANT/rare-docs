# Example: p4lang: nat

=== "Topology"

    ![Alt text](../d2/p4lang-acl04/p4lang-acl04.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
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
     vrf for v1
     ipv4 addr 1.1.3.1 255.255.255.0
     ipv6 addr 1234:3::1 ffff:ffff::
     ipv6 ena
     exit
    int sdn4
     no autostat
     vrf for v1
     ipv4 addr 1.1.4.1 255.255.255.0
     ipv6 addr 1234:4::1 ffff:ffff::
     ipv6 ena
     exit
    server p4lang p4
     interconnect eth2
     export-vrf v1
     export-port sdn1 1 10
     export-port sdn2 2 10
     export-port sdn3 3 10
     export-port sdn4 4 10
     vrf v9
     exit
    ipv4 route v1 2.2.2.103 255.255.255.255 1.1.1.2
    ipv4 route v1 2.2.2.104 255.255.255.255 1.1.2.2
    ipv4 route v1 2.2.2.105 255.255.255.255 1.1.3.2
    ipv4 route v1 2.2.2.106 255.255.255.255 1.1.4.2
    ipv6 route v1 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    ipv6 route v1 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    ipv6 route v1 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::2
    ipv6 route v1 4321::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::2
    access-list test4
     permit 17 2.2.2.0 255.255.255.0 all 2.2.2.0 255.255.255.0 all
     permit 6 2.2.2.0 255.255.255.0 all 2.2.2.0 255.255.255.0 all
     deny all any all any all
     exit
    access-list test6
     permit 17 4321:: ffff:: all 4321:: ffff:: all
     permit 6 4321:: ffff:: all 4321:: ffff:: all
     deny all any all any all
     exit
    ipv4 nat v1 srclist test4 interface lo0
    ipv6 nat v1 srclist test6 interface lo0
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
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.103 255.255.255.255
     ipv6 addr 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234:1::2 ffff:ffff::
     exit
    ipv4 route v1 1.1.2.0 255.255.255.0 1.1.1.1
    ipv4 route v1 1.1.3.0 255.255.255.0 1.1.1.1
    ipv4 route v1 1.1.4.0 255.255.255.0 1.1.1.1
    ipv6 route v1 1234:2:: ffff:ffff:: 1234:1::1
    ipv6 route v1 1234:3:: ffff:ffff:: 1234:1::1
    ipv6 route v1 1234:4:: ffff:ffff:: 1234:1::1
    ipv4 route v1 2.2.2.101 255.255.255.255 1.1.1.1
    ipv4 route v1 2.2.2.104 255.255.255.255 1.1.1.1
    ipv4 route v1 2.2.2.105 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    ipv6 route v1 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    ipv6 route v1 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.104 255.255.255.255
     ipv6 addr 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1234:2::2 ffff:ffff::
     exit
    ipv4 route v1 1.1.1.0 255.255.255.0 1.1.2.1
    ipv4 route v1 1.1.3.0 255.255.255.0 1.1.2.1
    ipv4 route v1 1.1.4.0 255.255.255.0 1.1.2.1
    ipv6 route v1 1234:1:: ffff:ffff:: 1234:2::1
    ipv6 route v1 1234:3:: ffff:ffff:: 1234:2::1
    ipv6 route v1 1234:4:: ffff:ffff:: 1234:2::1
    ipv4 route v1 2.2.2.101 255.255.255.255 1.1.2.1
    ipv4 route v1 2.2.2.103 255.255.255.255 1.1.2.1
    ipv4 route v1 2.2.2.105 255.255.255.255 1.1.2.1
    ipv6 route v1 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    ipv6 route v1 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    ipv6 route v1 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    ```

    **r5**

    ```
    hostname r5
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.105 255.255.255.255
     ipv6 addr 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.3.2 255.255.255.0
     ipv6 addr 1234:3::2 ffff:ffff::
     exit
    ipv4 route v1 1.1.1.0 255.255.255.0 1.1.3.1
    ipv4 route v1 1.1.2.0 255.255.255.0 1.1.3.1
    ipv4 route v1 1.1.4.0 255.255.255.0 1.1.3.1
    ipv6 route v1 1234:1:: ffff:ffff:: 1234:3::1
    ipv6 route v1 1234:2:: ffff:ffff:: 1234:3::1
    ipv6 route v1 1234:4:: ffff:ffff:: 1234:3::1
    ipv4 route v1 2.2.2.101 255.255.255.255 1.1.3.1
    ipv4 route v1 2.2.2.103 255.255.255.255 1.1.3.1
    ipv4 route v1 2.2.2.104 255.255.255.255 1.1.3.1
    ipv6 route v1 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::1
    ipv6 route v1 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::1
    ipv6 route v1 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::1
    ipv4 pool p4 3.3.3.1 0.0.0.1 254
    int di1
     enc ppp
     vrf for v1
     ipv4 addr 3.3.3.0 255.255.255.255
     ppp ip4cp local 3.3.3.0
     ipv4 pool p4
     ppp ip4cp open
     exit
    server pckoudp pou
     clone di1
     port 4552
     vrf v1
     exit
    server pckotcp pou
     clone di1
     port 4552
     vrf v1
     exit
    ```

    **r6**

    ```
    hostname r6
    vrf def v1
     rd 1:1
     exit
    vrf def v2
     rd 1:1
     exit
    vrf def v3
     rd 1:1
     exit
    vrf def v4
     rd 1:1
     exit
    vrf def v5
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.106 255.255.255.255
     ipv6 addr 4321::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.4.2 255.255.255.0
     ipv6 addr 1234:4::2 ffff:ffff::
     exit
    ipv4 route v1 1.1.1.0 255.255.255.0 1.1.4.1
    ipv4 route v1 1.1.2.0 255.255.255.0 1.1.4.1
    ipv4 route v1 1.1.3.0 255.255.255.0 1.1.4.1
    ipv6 route v1 1234:1:: ffff:ffff:: 1234:4::1
    ipv6 route v1 1234:2:: ffff:ffff:: 1234:4::1
    ipv6 route v1 1234:3:: ffff:ffff:: 1234:4::1
    ipv4 route v1 2.2.2.101 255.255.255.255 1.1.4.1
    ipv4 route v1 2.2.2.103 255.255.255.255 1.1.4.1
    ipv4 route v1 2.2.2.104 255.255.255.255 1.1.4.1
    ipv4 route v1 2.2.2.105 255.255.255.255 1.1.4.1
    ipv6 route v1 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::1
    ipv6 route v1 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::1
    ipv6 route v1 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::1
    ipv6 route v1 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::1
    proxy-profile p1
     vrf v1
     sou lo0
     exit
    int di1
     enc ppp
     vrf for v2
     ipv4 addr 3.3.3.3 255.255.255.128
     ppp ip4cp open
     ppp ip4cp local 0.0.0.0
     exit
    vpdn di1
     int di1
     proxy p1
     tar 2.2.2.105
     vcid 4552
     prot pckoudp
     exit
    int di2
     enc ppp
     vrf for v3
     ipv4 addr 3.3.3.3 255.255.255.128
     ppp ip4cp open
     ppp ip4cp local 0.0.0.0
     exit
    vpdn di2
     int di2
     proxy p1
     tar 4321::105
     vcid 4552
     prot pckoudp
     exit
    int di3
     enc ppp
     vrf for v4
     ipv4 addr 3.3.3.3 255.255.255.128
     ppp ip4cp open
     ppp ip4cp local 0.0.0.0
     exit
    vpdn di3
     int di3
     proxy p1
     tar 2.2.2.105
     vcid 4552
     prot pckotcp
     exit
    int di4
     enc ppp
     vrf for v5
     ipv4 addr 3.3.3.3 255.255.255.128
     ppp ip4cp open
     ppp ip4cp local 0.0.0.0
     exit
    vpdn di4
     int di4
     proxy p1
     tar 4321::105
     vcid 4552
     prot pckotcp
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234:1::2 vrf v1
    r1 tping 100 10 1.1.2.2 vrf v1
    r1 tping 100 10 1234:2::2 vrf v1
    r1 tping 100 10 1.1.3.2 vrf v1
    r1 tping 100 10 1234:3::2 vrf v1
    r1 tping 100 10 1.1.4.2 vrf v1
    r1 tping 100 10 1234:4::2 vrf v1
    r3 tping 100 10 1.1.1.2 vrf v1
    r3 tping 100 10 1234:1::2 vrf v1
    r3 tping 100 10 1.1.2.2 vrf v1
    r3 tping 100 10 1234:2::2 vrf v1
    r3 tping 100 10 1.1.3.2 vrf v1
    r3 tping 100 10 1234:3::2 vrf v1
    r3 tping 100 10 1.1.4.2 vrf v1
    r3 tping 100 10 1234:4::2 vrf v1
    r4 tping 100 10 1.1.1.2 vrf v1
    r4 tping 100 10 1234:1::2 vrf v1
    r4 tping 100 10 1.1.2.2 vrf v1
    r4 tping 100 10 1234:2::2 vrf v1
    r4 tping 100 10 1.1.3.2 vrf v1
    r4 tping 100 10 1234:3::2 vrf v1
    r4 tping 100 10 1.1.4.2 vrf v1
    r4 tping 100 10 1234:4::2 vrf v1
    r5 tping 100 10 1.1.1.2 vrf v1
    r5 tping 100 10 1234:1::2 vrf v1
    r5 tping 100 10 1.1.2.2 vrf v1
    r5 tping 100 10 1234:2::2 vrf v1
    r5 tping 100 10 1.1.3.2 vrf v1
    r5 tping 100 10 1234:3::2 vrf v1
    r5 tping 100 10 1.1.4.2 vrf v1
    r5 tping 100 10 1234:4::2 vrf v1
    r6 tping 100 10 1.1.1.2 vrf v1
    r6 tping 100 10 1234:1::2 vrf v1
    r6 tping 100 10 1.1.2.2 vrf v1
    r6 tping 100 10 1234:2::2 vrf v1
    r6 tping 100 10 1.1.3.2 vrf v1
    r6 tping 100 10 1234:3::2 vrf v1
    r6 tping 100 10 1.1.4.2 vrf v1
    r6 tping 100 10 1234:4::2 vrf v1
    r6 tping 100 10 3.3.3.0 vrf v2
    r6 tping 100 10 3.3.3.0 vrf v3
    r6 tping 100 10 3.3.3.0 vrf v4
    r6 tping 100 10 3.3.3.0 vrf v5
    r1 tping 100 10 2.2.2.101 vrf v1 sou lo0
    r1 tping 100 10 4321::101 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r1 tping 100 10 4321::103 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r1 tping 100 10 4321::104 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.105 vrf v1 sou lo0
    r1 tping 100 10 4321::105 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.106 vrf v1 sou lo0
    r1 tping 100 10 4321::106 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.101 vrf v1 sou lo0
    r3 tping 100 10 4321::101 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r3 tping 100 10 4321::103 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r3 tping 100 10 4321::104 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.105 vrf v1 sou lo0
    r3 tping 100 10 4321::105 vrf v1 sou lo0
    r3 tping 0 10 2.2.2.106 vrf v1 sou lo0
    r3 tping 0 10 4321::106 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.101 vrf v1 sou lo0
    r4 tping 100 10 4321::101 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r4 tping 100 10 4321::103 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r4 tping 100 10 4321::104 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.105 vrf v1 sou lo0
    r4 tping 100 10 4321::105 vrf v1 sou lo0
    r4 tping 0 10 2.2.2.106 vrf v1 sou lo0
    r4 tping 0 10 4321::106 vrf v1 sou lo0
    r5 tping 100 10 2.2.2.101 vrf v1 sou lo0
    r5 tping 100 10 4321::101 vrf v1 sou lo0
    r5 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r5 tping 100 10 4321::103 vrf v1 sou lo0
    r5 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r5 tping 100 10 4321::104 vrf v1 sou lo0
    r5 tping 100 10 2.2.2.105 vrf v1 sou lo0
    r5 tping 100 10 4321::105 vrf v1 sou lo0
    r5 tping 0 10 2.2.2.106 vrf v1 sou lo0
    r5 tping 0 10 4321::106 vrf v1 sou lo0
    r6 tping 100 10 3.3.3.0 vrf v2
    r6 tping 100 10 3.3.3.0 vrf v3
    r6 tping 100 10 3.3.3.0 vrf v4
    r6 tping 100 10 3.3.3.0 vrf v5
    r1 dping sdn . r6 3.3.3.0 vrf v2
    r1 dping sdn . r6 3.3.3.0 vrf v3
    !r1 dping sdn . r6 3.3.3.0 vrf v4
    !r1 dping sdn . r6 3.3.3.0 vrf v5
    r1 output show ipv4 nat v1 tra
    r1 output show ipv6 nat v1 tra
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [p4lang-acl04](../clab/p4lang-acl04/p4lang-acl04.yml) file  
        3. Launch ContainerLab `p4lang-acl04.yml` topology:  

        ```
           containerlab deploy --topo p4lang-acl04.yml  
        ```
        4. Destroy ContainerLab `p4lang-acl04.yml` topology:  

        ```
           containerlab destroy --topo p4lang-acl04.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `p4lang-acl04.tst` file [here](../tst/p4lang-acl04.tst)  
        3. Launch `p4lang-acl04.tst` test:  

        ```
           java -jar ../../rtr.jar test tester p4lang-acl04 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `p4lang-acl04.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

