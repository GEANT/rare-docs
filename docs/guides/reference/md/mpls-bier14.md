# Example: bier over broadcast subnet

=== "Topology"

    ![Alt text](../d2/mpls-bier14/mpls-bier14.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    bridge 1
     mac-learn
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.1
     bier 256 10 1
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.1
     bier 256 10 1
     red conn
     exit
    access-list test4
     permit all 2.2.2.1 255.255.255.255 all any all
     exit
    access-list test6
     permit all 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all any all
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int eth3
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     mpls enable
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int tun1
     tun sou lo1
     tun dest 9.9.9.9
     tun doma 2.2.2.1 2.2.2.2 2.2.2.3 2.2.2.4
     tun vrf v1
     tun key 1
     tun mod bier
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     ipv4 access-group-out test4
     no ipv4 unreachables
     exit
    int tun2
     tun sou lo1
     tun dest 9999::9
     tun doma 4321::1 4321::2 4321::3 4321::4
     tun vrf v1
     tun key 1
     tun mod bier
     vrf for v1
     ipv6 addr 4321::1111 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fff0
     ipv6 access-group-out test6
     no ipv6 unreachables
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.2
     bier 256 10 2
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.2
     bier 256 10 2
     red conn
     exit
    access-list test4
     permit all 2.2.2.2 255.255.255.255 all any all
     exit
    access-list test6
     permit all 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all any all
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     mpls enable
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int tun1
     tun sou lo1
     tun dest 9.9.9.9
     tun doma 2.2.2.1 2.2.2.2 2.2.2.3 2.2.2.4
     tun vrf v1
     tun key 2
     tun mod bier
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     ipv4 access-group-out test4
     no ipv4 unreachables
     exit
    int tun2
     tun sou lo1
     tun dest 9999::9
     tun doma 4321::1 4321::2 4321::3 4321::4
     tun vrf v1
     tun key 2
     tun mod bier
     vrf for v1
     ipv6 addr 4321::1112 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fff0
     ipv6 access-group-out test6
     no ipv6 unreachables
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.3
     bier 256 10 3
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.3
     bier 256 10 3
     red conn
     exit
    access-list test4
     permit all 2.2.2.3 255.255.255.255 all any all
     exit
    access-list test6
     permit all 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all any all
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff::
     mpls enable
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int tun1
     tun sou lo1
     tun dest 9.9.9.9
     tun doma 2.2.2.1 2.2.2.2 2.2.2.3 2.2.2.4
     tun vrf v1
     tun key 3
     tun mod bier
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.0
     ipv4 access-group-out test4
     no ipv4 unreachables
     exit
    int tun2
     tun sou lo1
     tun dest 9999::9
     tun doma 4321::1 4321::2 4321::3 4321::4
     tun vrf v1
     tun key 3
     tun mod bier
     vrf for v1
     ipv6 addr 4321::1113 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fff0
     ipv6 access-group-out test6
     no ipv6 unreachables
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.4
     bier 256 10 4
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.4
     bier 256 10 4
     red conn
     exit
    access-list test4
     permit all 2.2.2.4 255.255.255.255 all any all
     exit
    access-list test6
     permit all 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all any all
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.4 255.255.255.0
     ipv6 addr 1234::4 ffff::
     mpls enable
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int tun1
     tun sou lo1
     tun dest 9.9.9.9
     tun doma 2.2.2.1 2.2.2.2 2.2.2.3 2.2.2.4
     tun vrf v1
     tun key 4
     tun mod bier
     vrf for v1
     ipv4 addr 3.3.3.4 255.255.255.0
     ipv4 access-group-out test4
     no ipv4 unreachables
     exit
    int tun2
     tun sou lo1
     tun dest 9999::9
     tun doma 4321::1 4321::2 4321::3 4321::4
     tun vrf v1
     tun key 4
     tun mod bier
     vrf for v1
     ipv6 addr 4321::1114 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fff0
     ipv6 access-group-out test6
     no ipv6 unreachables
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r1 tping 100 20 4321::2 vrf v1 sou lo1
    r1 tping 100 20 2.2.2.3 vrf v1 sou lo1
    r1 tping 100 20 4321::3 vrf v1 sou lo1
    r1 tping 100 20 2.2.2.4 vrf v1 sou lo1
    r1 tping 100 20 4321::4 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r2 tping 100 20 4321::1 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.3 vrf v1 sou lo1
    r2 tping 100 20 4321::3 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.4 vrf v1 sou lo1
    r2 tping 100 20 4321::4 vrf v1 sou lo1
    r3 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r3 tping 100 20 4321::1 vrf v1 sou lo1
    r3 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r3 tping 100 20 4321::2 vrf v1 sou lo1
    r3 tping 100 20 2.2.2.4 vrf v1 sou lo1
    r3 tping 100 20 4321::4 vrf v1 sou lo1
    r4 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r4 tping 100 20 4321::1 vrf v1 sou lo1
    r4 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r4 tping 100 20 4321::2 vrf v1 sou lo1
    r4 tping 100 20 2.2.2.3 vrf v1 sou lo1
    r4 tping 100 20 4321::3 vrf v1 sou lo1
    r1 tping 100 20 3.3.3.2 vrf v1 sou lo1
    r1 tping 100 20 4321::1112 vrf v1 sou lo1
    r1 tping 100 20 3.3.3.3 vrf v1 sou lo1
    r1 tping 100 20 4321::1113 vrf v1 sou lo1
    r1 tping 100 20 3.3.3.4 vrf v1 sou lo1
    r1 tping 100 20 4321::1114 vrf v1 sou lo1
    r2 tping 100 20 3.3.3.1 vrf v1 sou lo1
    r2 tping 100 20 4321::1111 vrf v1 sou lo1
    r2 tping 100 20 3.3.3.3 vrf v1 sou lo1
    r2 tping 100 20 4321::1113 vrf v1 sou lo1
    r2 tping 100 20 3.3.3.4 vrf v1 sou lo1
    r2 tping 100 20 4321::1114 vrf v1 sou lo1
    r3 tping 100 20 3.3.3.1 vrf v1 sou lo1
    r3 tping 100 20 4321::1111 vrf v1 sou lo1
    r3 tping 100 20 3.3.3.2 vrf v1 sou lo1
    r3 tping 100 20 4321::1112 vrf v1 sou lo1
    r3 tping 100 20 3.3.3.4 vrf v1 sou lo1
    r3 tping 100 20 4321::1114 vrf v1 sou lo1
    r4 tping 100 20 3.3.3.1 vrf v1 sou lo1
    r4 tping 100 20 4321::1111 vrf v1 sou lo1
    r4 tping 100 20 3.3.3.2 vrf v1 sou lo1
    r4 tping 100 20 4321::1112 vrf v1 sou lo1
    r4 tping 100 20 3.3.3.3 vrf v1 sou lo1
    r4 tping 100 20 4321::1113 vrf v1 sou lo1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-bier14](../clab/mpls-bier14/mpls-bier14.yml) file  
        3. Launch ContainerLab `mpls-bier14.yml` topology:  

        ```
           containerlab deploy --topo mpls-bier14.yml  
        ```
        4. Destroy ContainerLab `mpls-bier14.yml` topology:  

        ```
           containerlab destroy --topo mpls-bier14.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-bier14.tst` file [here](../tst/mpls-bier14.tst)  
        3. Launch `mpls-bier14.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-bier14 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-bier14.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

