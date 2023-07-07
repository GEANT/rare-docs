# Example: unified mpls with sr

=== "Topology"

    ![Alt text](../d2/rout-bgp399/rout-bgp399.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.1
     segrout 10 1
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.1
     segrout 10 1
     red conn
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
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     pseudo v1 lo0 pweompls 2.2.2.6 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 3.3.4.1 255.255.255.0
     pseudo v1 lo0 pweompls 4321::6 1234
     exit
    router bgp4 1
     vrf v1
     address lab
     local-as 1
     router-id 4.4.4.1
     neigh 2.2.2.3 remote-as 1
     neigh 2.2.2.3 update lo0
     red conn
     exit
    router bgp6 1
     vrf v1
     address lab
     local-as 1
     router-id 6.6.6.1
     neigh 4321::3 remote-as 1
     neigh 4321::3 update lo0
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
    router lsrp4 1
     vrf v1
     router 4.4.4.2
     segrout 10 2
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.2
     segrout 10 2
     red conn
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
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     mpls enable
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.3
     segrout 10 3
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.3
     segrout 10 3
     red conn
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
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     ipv6 addr 1234:3::1 ffff:ffff::
     mpls enable
     exit
    router bgp4 1
     vrf v1
     address lab
     local-as 1
     router-id 4.4.4.3
     neigh 2.2.2.1 remote-as 1
     neigh 2.2.2.1 update lo0
     neigh 2.2.2.1 next-hop-self
     neigh 1.1.1.10 remote-as 1
     neigh 1.1.1.10 route-reflect
     neigh 1.1.1.10 next-hop-self
     red conn
     exit
    router bgp6 1
     vrf v1
     address lab
     local-as 1
     router-id 6.6.6.3
     neigh 4321::1 remote-as 1
     neigh 4321::1 update lo0
     neigh 4321::1 next-hop-self
     neigh 1234:3::2 remote-as 1
     neigh 1234:3::2 route-reflect
     neigh 1234:3::2 next-hop-self
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
    router lsrp4 1
     vrf v1
     router 4.4.4.4
     segrout 10 4
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.4
     segrout 10 4
     red conn
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
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.13 255.255.255.252
     ipv6 addr 1234:4::1 ffff:ffff::
     mpls enable
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    router bgp4 1
     vrf v1
     address lab
     local-as 1
     router-id 4.4.4.4
     neigh 2.2.2.6 remote-as 1
     neigh 2.2.2.6 update lo0
     neigh 2.2.2.6 next-hop-self
     neigh 1.1.1.9 remote-as 1
     neigh 1.1.1.9 route-reflect
     neigh 1.1.1.9 next-hop-self
     red conn
     exit
    router bgp6 1
     vrf v1
     address lab
     local-as 1
     router-id 6.6.6.4
     neigh 4321::6 remote-as 1
     neigh 4321::6 update lo0
     neigh 4321::6 next-hop-self
     neigh 1234:3::1 remote-as 1
     neigh 1234:3::1 route-reflect
     neigh 1234:3::1 next-hop-self
     red conn
     exit
    ```

    **r5**

    ```
    hostname r5
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.5
     segrout 10 5
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.5
     segrout 10 5
     red conn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.5 255.255.255.255
     ipv6 addr 4321::5 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.14 255.255.255.252
     ipv6 addr 1234:4::2 ffff:ffff::
     mpls enable
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.17 255.255.255.252
     ipv6 addr 1234:5::1 ffff:ffff::
     mpls enable
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    ```

    **r6**

    ```
    hostname r6
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.6
     segrout 10 6
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.6
     segrout 10 6
     red conn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.6 255.255.255.255
     ipv6 addr 4321::6 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.18 255.255.255.252
     ipv6 addr 1234:5::2 ffff:ffff::
     mpls enable
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     pseudo v1 lo0 pweompls 2.2.2.1 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 3.3.4.2 255.255.255.0
     pseudo v1 lo0 pweompls 4321::1 1234
     exit
    router bgp4 1
     vrf v1
     address lab
     local-as 1
     router-id 4.4.4.6
     neigh 2.2.2.4 remote-as 1
     neigh 2.2.2.4 update lo0
     red conn
     exit
    router bgp6 1
     vrf v1
     address lab
     local-as 1
     router-id 6.6.6.6
     neigh 4321::4 remote-as 1
     neigh 4321::4 update lo0
     red conn
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
    r4 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r4 tping 100 60 4321::1 vrf v1 sou lo0
    r4 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r4 tping 100 60 4321::3 vrf v1 sou lo0
    r6 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r6 tping 100 60 4321::1 vrf v1 sou lo0
    r6 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r6 tping 100 60 4321::3 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.4 vrf v1 sou lo0
    r1 tping 100 60 4321::4 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.6 vrf v1 sou lo0
    r1 tping 100 60 4321::6 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.4 vrf v1 sou lo0
    r3 tping 100 60 4321::4 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.6 vrf v1 sou lo0
    r3 tping 100 60 4321::6 vrf v1 sou lo0
    r1 tping 100 60 3.3.3.2 vrf v1
    r6 tping 100 60 3.3.3.1 vrf v1
    r1 tping 100 60 3.3.4.2 vrf v1
    r6 tping 100 60 3.3.4.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp399](../clab/rout-bgp399/rout-bgp399.yml) file  
        3. Launch ContainerLab `rout-bgp399.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp399.yml  
        ```
        4. Destroy ContainerLab `rout-bgp399.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp399.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp399.tst` file [here](../tst/rout-bgp399.tst)  
        3. Launch `rout-bgp399.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp399 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp399.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

