# Example: ibgp with car

=== "Topology"

    ![Alt text](../d2/rout-bgp696/rout-bgp696.svg)

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
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.11 255.255.255.255
     ipv6 addr 4321::11 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
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
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    router bgp4 1
     vrf v1
     address car
     local-as 1
     router-id 4.4.4.1
     neigh 2.2.2.3 remote-as 1
     neigh 2.2.2.3 update lo0
     red conn
     exit
    router bgp6 1
     vrf v1
     address car
     local-as 1
     router-id 6.6.6.1
     neigh 4321::3 remote-as 1
     neigh 4321::3 update lo0
     red conn
     exit
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     pseudo v1 lo1 pweompls 2.2.2.13 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 3.3.4.1 255.255.255.0
     pseudo v1 lo1 pweompls 4321::13 1234
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode per-prefix
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
     mpls ldp4
     mpls ldp6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.6
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
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
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.13 255.255.255.255
     ipv6 addr 4321::13 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.5
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.5
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    router bgp4 1
     vrf v1
     address car
     local-as 1
     router-id 4.4.4.3
     neigh 2.2.2.1 remote-as 1
     neigh 2.2.2.1 update lo0
     red conn
     exit
    router bgp6 1
     vrf v1
     address car
     local-as 1
     router-id 6.6.6.3
     neigh 4321::1 remote-as 1
     neigh 4321::1 update lo0
     red conn
     exit
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     pseudo v1 lo1 pweompls 2.2.2.11 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 3.3.4.2 255.255.255.0
     pseudo v1 lo1 pweompls 4321::11 1234
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 4321::3 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.13 vrf v1 sou lo0
    r1 tping 100 60 4321::13 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r2 tping 100 60 4321::3 vrf v1 sou lo0
    r2 tping 100 60 4321::1 vrf v1 sou lo0
    r2 tping 0 60 2.2.2.11 vrf v1 sou lo0
    r2 tping 0 60 2.2.2.13 vrf v1 sou lo0
    r2 tping 0 60 4321::11 vrf v1 sou lo0
    r2 tping 0 60 4321::13 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 60 4321::1 vrf v1 sou lo0
    r3 tping 100 60 4321::2 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.11 vrf v1 sou lo0
    r3 tping 100 60 4321::11 vrf v1 sou lo0
    r1 tping 100 40 3.3.3.2 vrf v1
    r3 tping 100 40 3.3.3.1 vrf v1
    r1 tping 100 40 3.3.4.2 vrf v1
    r3 tping 100 40 3.3.4.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp696](../clab/rout-bgp696/rout-bgp696.yml) file  
        3. Launch ContainerLab `rout-bgp696.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp696.yml  
        ```
        4. Destroy ContainerLab `rout-bgp696.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp696.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp696.tst` file [here](../tst/rout-bgp696.tst)  
        3. Launch `rout-bgp696.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp696 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp696.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

