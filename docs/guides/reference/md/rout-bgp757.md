# Example: bgp interas car with multiple labels

=== "Topology"

    ![Alt text](../d2/rout-bgp757/rout-bgp757.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode all-igp
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.255
     ipv6 addr 3331::1 ffff:ffff:ffff:ffff::
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
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    router bgp4 1
     vrf v1
     no safe-ebgp
     address car
     local-as 1
     router-id 4.4.4.1
     neigh 2.2.2.2 remote-as 1
     neigh 2.2.2.2 update lo0
     neigh 2.2.2.2 multiple-label car
     justadvert lo1
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address car
     local-as 1
     router-id 6.6.6.1
     neigh 4321::2 remote-as 1
     neigh 4321::2 update lo0
     neigh 4321::2 multiple-label car
     justadvert lo1
     exit
    int pweth1
     vrf for v1
     ipv4 addr 4.4.4.1 255.255.255.0
     pseudo v1 lo1 pweompls 3.3.3.6 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 4.4.5.1 255.255.255.0
     pseudo v1 lo1 pweompls 3336::6 1234
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode all-igp
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.255
     ipv6 addr 3332::2 ffff:ffff:ffff:ffff::
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
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.6
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    router bgp4 1
     vrf v1
     no safe-ebgp
     address car
     local-as 1
     router-id 4.4.4.2
     neigh 2.2.2.1 remote-as 1
     neigh 2.2.2.1 update lo0
     neigh 2.2.2.1 multiple-label car
     neigh 2.2.2.1 route-reflect
     neigh 2.2.2.3 remote-as 1
     neigh 2.2.2.3 update lo0
     neigh 2.2.2.3 multiple-label car
     neigh 2.2.2.3 route-reflect
     justadvert lo1
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address car
     local-as 1
     router-id 6.6.6.2
     neigh 4321::1 remote-as 1
     neigh 4321::1 update lo0
     neigh 4321::1 multiple-label car
     neigh 4321::1 route-reflect
     neigh 4321::3 remote-as 1
     neigh 4321::3 update lo0
     neigh 4321::3 multiple-label car
     neigh 4321::3 route-reflect
     justadvert lo1
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     label-mode all-igp
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.255
     ipv6 addr 3333::3 ffff:ffff:ffff:ffff::
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     ipv6 addr 1234:3::1 ffff:ffff::
     mpls enable
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.5
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.5
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    ipv4 route v1 1.1.1.10 255.255.255.255 1.1.1.10 mplsimp
    ipv6 route v1 1234:3::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::2 mplsimp
    router bgp4 1
     vrf v1
     no safe-ebgp
     address car
     local-as 1
     router-id 4.4.4.3
     neigh 2.2.2.2 remote-as 1
     neigh 2.2.2.2 update lo0
     neigh 2.2.2.2 multiple-label car
     neigh 2.2.2.2 next-hop-multi
     neigh 1.1.1.10 remote-as 2
     neigh 1.1.1.10 multiple-label car
     neigh 1.1.1.10 next-hop-multi
     justadvert lo1
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address car
     local-as 1
     router-id 6.6.6.3
     neigh 4321::2 remote-as 1
     neigh 4321::2 update lo0
     neigh 4321::2 multiple-label car
     neigh 4321::2 next-hop-multi
     neigh 1234:3::2 remote-as 2
     neigh 1234:3::2 multiple-label car
     neigh 1234:3::2 next-hop-multi
     justadvert lo1
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     label-mode all-igp
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 3.3.3.4 255.255.255.255
     ipv6 addr 3334::4 ffff:ffff:ffff:ffff::
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.10 255.255.255.252
     ipv6 addr 1234:3::2 ffff:ffff::
     mpls enable
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.13 255.255.255.252
     ipv6 addr 1234:4::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.5 255.255.255.255 1.1.1.14
    ipv6 route v1 4321::5 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::2
    ipv4 route v1 2.2.2.6 255.255.255.255 1.1.1.14
    ipv6 route v1 4321::6 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::2
    ipv4 route v1 1.1.1.9 255.255.255.255 1.1.1.9 mplsimp
    ipv6 route v1 1234:3::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::1 mplsimp
    router bgp4 2
     vrf v1
     no safe-ebgp
     address car
     local-as 2
     router-id 4.4.4.4
     neigh 2.2.2.5 remote-as 2
     neigh 2.2.2.5 update lo0
     neigh 2.2.2.5 multiple-label car
     neigh 2.2.2.5 next-hop-multi
     neigh 1.1.1.9 remote-as 1
     neigh 1.1.1.9 multiple-label car
     neigh 1.1.1.9 next-hop-multi
     justadvert lo1
     exit
    router bgp6 2
     vrf v1
     no safe-ebgp
     address car
     local-as 2
     router-id 6.6.6.4
     neigh 4321::5 remote-as 2
     neigh 4321::5 update lo0
     neigh 4321::5 multiple-label car
     neigh 4321::5 next-hop-multi
     neigh 1234:3::1 remote-as 1
     neigh 1234:3::1 multiple-label car
     neigh 1234:3::1 next-hop-multi
     justadvert lo1
     exit
    ```

    **r5**

    ```
    hostname r5
    vrf def v1
     rd 1:1
     label-mode all-igp
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.5 255.255.255.255
     ipv6 addr 4321::5 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 3.3.3.5 255.255.255.255
     ipv6 addr 3335::5 ffff:ffff:ffff:ffff::
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.14 255.255.255.252
     ipv6 addr 1234:4::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.17 255.255.255.252
     ipv6 addr 1234:5::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.4 255.255.255.255 1.1.1.13
    ipv6 route v1 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:4::1
    ipv4 route v1 2.2.2.6 255.255.255.255 1.1.1.18
    ipv6 route v1 4321::6 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:5::2
    router bgp4 2
     vrf v1
     no safe-ebgp
     address car
     local-as 2
     router-id 4.4.4.5
     neigh 2.2.2.4 remote-as 2
     neigh 2.2.2.4 update lo0
     neigh 2.2.2.4 multiple-label car
     neigh 2.2.2.4 route-reflect
     neigh 2.2.2.6 remote-as 2
     neigh 2.2.2.6 update lo0
     neigh 2.2.2.6 multiple-label car
     neigh 2.2.2.6 route-reflect
     justadvert lo1
     exit
    router bgp6 2
     vrf v1
     no safe-ebgp
     address car
     local-as 2
     router-id 6.6.6.5
     neigh 4321::4 remote-as 2
     neigh 4321::4 update lo0
     neigh 4321::4 multiple-label car
     neigh 4321::4 route-reflect
     neigh 4321::6 remote-as 2
     neigh 4321::6 update lo0
     neigh 4321::6 multiple-label car
     neigh 4321::6 route-reflect
     justadvert lo1
     exit
    ```

    **r6**

    ```
    hostname r6
    vrf def v1
     rd 1:1
     label-mode all-igp
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.6 255.255.255.255
     ipv6 addr 4321::6 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 3.3.3.6 255.255.255.255
     ipv6 addr 3336::6 ffff:ffff:ffff:ffff::
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.18 255.255.255.252
     ipv6 addr 1234:5::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.4 255.255.255.255 1.1.1.17
    ipv6 route v1 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:5::1
    ipv4 route v1 2.2.2.5 255.255.255.255 1.1.1.17
    ipv6 route v1 4321::5 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:5::1
    router bgp4 2
     vrf v1
     no safe-ebgp
     address car
     local-as 2
     router-id 4.4.4.6
     neigh 2.2.2.5 remote-as 2
     neigh 2.2.2.5 update lo0
     neigh 2.2.2.5 multiple-label car
     justadvert lo1
     exit
    router bgp6 2
     vrf v1
     no safe-ebgp
     address car
     local-as 2
     router-id 6.6.6.6
     neigh 4321::5 remote-as 2
     neigh 4321::5 update lo0
     neigh 4321::5 multiple-label car
     justadvert lo1
     exit
    int pweth1
     vrf for v1
     ipv4 addr 4.4.4.2 255.255.255.0
     pseudo v1 lo1 pweompls 3.3.3.1 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 4.4.5.2 255.255.255.0
     pseudo v1 lo1 pweompls 3331::1 1234
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r1 tping 100 60 4321::3 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 60 4321::1 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r2 tping 100 60 4321::3 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r3 tping 100 60 4321::1 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 60 4321::2 vrf v1 sou lo0
    r4 tping 100 60 2.2.2.5 vrf v1 sou lo0
    r4 tping 100 60 4321::5 vrf v1 sou lo0
    r4 tping 100 60 2.2.2.6 vrf v1 sou lo0
    r4 tping 100 60 4321::6 vrf v1 sou lo0
    r5 tping 100 60 2.2.2.4 vrf v1 sou lo0
    r5 tping 100 60 4321::4 vrf v1 sou lo0
    r5 tping 100 60 2.2.2.6 vrf v1 sou lo0
    r5 tping 100 60 4321::6 vrf v1 sou lo0
    r6 tping 100 60 2.2.2.4 vrf v1 sou lo0
    r6 tping 100 60 4321::4 vrf v1 sou lo0
    r6 tping 100 60 2.2.2.5 vrf v1 sou lo0
    r6 tping 100 60 4321::5 vrf v1 sou lo0
    r1 tping 100 60 3.3.3.2 vrf v1 sou lo1
    r1 tping 100 60 3332::2 vrf v1 sou lo1
    r1 tping 100 60 3.3.3.3 vrf v1 sou lo1
    r1 tping 100 60 3333::3 vrf v1 sou lo1
    r2 tping 100 60 3.3.3.1 vrf v1 sou lo1
    r2 tping 100 60 3331::1 vrf v1 sou lo1
    r2 tping 100 60 3.3.3.3 vrf v1 sou lo1
    r2 tping 100 60 3333::3 vrf v1 sou lo1
    r3 tping 100 60 3.3.3.1 vrf v1 sou lo1
    r3 tping 100 60 3331::1 vrf v1 sou lo1
    r3 tping 100 60 3.3.3.2 vrf v1 sou lo1
    r3 tping 100 60 3332::2 vrf v1 sou lo1
    r4 tping 100 60 3.3.3.5 vrf v1 sou lo1
    r4 tping 100 60 3335::5 vrf v1 sou lo1
    r4 tping 100 60 3.3.3.6 vrf v1 sou lo1
    r4 tping 100 60 3336::6 vrf v1 sou lo1
    r5 tping 100 60 3.3.3.4 vrf v1 sou lo1
    r5 tping 100 60 3334::4 vrf v1 sou lo1
    r5 tping 100 60 3.3.3.6 vrf v1 sou lo1
    r5 tping 100 60 3336::6 vrf v1 sou lo1
    r6 tping 100 60 3.3.3.4 vrf v1 sou lo1
    r6 tping 100 60 3334::4 vrf v1 sou lo1
    r6 tping 100 60 3.3.3.5 vrf v1 sou lo1
    r6 tping 100 60 3335::5 vrf v1 sou lo1
    r4 tping 100 60 3.3.3.1 vrf v1 sou lo1
    r4 tping 100 60 3331::1 vrf v1 sou lo1
    r4 tping 100 60 3.3.3.2 vrf v1 sou lo1
    r4 tping 100 60 3332::2 vrf v1 sou lo1
    r4 tping 100 60 3.3.3.3 vrf v1 sou lo1
    r4 tping 100 60 3333::3 vrf v1 sou lo1
    r5 tping 100 60 3.3.3.1 vrf v1 sou lo1
    r5 tping 100 60 3331::1 vrf v1 sou lo1
    r5 tping 100 60 3.3.3.2 vrf v1 sou lo1
    r5 tping 100 60 3332::2 vrf v1 sou lo1
    r5 tping 100 60 3.3.3.3 vrf v1 sou lo1
    r5 tping 100 60 3333::3 vrf v1 sou lo1
    r6 tping 100 60 3.3.3.1 vrf v1 sou lo1
    r6 tping 100 60 3331::1 vrf v1 sou lo1
    r6 tping 100 60 3.3.3.2 vrf v1 sou lo1
    r6 tping 100 60 3332::2 vrf v1 sou lo1
    r6 tping 100 60 3.3.3.3 vrf v1 sou lo1
    r6 tping 100 60 3333::3 vrf v1 sou lo1
    r1 tping 100 60 3.3.3.4 vrf v1 sou lo1
    r1 tping 100 60 3334::4 vrf v1 sou lo1
    r1 tping 100 60 3.3.3.5 vrf v1 sou lo1
    r1 tping 100 60 3335::5 vrf v1 sou lo1
    r1 tping 100 60 3.3.3.6 vrf v1 sou lo1
    r1 tping 100 60 3336::6 vrf v1 sou lo1
    r2 tping 100 60 3.3.3.4 vrf v1 sou lo1
    r2 tping 100 60 3334::4 vrf v1 sou lo1
    r2 tping 100 60 3.3.3.5 vrf v1 sou lo1
    r2 tping 100 60 3335::5 vrf v1 sou lo1
    r2 tping 100 60 3.3.3.6 vrf v1 sou lo1
    r2 tping 100 60 3336::6 vrf v1 sou lo1
    r3 tping 100 60 3.3.3.4 vrf v1 sou lo1
    r3 tping 100 60 3334::4 vrf v1 sou lo1
    r3 tping 100 60 3.3.3.5 vrf v1 sou lo1
    r3 tping 100 60 3335::5 vrf v1 sou lo1
    r3 tping 100 60 3.3.3.6 vrf v1 sou lo1
    r3 tping 100 60 3336::6 vrf v1 sou lo1
    r1 tping 100 40 4.4.4.2 vrf v1
    r6 tping 100 40 4.4.4.1 vrf v1
    r1 tping 100 40 4.4.5.2 vrf v1
    r6 tping 100 40 4.4.5.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp757](../clab/rout-bgp757/rout-bgp757.yml) file  
        3. Launch ContainerLab `rout-bgp757.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp757.yml  
        ```
        4. Destroy ContainerLab `rout-bgp757.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp757.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp757.tst` file [here](../tst/rout-bgp757.tst)  
        3. Launch `rout-bgp757.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp757 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp757.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

