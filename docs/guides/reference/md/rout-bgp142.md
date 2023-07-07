# Example: ethersite vpns over ibgp

=== "Topology"

    ![Alt text](../d2/rout-bgp142/rout-bgp142.svg)

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
    vrf def v3
     rd 1:3
     rt-both 1:3
     exit
    vrf def v4
     rd 1:4
     rt-both 1:4
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
    int eth2.12
     vrf for v2
     ipv4 addr 9.8.2.1 255.255.255.0
     ipv6 addr 9982::1 ffff:ffff:ffff:ffff::
     exit
    int eth2.13
     vrf for v3
     ipv4 addr 9.8.3.1 255.255.255.0
     ipv6 addr 9983::1 ffff:ffff:ffff:ffff::
     exit
    int eth2.14
     vrf for v4
     ipv4 addr 9.8.4.1 255.255.255.0
     ipv6 addr 9984::1 ffff:ffff:ffff:ffff::
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
     address vpnuni
     local-as 1
     router-id 4.4.4.1
     neigh 2.2.2.3 remote-as 1
     neigh 2.2.2.3 update lo0
     neigh 2.2.2.3 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v3 ena
     afi-vrf v3 red conn
     afi-vrf v4 ena
     afi-vrf v4 red conn
     exit
    router bgp6 1
     vrf v1
     address vpnuni
     local-as 1
     router-id 6.6.6.1
     neigh 4321::3 remote-as 1
     neigh 4321::3 update lo0
     neigh 4321::3 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v3 ena
     afi-vrf v3 red conn
     afi-vrf v4 ena
     afi-vrf v4 red conn
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
    vrf def v2
     rd 1:2
     rt-both 1:2
     exit
    vrf def v3
     rd 1:3
     rt-both 1:3
     exit
    vrf def v4
     rd 1:4
     rt-both 1:4
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v2
     ipv4 addr 9.9.2.3 255.255.255.255
     ipv6 addr 9992::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo3
     vrf for v3
     ipv4 addr 9.9.3.3 255.255.255.255
     ipv6 addr 9993::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo4
     vrf for v4
     ipv4 addr 9.9.4.3 255.255.255.255
     ipv6 addr 9994::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth2.12
     vrf for v2
     ipv4 addr 9.7.2.1 255.255.255.0
     ipv6 addr 9972::1 ffff:ffff:ffff:ffff::
     exit
    int eth2.13
     vrf for v3
     ipv4 addr 9.7.3.1 255.255.255.0
     ipv6 addr 9973::1 ffff:ffff:ffff:ffff::
     exit
    int eth2.14
     vrf for v4
     ipv4 addr 9.7.4.1 255.255.255.0
     ipv6 addr 9974::1 ffff:ffff:ffff:ffff::
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
     address vpnuni
     local-as 1
     router-id 4.4.4.3
     neigh 2.2.2.1 remote-as 1
     neigh 2.2.2.1 update lo0
     neigh 2.2.2.1 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v3 ena
     afi-vrf v3 red conn
     afi-vrf v4 ena
     afi-vrf v4 red conn
     exit
    router bgp6 1
     vrf v1
     address vpnuni
     local-as 1
     router-id 6.6.6.3
     neigh 4321::1 remote-as 1
     neigh 4321::1 update lo0
     neigh 4321::1 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red conn
     afi-vrf v3 ena
     afi-vrf v3 red conn
     afi-vrf v4 ena
     afi-vrf v4 red conn
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v2
     rd 1:2
     rt-both 1:2
     exit
    vrf def v3
     rd 1:3
     rt-both 1:3
     exit
    vrf def v4
     rd 1:4
     rt-both 1:4
     exit
    int eth1.12
     vrf for v2
     ipv4 addr 9.8.2.2 255.255.255.0
     ipv6 addr 9982::2 ffff:ffff:ffff:ffff::
     exit
    int eth1.13
     vrf for v3
     ipv4 addr 9.8.3.2 255.255.255.0
     ipv6 addr 9983::2 ffff:ffff:ffff:ffff::
     exit
    int eth1.14
     vrf for v4
     ipv4 addr 9.8.4.2 255.255.255.0
     ipv6 addr 9984::2 ffff:ffff:ffff:ffff::
     exit
    ipv4 route v2 0.0.0.0 0.0.0.0 9.8.2.1
    ipv4 route v3 0.0.0.0 0.0.0.0 9.8.3.1
    ipv4 route v4 0.0.0.0 0.0.0.0 9.8.4.1
    ipv6 route v2 :: :: 9982::1
    ipv6 route v3 :: :: 9983::1
    ipv6 route v4 :: :: 9984::1
    ```

    **r5**

    ```
    hostname r5
    vrf def v2
     rd 1:2
     rt-both 1:2
     exit
    vrf def v3
     rd 1:3
     rt-both 1:3
     exit
    vrf def v4
     rd 1:4
     rt-both 1:4
     exit
    int eth1.12
     vrf for v2
     ipv4 addr 9.7.2.2 255.255.255.0
     ipv6 addr 9972::2 ffff:ffff:ffff:ffff::
     exit
    int eth1.13
     vrf for v3
     ipv4 addr 9.7.3.2 255.255.255.0
     ipv6 addr 9973::2 ffff:ffff:ffff:ffff::
     exit
    int eth1.14
     vrf for v4
     ipv4 addr 9.7.4.2 255.255.255.0
     ipv6 addr 9974::2 ffff:ffff:ffff:ffff::
     exit
    ipv4 route v2 0.0.0.0 0.0.0.0 9.7.2.1
    ipv4 route v3 0.0.0.0 0.0.0.0 9.7.3.1
    ipv4 route v4 0.0.0.0 0.0.0.0 9.7.4.1
    ipv6 route v2 :: :: 9972::1
    ipv6 route v3 :: :: 9973::1
    ipv6 route v4 :: :: 9974::1
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 4321::3 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r2 tping 100 60 4321::3 vrf v1 sou lo0
    r2 tping 100 60 4321::1 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 60 4321::1 vrf v1 sou lo0
    r3 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 9.9.2.3 vrf v2
    r1 tping 100 60 9.8.2.2 vrf v2
    r1 tping 100 60 9.7.2.2 vrf v2
    r3 tping 100 60 9.9.2.1 vrf v2
    r3 tping 100 60 9.8.2.2 vrf v2
    r3 tping 100 60 9.7.2.2 vrf v2
    r1 tping 100 60 9992::3 vrf v2
    r1 tping 100 60 9982::2 vrf v2
    r1 tping 100 60 9972::2 vrf v2
    r3 tping 100 60 9992::1 vrf v2
    r3 tping 100 60 9982::2 vrf v2
    r3 tping 100 60 9972::2 vrf v2
    r1 tping 100 60 9.9.3.3 vrf v3
    r1 tping 100 60 9.8.3.2 vrf v3
    r1 tping 100 60 9.7.3.2 vrf v3
    r3 tping 100 60 9.9.3.1 vrf v3
    r3 tping 100 60 9.8.3.2 vrf v3
    r3 tping 100 60 9.7.3.2 vrf v3
    r1 tping 100 60 9993::3 vrf v3
    r1 tping 100 60 9983::2 vrf v3
    r1 tping 100 60 9973::2 vrf v3
    r3 tping 100 60 9993::1 vrf v3
    r3 tping 100 60 9983::2 vrf v3
    r3 tping 100 60 9973::2 vrf v3
    r1 tping 100 60 9.9.4.3 vrf v4
    r1 tping 100 60 9.8.4.2 vrf v4
    r1 tping 100 60 9.7.4.2 vrf v4
    r3 tping 100 60 9.9.4.1 vrf v4
    r3 tping 100 60 9.8.4.2 vrf v4
    r3 tping 100 60 9.7.4.2 vrf v4
    r1 tping 100 60 9994::3 vrf v4
    r1 tping 100 60 9984::2 vrf v4
    r1 tping 100 60 9974::2 vrf v4
    r3 tping 100 60 9994::1 vrf v4
    r3 tping 100 60 9984::2 vrf v4
    r3 tping 100 60 9974::2 vrf v4
    r4 tping 100 60 9.9.2.1 vrf v2
    r4 tping 100 60 9.9.2.3 vrf v2
    r4 tping 100 60 9.8.2.2 vrf v2
    r4 tping 100 60 9.7.2.2 vrf v2
    r5 tping 100 60 9.9.2.1 vrf v2
    r5 tping 100 60 9.9.2.3 vrf v2
    r5 tping 100 60 9.8.2.2 vrf v2
    r5 tping 100 60 9.7.2.2 vrf v2
    r4 tping 100 60 9992::1 vrf v2
    r4 tping 100 60 9992::3 vrf v2
    r4 tping 100 60 9982::2 vrf v2
    r4 tping 100 60 9972::2 vrf v2
    r5 tping 100 60 9992::1 vrf v2
    r5 tping 100 60 9992::3 vrf v2
    r5 tping 100 60 9982::2 vrf v2
    r5 tping 100 60 9972::2 vrf v2
    r4 tping 100 60 9.9.3.1 vrf v3
    r4 tping 100 60 9.9.3.3 vrf v3
    r4 tping 100 60 9.8.3.2 vrf v3
    r4 tping 100 60 9.7.3.2 vrf v3
    r5 tping 100 60 9.9.3.1 vrf v3
    r5 tping 100 60 9.9.3.3 vrf v3
    r5 tping 100 60 9.8.3.2 vrf v3
    r5 tping 100 60 9.7.3.2 vrf v3
    r4 tping 100 60 9993::1 vrf v3
    r4 tping 100 60 9993::3 vrf v3
    r4 tping 100 60 9983::2 vrf v3
    r4 tping 100 60 9973::2 vrf v3
    r5 tping 100 60 9993::1 vrf v3
    r5 tping 100 60 9993::3 vrf v3
    r5 tping 100 60 9983::2 vrf v3
    r5 tping 100 60 9973::2 vrf v3
    r4 tping 100 60 9.9.4.1 vrf v4
    r4 tping 100 60 9.9.4.3 vrf v4
    r4 tping 100 60 9.8.4.2 vrf v4
    r4 tping 100 60 9.7.4.2 vrf v4
    r5 tping 100 60 9.9.4.1 vrf v4
    r5 tping 100 60 9.9.4.3 vrf v4
    r5 tping 100 60 9.8.4.2 vrf v4
    r5 tping 100 60 9.7.4.2 vrf v4
    r4 tping 100 60 9994::1 vrf v4
    r4 tping 100 60 9994::3 vrf v4
    r4 tping 100 60 9984::2 vrf v4
    r4 tping 100 60 9974::2 vrf v4
    r5 tping 100 60 9994::1 vrf v4
    r5 tping 100 60 9994::3 vrf v4
    r5 tping 100 60 9984::2 vrf v4
    r5 tping 100 60 9974::2 vrf v4
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp142](../clab/rout-bgp142/rout-bgp142.yml) file  
        3. Launch ContainerLab `rout-bgp142.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp142.yml  
        ```
        4. Destroy ContainerLab `rout-bgp142.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp142.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp142.tst` file [here](../tst/rout-bgp142.tst)  
        3. Launch `rout-bgp142.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp142 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp142.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

