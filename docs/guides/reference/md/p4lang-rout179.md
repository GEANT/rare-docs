# Example: p4lang: vlan nsh

=== "Topology"

    ![Alt text](../d2/p4lang-rout179/p4lang-rout179.svg)

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
     exit
    int sdn1.111
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff:ffff::
     ipv6 ena
     nsh ena
     exit
    int sdn2
     no autostat
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1234:2::1 ffff:ffff::
     ipv6 ena
     nsh ena
     exit
    int sdn3
     no autostat
     vrf for v1
     ipv4 addr 1.1.3.1 255.255.255.0
     ipv6 addr 1234:3::1 ffff:ffff::
     ipv6 ena
     nsh ena
     exit
    int sdn4
     no autostat
     vrf for v1
     ipv4 addr 1.1.4.1 255.255.255.0
     ipv6 addr 1234:4::1 ffff:ffff::
     ipv6 ena
     nsh ena
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
    nsh 1001 122 rou v1
    nsh 1003 122 int sdn1.111 0000.0000.3333
    nsh 1004 122 int sdn2 0000.0000.4444
    nsh 1005 122 int sdn3 0000.0000.5555
    nsh 1006 122 rou v1
    ipv4 route v1 2.2.2.106 255.255.255.255 1.1.4.2
    ipv6 route v1 4321::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::2
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
     ipv4 addr 2.2.2.103 255.255.255.0
     ipv6 addr 4321::103 ffff:ffff::
     exit
    int eth1.111
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234:1::2 ffff:ffff::
     nsh ena
     exit
    ipv4 route v1 1.1.2.0 255.255.255.0 1.1.1.1
    ipv4 route v1 1.1.3.0 255.255.255.0 1.1.1.1
    ipv4 route v1 1.1.4.0 255.255.255.0 1.1.1.1
    ipv6 route v1 1234:2:: ffff:ffff:: 1234:1::1
    ipv6 route v1 1234:3:: ffff:ffff:: 1234:1::1
    ipv6 route v1 1234:4:: ffff:ffff:: 1234:1::1
    access-list test14
     permit 1 any all 2.2.2.101 255.255.255.255 all
     exit
    access-list test16
     permit 58 any all 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    access-list test34
     permit 1 any all 2.2.2.103 255.255.255.255 all
     exit
    access-list test36
     permit 58 any all 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    access-list test44
     permit 1 any all 2.2.2.104 255.255.255.255 all
     exit
    access-list test46
     permit 58 any all 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    access-list test54
     permit 1 any all 2.2.2.105 255.255.255.255 all
     exit
    access-list test56
     permit 58 any all 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    access-list test64
     permit 1 any all 2.2.2.106 255.255.255.255 all
     exit
    access-list test66
     permit 58 any all 4321::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    nsh 1001 123 int eth1.111 0000.0000.1111
    nsh 1003 121 rou v1
    nsh 1004 123 int eth1.111 0000.0000.1111
    nsh 1005 123 int eth1.111 0000.0000.1111
    nsh 1006 123 int eth1.111 0000.0000.1111
    ipv4 pbr v1 test14 v1 nsh 1001 123
    ipv6 pbr v1 test16 v1 nsh 1001 123
    ipv4 pbr v1 test44 v1 nsh 1004 123
    ipv6 pbr v1 test46 v1 nsh 1004 123
    ipv4 pbr v1 test54 v1 nsh 1005 123
    ipv6 pbr v1 test56 v1 nsh 1005 123
    ipv4 pbr v1 test64 v1 nsh 1006 123
    ipv6 pbr v1 test66 v1 nsh 1006 123
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.104 255.255.255.0
     ipv6 addr 4321::104 ffff:ffff::
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1234:2::2 ffff:ffff::
     nsh ena
     exit
    ipv4 route v1 1.1.1.0 255.255.255.0 1.1.2.1
    ipv4 route v1 1.1.3.0 255.255.255.0 1.1.2.1
    ipv4 route v1 1.1.4.0 255.255.255.0 1.1.2.1
    ipv6 route v1 1234:1:: ffff:ffff:: 1234:2::1
    ipv6 route v1 1234:3:: ffff:ffff:: 1234:2::1
    ipv6 route v1 1234:4:: ffff:ffff:: 1234:2::1
    access-list test14
     permit 1 any all 2.2.2.101 255.255.255.255 all
     exit
    access-list test16
     permit 58 any all 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    access-list test34
     permit 1 any all 2.2.2.103 255.255.255.255 all
     exit
    access-list test36
     permit 58 any all 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    access-list test44
     permit 1 any all 2.2.2.104 255.255.255.255 all
     exit
    access-list test46
     permit 58 any all 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    access-list test54
     permit 1 any all 2.2.2.105 255.255.255.255 all
     exit
    access-list test56
     permit 58 any all 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    access-list test64
     permit 1 any all 2.2.2.106 255.255.255.255 all
     exit
    access-list test66
     permit 58 any all 4321::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    nsh 1001 123 int eth1 0000.0000.1111
    nsh 1003 123 int eth1 0000.0000.1111
    nsh 1004 121 rou v1
    nsh 1005 123 int eth1 0000.0000.1111
    nsh 1006 123 int eth1 0000.0000.1111
    ipv4 pbr v1 test14 v1 nsh 1001 123
    ipv6 pbr v1 test16 v1 nsh 1001 123
    ipv4 pbr v1 test34 v1 nsh 1003 123
    ipv6 pbr v1 test36 v1 nsh 1003 123
    ipv4 pbr v1 test54 v1 nsh 1005 123
    ipv6 pbr v1 test56 v1 nsh 1005 123
    ipv4 pbr v1 test64 v1 nsh 1006 123
    ipv6 pbr v1 test66 v1 nsh 1006 123
    ```

    **r5**

    ```
    hostname r5
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.105 255.255.255.0
     ipv6 addr 4321::105 ffff:ffff::
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.3.2 255.255.255.0
     ipv6 addr 1234:3::2 ffff:ffff::
     nsh ena
     exit
    ipv4 route v1 1.1.1.0 255.255.255.0 1.1.3.1
    ipv4 route v1 1.1.2.0 255.255.255.0 1.1.3.1
    ipv4 route v1 1.1.4.0 255.255.255.0 1.1.3.1
    ipv6 route v1 1234:1:: ffff:ffff:: 1234:3::1
    ipv6 route v1 1234:2:: ffff:ffff:: 1234:3::1
    ipv6 route v1 1234:4:: ffff:ffff:: 1234:3::1
    access-list test14
     permit 1 any all 2.2.2.101 255.255.255.255 all
     exit
    access-list test16
     permit 58 any all 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    access-list test34
     permit 1 any all 2.2.2.103 255.255.255.255 all
     exit
    access-list test36
     permit 58 any all 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    access-list test44
     permit 1 any all 2.2.2.104 255.255.255.255 all
     exit
    access-list test46
     permit 58 any all 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    access-list test54
     permit 1 any all 2.2.2.105 255.255.255.255 all
     exit
    access-list test56
     permit 58 any all 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    access-list test64
     permit 1 any all 2.2.2.106 255.255.255.255 all
     exit
    access-list test66
     permit 58 any all 4321::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    nsh 1001 123 int eth1 0000.0000.1111
    nsh 1003 123 int eth1 0000.0000.1111
    nsh 1004 123 int eth1 0000.0000.1111
    nsh 1005 121 rou v1
    nsh 1006 123 int eth1 0000.0000.1111
    ipv4 pbr v1 test14 v1 nsh 1001 123
    ipv6 pbr v1 test16 v1 nsh 1001 123
    ipv4 pbr v1 test34 v1 nsh 1004 123
    ipv6 pbr v1 test36 v1 nsh 1004 123
    ipv4 pbr v1 test44 v1 nsh 1004 123
    ipv6 pbr v1 test46 v1 nsh 1004 123
    ipv4 pbr v1 test64 v1 nsh 1006 123
    ipv6 pbr v1 test66 v1 nsh 1006 123
    ```

    **r6**

    ```
    hostname r6
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.106 255.255.255.0
     ipv6 addr 4321::106 ffff:ffff::
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.4.2 255.255.255.0
     ipv6 addr 1234:4::2 ffff:ffff::
     nsh ena
     exit
    ipv4 route v1 1.1.1.0 255.255.255.0 1.1.4.1
    ipv4 route v1 1.1.2.0 255.255.255.0 1.1.4.1
    ipv4 route v1 1.1.3.0 255.255.255.0 1.1.4.1
    ipv6 route v1 1234:1:: ffff:ffff:: 1234:4::1
    ipv6 route v1 1234:2:: ffff:ffff:: 1234:4::1
    ipv6 route v1 1234:3:: ffff:ffff:: 1234:4::1
    access-list test14
     permit 1 any all 2.2.2.101 255.255.255.255 all
     exit
    access-list test16
     permit 58 any all 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    access-list test34
     permit 1 any all 2.2.2.103 255.255.255.255 all
     exit
    access-list test36
     permit 58 any all 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    access-list test44
     permit 1 any all 2.2.2.104 255.255.255.255 all
     exit
    access-list test46
     permit 58 any all 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    access-list test54
     permit 1 any all 2.2.2.105 255.255.255.255 all
     exit
    access-list test56
     permit 58 any all 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    access-list test64
     permit 1 any all 2.2.2.106 255.255.255.255 all
     exit
    access-list test66
     permit 58 any all 4321::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    nsh 1001 123 int eth1 0000.0000.1111
    nsh 1003 123 int eth1 0000.0000.1111
    nsh 1004 123 int eth1 0000.0000.1111
    nsh 1005 123 int eth1 0000.0000.1111
    ipv4 pbr v1 test14 v1 nsh 1001 123
    ipv6 pbr v1 test16 v1 nsh 1001 123
    ipv4 pbr v1 test34 v1 nsh 1004 123
    ipv6 pbr v1 test36 v1 nsh 1004 123
    ipv4 pbr v1 test44 v1 nsh 1004 123
    ipv6 pbr v1 test46 v1 nsh 1004 123
    ipv4 pbr v1 test54 v1 nsh 1005 123
    ipv6 pbr v1 test56 v1 nsh 1005 123
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
    r3 tping 100 10 2.2.2.101 vrf v1 sou eth1.111
    r3 tping 100 10 4321::101 vrf v1 sou eth1.111
    r3 tping 100 10 2.2.2.103 vrf v1 sou eth1.111
    r3 tping 100 10 4321::103 vrf v1 sou eth1.111
    r3 tping 100 10 2.2.2.104 vrf v1 sou eth1.111
    r3 tping 100 10 4321::104 vrf v1 sou eth1.111
    r3 tping 100 10 2.2.2.105 vrf v1 sou eth1.111
    r3 tping 100 10 4321::105 vrf v1 sou eth1.111
    r3 tping 100 10 2.2.2.106 vrf v1 sou eth1.111
    r3 tping 100 10 4321::106 vrf v1 sou eth1.111
    r4 tping 100 10 2.2.2.101 vrf v1 sou eth1
    r4 tping 100 10 4321::101 vrf v1 sou eth1
    r4 tping 100 10 2.2.2.103 vrf v1 sou eth1
    r4 tping 100 10 4321::103 vrf v1 sou eth1
    r4 tping 100 10 2.2.2.104 vrf v1 sou eth1
    r4 tping 100 10 4321::104 vrf v1 sou eth1
    r4 tping 100 10 2.2.2.105 vrf v1 sou eth1
    r4 tping 100 10 4321::105 vrf v1 sou eth1
    r4 tping 100 10 2.2.2.106 vrf v1 sou eth1
    r4 tping 100 10 4321::106 vrf v1 sou eth1
    r5 tping 100 10 2.2.2.101 vrf v1 sou eth1
    r5 tping 100 10 4321::101 vrf v1 sou eth1
    r5 tping 100 10 2.2.2.103 vrf v1 sou eth1
    r5 tping 100 10 4321::103 vrf v1 sou eth1
    r5 tping 100 10 2.2.2.104 vrf v1 sou eth1
    r5 tping 100 10 4321::104 vrf v1 sou eth1
    r5 tping 100 10 2.2.2.105 vrf v1 sou eth1
    r5 tping 100 10 4321::105 vrf v1 sou eth1
    r5 tping 100 10 2.2.2.106 vrf v1 sou eth1
    r5 tping 100 10 4321::106 vrf v1 sou eth1
    r6 tping 100 10 2.2.2.101 vrf v1 sou eth1
    r6 tping 100 10 4321::101 vrf v1 sou eth1
    r6 tping 100 10 2.2.2.103 vrf v1 sou eth1
    r6 tping 100 10 4321::103 vrf v1 sou eth1
    r6 tping 100 10 2.2.2.104 vrf v1 sou eth1
    r6 tping 100 10 4321::104 vrf v1 sou eth1
    r6 tping 100 10 2.2.2.105 vrf v1 sou eth1
    r6 tping 100 10 4321::105 vrf v1 sou eth1
    r6 tping 100 10 2.2.2.106 vrf v1 sou eth1
    r6 tping 100 10 4321::106 vrf v1 sou eth1
    r1 dping sdn . r6 2.2.2.105 vrf v1 sou lo0
    r1 dping sdn . r6 4321::105 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [p4lang-rout179](../clab/p4lang-rout179/p4lang-rout179.yml) file  
        3. Launch ContainerLab `p4lang-rout179.yml` topology:  

        ```
           containerlab deploy --topo p4lang-rout179.yml  
        ```
        4. Destroy ContainerLab `p4lang-rout179.yml` topology:  

        ```
           containerlab destroy --topo p4lang-rout179.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `p4lang-rout179.tst` file [here](../tst/p4lang-rout179.tst)  
        3. Launch `p4lang-rout179.tst` test:  

        ```
           java -jar ../../rtr.jar test tester p4lang-rout179 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `p4lang-rout179.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

