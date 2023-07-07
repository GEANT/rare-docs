# Example: bgp with srgb sr

=== "Topology"

    ![Alt text](../d2/rout-bgp411/rout-bgp411.svg)

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
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     mpls enable
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     local-as 1
     segrout 10 1 base 100
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 2
     neigh 1.1.1.2 segrout
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     local-as 1
     segrout 10 1 base 200
     router-id 6.6.6.1
     neigh 1234:1::2 remote-as 2
     neigh 1234:1::2 segrout
     red conn
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     mpls enable
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     mpls enable
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     local-as 2
     segrout 10 2 base 100
     router-id 4.4.4.2
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 segrout
     neigh 1.1.1.6 remote-as 3
     neigh 1.1.1.6 segrout
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     local-as 2
     segrout 10 2 base 200
     router-id 6.6.6.2
     neigh 1234:1::1 remote-as 1
     neigh 1234:1::1 segrout
     neigh 1234:2::2 remote-as 3
     neigh 1234:2::2 segrout
     red conn
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls enable
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     ipv6 addr 1234:3::1 ffff:ffff::
     mpls enable
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     local-as 3
     segrout 10 3 base 100
     router-id 4.4.4.3
     neigh 1.1.1.5 remote-as 2
     neigh 1.1.1.5 segrout
     neigh 1.1.1.10 remote-as 4
     neigh 1.1.1.10 segrout
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     local-as 3
     segrout 10 3 base 200
     router-id 6.6.6.3
     neigh 1234:2::1 remote-as 2
     neigh 1234:2::1 segrout
     neigh 1234:3::2 remote-as 4
     neigh 1234:3::2 segrout
     red conn
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.10 255.255.255.252
     ipv6 addr 1234:3::2 ffff:ffff::
     mpls enable
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     local-as 4
     segrout 10 4 base 100
     router-id 4.4.4.4
     neigh 1.1.1.9 remote-as 3
     neigh 1.1.1.9 segrout
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     local-as 4
     segrout 10 4 base 200
     router-id 6.6.6.4
     neigh 1234:3::1 remote-as 3
     neigh 1234:3::1 segrout
     red conn
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.4 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 4321::3 vrf v1 sou lo0
    r1 tping 100 60 4321::4 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.4 vrf v1 sou lo0
    r2 tping 100 60 4321::1 vrf v1 sou lo0
    r2 tping 100 60 4321::3 vrf v1 sou lo0
    r2 tping 100 60 4321::4 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.4 vrf v1 sou lo0
    r3 tping 100 60 4321::1 vrf v1 sou lo0
    r3 tping 100 60 4321::2 vrf v1 sou lo0
    r3 tping 100 60 4321::4 vrf v1 sou lo0
    r4 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r4 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r4 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r4 tping 100 60 4321::1 vrf v1 sou lo0
    r4 tping 100 60 4321::2 vrf v1 sou lo0
    r4 tping 100 60 4321::3 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp411](../clab/rout-bgp411/rout-bgp411.yml) file  
        3. Launch ContainerLab `rout-bgp411.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp411.yml  
        ```
        4. Destroy ContainerLab `rout-bgp411.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp411.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp411.tst` file [here](../tst/rout-bgp411.tst)  
        3. Launch `rout-bgp411.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp411 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp411.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

