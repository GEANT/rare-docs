# Example: cross connect with everything

=== "Topology"

    ![Alt text](../d2/mpls-xconn20/mpls-xconn20.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.255
     ipv6 addr 3333::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    proxy-profile p2
     vrf v1
     source lo0
     exit
    proxy-profile p1
     vrf v1
     exit
    bridge 1
     mac-learn
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff:ffff::
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     exit
    vpdn l2tp
     bridge-gr 1
     proxy p1
     tar 1.1.1.2
     vcid 1234
     dir out
     pwt eth
     prot l2tp3
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 3.3.3.3 255.255.255.255 1.1.1.6
    ipv6 route v1 3333::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    vpdn eompls
     bridge-gr 1
     proxy p2
     target 3.3.3.3
     mtu 1500
     vcid 1234
     pwtype eth
     protocol pweompls
     exit
    int eth3
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     ipv6 addr 1234:3::1 ffff:ffff::
     exit
    vpdn pou
     bridge-gr 1
     proxy p1
     target 1.1.1.10
     vcid 1234
     protocol pckoudp
     exit
    int eth4
     vrf for v1
     ipv4 addr 1.1.1.13 255.255.255.252
     ipv6 addr 1234:4::1 ffff:ffff::
     exit
    vpdn vxl
     bridge-gr 1
     proxy p1
     tar 1.1.1.14
     vcid 1234
     prot vxlan
     exit
    int eth5
     vrf for v1
     ipv4 addr 1.1.1.17 255.255.255.252
     ipv6 addr 1234:5::1 ffff:ffff::
     exit
    vpdn gnv
     bridge-gr 1
     proxy p1
     tar 1.1.1.18
     vcid 1234
     prot geneve
     exit
    int eth6
     vrf for v1
     ipv4 addr 1.1.1.21 255.255.255.252
     ipv6 addr 1234:6::1 ffff:ffff::
     exit
    vpdn rspn
     bridge-gr 1
     proxy p1
     tar 1.1.1.22
     vcid 123
     prot erspan
     exit
    int eth7
     vrf for v1
     ipv4 addr 1.1.1.25 255.255.255.252
     ipv6 addr 1234:7::1 ffff:ffff::
     exit
    vpdn eip
     bridge-gr 1
     proxy p1
     tar 1.1.1.26
     vcid 1234
     prot etherip
     exit
    int eth8
     vrf for v1
     ipv4 addr 1.1.1.29 255.255.255.252
     ipv6 addr 1234:8::1 ffff:ffff::
     exit
    vpdn ngr
     bridge-gr 1
     proxy p1
     tar 1.1.1.30
     vcid 1234
     prot nvgre
     exit
    int eth9
     vrf for v1
     ipv4 addr 1.1.1.33 255.255.255.252
     ipv6 addr 1234:9::1 ffff:ffff::
     exit
    vpdn uti
     bridge-gr 1
     proxy p1
     tar 1.1.1.34
     vcid 1234
     prot uti
     exit
    int eth10
     vrf for v1
     ipv4 addr 1.1.1.37 255.255.255.252
     ipv6 addr 1234:10::1 ffff:ffff::
     exit
    vpdn dlsw
     bridge-gr 1
     proxy p1
     tar 1.1.1.38
     vcid 1234
     prot dlsw
     exit
    int eth11
     vrf for v1
     ipv4 addr 1.1.1.41 255.255.255.252
     ipv6 addr 1234:11::1 ffff:ffff::
     exit
    vpdn capwap
     bridge-gr 1
     proxy p1
     tar 1.1.1.42
     prot capwap
     exit
    int eth12
     vrf for v1
     ipv4 addr 1.1.1.45 255.255.255.252
     ipv6 addr 1234:12::1 ffff:ffff::
     exit
    vpdn lwapp
     bridge-gr 1
     proxy p1
     tar 1.1.1.46
     prot lwapp
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     exit
    bridge 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff:ffff::
     exit
    vpdn l2tp
     bridge-gr 1
     proxy p1
     tar 1.1.1.1
     vcid 1234
     dir in
     pwt eth
     prot l2tp3
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.255
     ipv6 addr 3333::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    proxy-profile p1
     vrf v1
     source lo0
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    bridge 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.0
     ipv6 addr 4321::3 ffff:ffff::
     exit
    ipv4 route v1 3.3.3.1 255.255.255.255 1.1.1.5
    ipv6 route v1 3333::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    vpdn eompls
     bridge-gr 1
     proxy p1
     target 3.3.3.1
     mtu 1500
     vcid 1234
     pwtype eth
     protocol pweompls
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.10 255.255.255.252
     ipv6 addr 1234:3::2 ffff:ffff::
     exit
    bridge 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.0
     ipv6 addr 4321::4 ffff:ffff::
     exit
    vpdn pou
     bridge-gr 1
     proxy p1
     target 1.1.1.9
     vcid 1234
     protocol pckoudp
     exit
    ```

    **r5**

    ```
    hostname r5
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.14 255.255.255.252
     ipv6 addr 1234:4::2 ffff:ffff::
     exit
    bridge 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.5 255.255.255.0
     ipv6 addr 4321::5 ffff:ffff::
     exit
    server vxlan vxl
     bridge 1
     vrf v1
     inst 1234
     exit
    ```

    **r6**

    ```
    hostname r6
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.18 255.255.255.252
     ipv6 addr 1234:5::2 ffff:ffff::
     exit
    bridge 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.6 255.255.255.0
     ipv6 addr 4321::6 ffff:ffff::
     exit
    server geneve gnv
     bridge 1
     vrf v1
     vni 1234
     exit
    ```

    **r7**

    ```
    hostname r7
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.22 255.255.255.252
     ipv6 addr 1234:6::2 ffff:ffff::
     exit
    bridge 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.7 255.255.255.0
     ipv6 addr 4321::7 ffff:ffff::
     exit
    vpdn rspn
     bridge-gr 1
     proxy p1
     tar 1.1.1.21
     vcid 123
     prot erspan
     exit
    ```

    **r8**

    ```
    hostname r8
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.26 255.255.255.252
     ipv6 addr 1234:7::2 ffff:ffff::
     exit
    bridge 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.8 255.255.255.0
     ipv6 addr 4321::8 ffff:ffff::
     exit
    vpdn eip
     bridge-gr 1
     proxy p1
     tar 1.1.1.25
     vcid 1234
     prot etherip
     exit
    ```

    **r9**

    ```
    hostname r9
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.30 255.255.255.252
     ipv6 addr 1234:8::2 ffff:ffff::
     exit
    bridge 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.9 255.255.255.0
     ipv6 addr 4321::9 ffff:ffff::
     exit
    vpdn ngr
     bridge-gr 1
     proxy p1
     tar 1.1.1.29
     vcid 1234
     prot nvgre
     exit
    ```

    **r10**

    ```
    hostname r10
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.34 255.255.255.252
     ipv6 addr 1234:9::2 ffff:ffff::
     exit
    bridge 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.10 255.255.255.0
     ipv6 addr 4321::10 ffff:ffff::
     exit
    vpdn uti
     bridge-gr 1
     proxy p1
     tar 1.1.1.33
     vcid 1234
     prot uti
     exit
    ```

    **r11**

    ```
    hostname r11
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.38 255.255.255.252
     ipv6 addr 1234:10::2 ffff:ffff::
     exit
    bridge 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.11 255.255.255.0
     ipv6 addr 4321::11 ffff:ffff::
     exit
    vpdn uti
     bridge-gr 1
     proxy p1
     tar 1.1.1.37
     vcid 1234
     prot dlsw
     exit
    ```

    **r12**

    ```
    hostname r12
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.42 255.255.255.252
     ipv6 addr 1234:11::2 ffff:ffff::
     exit
    bridge 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.12 255.255.255.0
     ipv6 addr 4321::12 ffff:ffff::
     exit
    vpdn uti
     bridge-gr 1
     proxy p1
     tar 1.1.1.41
     prot capwap
     exit
    ```

    **r13**

    ```
    hostname r13
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.46 255.255.255.252
     ipv6 addr 1234:12::2 ffff:ffff::
     exit
    bridge 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.13 255.255.255.0
     ipv6 addr 4321::13 ffff:ffff::
     exit
    vpdn uti
     bridge-gr 1
     proxy p1
     tar 1.1.1.45
     prot lwapp
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 2.2.2.1 vrf v1
    r1 tping 100 10 2.2.2.2 vrf v1
    r1 tping 100 10 2.2.2.3 vrf v1
    r1 tping 100 10 2.2.2.4 vrf v1
    r1 tping 100 10 2.2.2.5 vrf v1
    r1 tping 100 10 2.2.2.6 vrf v1
    r1 tping 100 10 2.2.2.7 vrf v1
    r1 tping 100 10 2.2.2.8 vrf v1
    r1 tping 100 10 2.2.2.9 vrf v1
    r1 tping 100 10 2.2.2.10 vrf v1
    r1 tping 100 10 2.2.2.11 vrf v1
    r1 tping 100 10 2.2.2.12 vrf v1
    r1 tping 100 10 2.2.2.13 vrf v1
    r1 tping 100 10 4321::1 vrf v1
    r1 tping 100 10 4321::2 vrf v1
    r1 tping 100 10 4321::3 vrf v1
    r1 tping 100 10 4321::4 vrf v1
    r1 tping 100 10 4321::5 vrf v1
    r1 tping 100 10 4321::6 vrf v1
    r1 tping 100 10 4321::7 vrf v1
    r1 tping 100 10 4321::8 vrf v1
    r1 tping 100 10 4321::9 vrf v1
    r1 tping 100 10 4321::10 vrf v1
    r1 tping 100 10 4321::11 vrf v1
    r1 tping 100 10 4321::12 vrf v1
    r1 tping 100 10 4321::13 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-xconn20](../clab/mpls-xconn20/mpls-xconn20.yml) file  
        3. Launch ContainerLab `mpls-xconn20.yml` topology:  

        ```
           containerlab deploy --topo mpls-xconn20.yml  
        ```
        4. Destroy ContainerLab `mpls-xconn20.yml` topology:  

        ```
           containerlab destroy --topo mpls-xconn20.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-xconn20.tst` file [here](../tst/mpls-xconn20.tst)  
        3. Launch `mpls-xconn20.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-xconn20 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-xconn20.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

