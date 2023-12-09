# Example: p4lang: sdwan over ipv6 with l2tp3

=== "Topology"

    ![Alt text](../d2/p4lang-rout278/p4lang-rout278.svg)

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
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.100 255.255.255.255
     ipv6 addr 4321::100 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
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
    aaa userlist usr
     username u password p
     username h password p
     exit
    crypto rsakey rsa generate 2048
    crypto dsakey dsa generate 1024
    crypto ecdsakey ecdsa generate 256
    ipv4 pool p4 2.2.2.222 0.0.0.1 3
    ipv6 pool p6 2222::222 ::1 3
    server sdwan v9
     security authentication usr
     security rsakey rsa
     security dsakey dsa
     security ecdsakey ecdsa
     hub h
     pool4 p4
     pool6 p6
     vrf v1
     exit
    proxy-profile p1
     vrf v1
     source lo1
     exit
    int di1
     enc ppp
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 2222::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    vpdn sdw
     int di1
     target 4321::100
     proxy p1
     user h
     pass p
     pref ipv6
     para l3tp
     proto sdwan
     exit
    server p4lang p4
     interconnect eth2
     export-vrf v1
     export-port sdn1 1 10
     export-port sdn2 2 10
     export-port sdn3 3 10
     export-port sdn4 4 10
     export-port di1 dyn
     vrf v9
     exit
    ipv4 route v1 2.2.2.103 255.255.255.255 2.2.2.3
    ipv4 route v1 2.2.2.104 255.255.255.255 2.2.2.4
    ipv4 route v1 2.2.2.105 255.255.255.255 2.2.2.5
    ipv4 route v1 2.2.2.106 255.255.255.255 2.2.2.6
    ipv6 route v1 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::3
    ipv6 route v1 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::4
    ipv6 route v1 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::5
    ipv6 route v1 4321::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::6
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
    bridge 1
     mac-learn
     block-unicast
     exit
    int eth1
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234:1::2 ffff:ffff::
     exit
    proxy-profile p1
     vrf v1
     exit
    int di1
     enc ppp
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 2222::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    vpdn sdw
     int di1
     target 4321::100
     proxy p1
     user u
     pass p
     pref ipv6
     para l3tp
     proto sdwan
     exit
    ipv4 route v1 1.1.2.0 255.255.255.0 1.1.1.1
    ipv4 route v1 1.1.3.0 255.255.255.0 1.1.1.1
    ipv4 route v1 1.1.4.0 255.255.255.0 1.1.1.1
    ipv6 route v1 1234:2:: ffff:ffff:: 1234:1::1
    ipv6 route v1 1234:3:: ffff:ffff:: 1234:1::1
    ipv6 route v1 1234:4:: ffff:ffff:: 1234:1::1
    ipv4 route v1 2.2.2.100 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::100 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    ipv4 route v1 2.2.2.101 255.255.255.255 2.2.2.1
    ipv4 route v1 2.2.2.104 255.255.255.255 2.2.2.1
    ipv4 route v1 2.2.2.105 255.255.255.255 2.2.2.1
    ipv4 route v1 2.2.2.106 255.255.255.255 2.2.2.1
    ipv6 route v1 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::1
    ipv6 route v1 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::1
    ipv6 route v1 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::1
    ipv6 route v1 4321::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::1
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
    proxy-profile p1
     vrf v1
     exit
    int di1
     enc ppp
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 2222::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    vpdn sdw
     int di1
     target 4321::100
     proxy p1
     user u
     pass p
     pref ipv6
     para l3tp
     proto sdwan
     exit
    ipv4 route v1 1.1.1.0 255.255.255.0 1.1.2.1
    ipv4 route v1 1.1.3.0 255.255.255.0 1.1.2.1
    ipv4 route v1 1.1.4.0 255.255.255.0 1.1.2.1
    ipv6 route v1 1234:1:: ffff:ffff:: 1234:2::1
    ipv6 route v1 1234:3:: ffff:ffff:: 1234:2::1
    ipv6 route v1 1234:4:: ffff:ffff:: 1234:2::1
    ipv4 route v1 2.2.2.100 255.255.255.255 1.1.2.1
    ipv6 route v1 4321::100 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    ipv4 route v1 2.2.2.101 255.255.255.255 2.2.2.1
    ipv4 route v1 2.2.2.103 255.255.255.255 2.2.2.1
    ipv4 route v1 2.2.2.105 255.255.255.255 2.2.2.1
    ipv4 route v1 2.2.2.106 255.255.255.255 2.2.2.1
    ipv6 route v1 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::1
    ipv6 route v1 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::1
    ipv6 route v1 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::1
    ipv6 route v1 4321::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::1
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
    proxy-profile p1
     vrf v1
     exit
    int di1
     enc ppp
     vrf for v1
     ipv4 addr 2.2.2.5 255.255.255.255
     ipv6 addr 2222::5 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    vpdn sdw
     int di1
     target 4321::100
     proxy p1
     user u
     pass p
     pref ipv6
     para l3tp
     proto sdwan
     exit
    ipv4 route v1 1.1.1.0 255.255.255.0 1.1.3.1
    ipv4 route v1 1.1.2.0 255.255.255.0 1.1.3.1
    ipv4 route v1 1.1.4.0 255.255.255.0 1.1.3.1
    ipv6 route v1 1234:1:: ffff:ffff:: 1234:3::1
    ipv6 route v1 1234:2:: ffff:ffff:: 1234:3::1
    ipv6 route v1 1234:4:: ffff:ffff:: 1234:3::1
    ipv4 route v1 2.2.2.100 255.255.255.255 1.1.3.1
    ipv6 route v1 4321::100 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::1
    ipv4 route v1 2.2.2.101 255.255.255.255 2.2.2.1
    ipv4 route v1 2.2.2.103 255.255.255.255 2.2.2.1
    ipv4 route v1 2.2.2.104 255.255.255.255 2.2.2.1
    ipv4 route v1 2.2.2.106 255.255.255.255 2.2.2.1
    ipv6 route v1 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::1
    ipv6 route v1 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::1
    ipv6 route v1 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::1
    ipv6 route v1 4321::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::1
    ```

    **r6**

    ```
    hostname r6
    vrf def v1
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
    proxy-profile p1
     vrf v1
     exit
    int di1
     enc ppp
     vrf for v1
     ipv4 addr 2.2.2.6 255.255.255.255
     ipv6 addr 2222::6 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    vpdn sdw
     int di1
     target 4321::100
     proxy p1
     user u
     pass p
     pref ipv6
     para l3tp
     proto sdwan
     exit
    ipv4 route v1 1.1.1.0 255.255.255.0 1.1.4.1
    ipv4 route v1 1.1.2.0 255.255.255.0 1.1.4.1
    ipv4 route v1 1.1.3.0 255.255.255.0 1.1.4.1
    ipv6 route v1 1234:1:: ffff:ffff:: 1234:4::1
    ipv6 route v1 1234:2:: ffff:ffff:: 1234:4::1
    ipv6 route v1 1234:3:: ffff:ffff:: 1234:4::1
    ipv4 route v1 2.2.2.100 255.255.255.255 1.1.4.1
    ipv6 route v1 4321::100 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::1
    ipv4 route v1 2.2.2.101 255.255.255.255 2.2.2.1
    ipv4 route v1 2.2.2.103 255.255.255.255 2.2.2.1
    ipv4 route v1 2.2.2.104 255.255.255.255 2.2.2.1
    ipv4 route v1 2.2.2.105 255.255.255.255 2.2.2.1
    ipv6 route v1 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::1
    ipv6 route v1 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::1
    ipv6 route v1 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::1
    ipv6 route v1 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2222::1
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
    r3 tping 100 10 2.2.2.106 vrf v1 sou lo0
    r3 tping 100 10 4321::106 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.101 vrf v1 sou lo0
    r4 tping 100 10 4321::101 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r4 tping 100 10 4321::103 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r4 tping 100 10 4321::104 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.105 vrf v1 sou lo0
    r4 tping 100 10 4321::105 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.106 vrf v1 sou lo0
    r4 tping 100 10 4321::106 vrf v1 sou lo0
    r5 tping 100 10 2.2.2.101 vrf v1 sou lo0
    r5 tping 100 10 4321::101 vrf v1 sou lo0
    r5 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r5 tping 100 10 4321::103 vrf v1 sou lo0
    r5 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r5 tping 100 10 4321::104 vrf v1 sou lo0
    r5 tping 100 10 2.2.2.105 vrf v1 sou lo0
    r5 tping 100 10 4321::105 vrf v1 sou lo0
    r5 tping 100 10 2.2.2.106 vrf v1 sou lo0
    r5 tping 100 10 4321::106 vrf v1 sou lo0
    r6 tping 100 10 2.2.2.101 vrf v1 sou lo0
    r6 tping 100 10 4321::101 vrf v1 sou lo0
    r6 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r6 tping 100 10 4321::103 vrf v1 sou lo0
    r6 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r6 tping 100 10 4321::104 vrf v1 sou lo0
    r6 tping 100 10 2.2.2.105 vrf v1 sou lo0
    r6 tping 100 10 4321::105 vrf v1 sou lo0
    r6 tping 100 10 2.2.2.106 vrf v1 sou lo0
    r6 tping 100 10 4321::106 vrf v1 sou lo0
    r1 dping sdn . r6 2.2.2.105 vrf v1 sou lo0
    r1 dping sdn . r6 4321::105 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [p4lang-rout278](../clab/p4lang-rout278/p4lang-rout278.yml) file  
        3. Launch ContainerLab `p4lang-rout278.yml` topology:  

        ```
           containerlab deploy --topo p4lang-rout278.yml  
        ```
        4. Destroy ContainerLab `p4lang-rout278.yml` topology:  

        ```
           containerlab destroy --topo p4lang-rout278.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `p4lang-rout278.tst` file [here](../tst/p4lang-rout278.tst)  
        3. Launch `p4lang-rout278.tst` test:  

        ```
           java -jar ../../rtr.jar test tester p4lang-rout278 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `p4lang-rout278.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

