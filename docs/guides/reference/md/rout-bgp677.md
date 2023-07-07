# Example: other ctp colors over confed bgp

=== "Topology"

    ![Alt text](../d2/rout-bgp677/rout-bgp677.svg)

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
     clr-both 2
     exit
    vrf def v3
     rd 1:3
     clr-both 3
     exit
    vrf def v4
     rd 1:4
     clr-both 4
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v2
     ipv4 addr 9.9.2.1 255.255.255.255
     ipv6 addr 9992::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo3
     vrf for v3
     ipv4 addr 9.9.3.1 255.255.255.255
     ipv6 addr 9993::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo4
     vrf for v4
     ipv4 addr 9.9.4.1 255.255.255.255
     ipv6 addr 9994::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    router bgp4 1
     vrf v1
     no safe-ebgp
     address octp
     local-as 1
     router-id 4.4.4.1
     neigh 2.2.2.2 remote-as 2
     neigh 2.2.2.2 confed
     neigh 2.2.2.2 update lo0
     neigh 2.2.2.2 send-comm both
     afi-other enable
     afi-oclr v2 ena
     afi-oclr v2 red conn
     afi-oclr v3 ena
     afi-oclr v3 red conn
     afi-oclr v4 ena
     afi-oclr v4 red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address octp
     local-as 1
     router-id 6.6.6.1
     neigh 4321::2 remote-as 2
     neigh 4321::2 confed
     neigh 4321::2 update lo0
     neigh 4321::2 send-comm both
     afi-other enable
     afi-oclr v2 ena
     afi-oclr v2 red conn
     afi-oclr v3 ena
     afi-oclr v3 red conn
     afi-oclr v4 ena
     afi-oclr v4 red conn
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    vrf def v2
     rd 1:2
     clr-both 2
     exit
    vrf def v3
     rd 1:3
     clr-both 3
     exit
    vrf def v4
     rd 1:4
     clr-both 4
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v2
     ipv4 addr 9.9.2.2 255.255.255.255
     ipv6 addr 9992::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo3
     vrf for v3
     ipv4 addr 9.9.3.2 255.255.255.255
     ipv6 addr 9993::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo4
     vrf for v4
     ipv4 addr 9.9.4.2 255.255.255.255
     ipv6 addr 9994::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    router bgp4 1
     vrf v1
     no safe-ebgp
     address octp
     local-as 2
     router-id 4.4.4.2
     neigh 2.2.2.1 remote-as 1
     neigh 2.2.2.1 confed
     neigh 2.2.2.1 update lo0
     neigh 2.2.2.1 send-comm both
     afi-other enable
     afi-oclr v2 ena
     afi-oclr v2 red conn
     afi-oclr v3 ena
     afi-oclr v3 red conn
     afi-oclr v4 ena
     afi-oclr v4 red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address octp
     local-as 2
     router-id 6.6.6.2
     neigh 4321::1 remote-as 1
     neigh 4321::1 confed
     neigh 4321::1 update lo0
     neigh 4321::1 send-comm both
     afi-other enable
     afi-oclr v2 ena
     afi-oclr v2 red conn
     afi-oclr v3 ena
     afi-oclr v3 red conn
     afi-oclr v4 ena
     afi-oclr v4 red conn
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 60 4321::1 vrf v1 sou lo0
    r1 tping 100 60 9.9.2.2 vrf v2
    r2 tping 100 60 9.9.2.1 vrf v2
    r1 tping 100 60 9992::2 vrf v2
    r2 tping 100 60 9992::1 vrf v2
    r1 tping 100 60 9.9.3.2 vrf v3
    r2 tping 100 60 9.9.3.1 vrf v3
    r1 tping 100 60 9993::2 vrf v3
    r2 tping 100 60 9993::1 vrf v3
    r1 tping 100 60 9.9.4.2 vrf v4
    r2 tping 100 60 9.9.4.1 vrf v4
    r1 tping 100 60 9994::2 vrf v4
    r2 tping 100 60 9994::1 vrf v4
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp677](../clab/rout-bgp677/rout-bgp677.yml) file  
        3. Launch ContainerLab `rout-bgp677.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp677.yml  
        ```
        4. Destroy ContainerLab `rout-bgp677.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp677.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp677.tst` file [here](../tst/rout-bgp677.tst)  
        3. Launch `rout-bgp677.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp677 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp677.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

