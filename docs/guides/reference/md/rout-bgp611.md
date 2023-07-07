# Example: ibgp rr with ctp

=== "Topology"

    ![Alt text](../d2/rout-bgp611/rout-bgp611.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
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
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff:ffff::
     mpls enable
     exit
    router bgp4 1
     vrf v1
     address ctp
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.3 remote-as 1
     red conn
     exit
    router bgp6 1
     vrf v1
     address ctp
     local-as 1
     router-id 6.6.6.1
     neigh 1234::3 remote-as 1
     red conn
     exit
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     pseudo v1 lo1 pweompls 2.2.2.12 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 3.3.4.1 255.255.255.0
     pseudo v1 lo1 pweompls 4321::12 1234
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.12 255.255.255.255
     ipv6 addr 4321::12 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff:ffff::
     mpls enable
     exit
    router bgp4 1
     vrf v1
     address ctp
     local-as 1
     router-id 4.4.4.2
     neigh 1.1.1.3 remote-as 1
     red conn
     exit
    router bgp6 1
     vrf v1
     address ctp
     local-as 1
     router-id 6.6.6.2
     neigh 1234::3 remote-as 1
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

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    bridge 1
     mac-learn
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
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff:ffff::
     mpls enable
     exit
    router bgp4 1
     vrf v1
     address ctp
     local-as 1
     router-id 4.4.4.3
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 route-reflect
     neigh 1.1.1.2 remote-as 1
     neigh 1.1.1.2 route-reflect
     red conn
     exit
    router bgp6 1
     vrf v1
     address ctp
     local-as 1
     router-id 6.6.6.3
     neigh 1234::1 remote-as 1
     neigh 1234::1 route-reflect
     neigh 1234::2 remote-as 1
     neigh 1234::2 route-reflect
     red conn
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 4321::3 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.12 vrf v1 sou lo0
    r1 tping 100 60 4321::12 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.13 vrf v1 sou lo0
    r1 tping 100 60 4321::13 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r2 tping 100 60 4321::3 vrf v1 sou lo0
    r2 tping 100 60 4321::1 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.11 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.13 vrf v1 sou lo0
    r2 tping 100 60 4321::11 vrf v1 sou lo0
    r2 tping 100 60 4321::13 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 60 4321::1 vrf v1 sou lo0
    r3 tping 100 60 4321::2 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.11 vrf v1 sou lo0
    r3 tping 100 60 4321::11 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.12 vrf v1 sou lo0
    r3 tping 100 60 4321::12 vrf v1 sou lo0
    r1 tping 100 40 3.3.3.2 vrf v1
    r2 tping 100 40 3.3.3.1 vrf v1
    r1 tping 100 40 3.3.4.2 vrf v1
    r2 tping 100 40 3.3.4.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp611](../clab/rout-bgp611/rout-bgp611.yml) file  
        3. Launch ContainerLab `rout-bgp611.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp611.yml  
        ```
        4. Destroy ContainerLab `rout-bgp611.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp611.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp611.tst` file [here](../tst/rout-bgp611.tst)  
        3. Launch `rout-bgp611.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp611 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp611.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

