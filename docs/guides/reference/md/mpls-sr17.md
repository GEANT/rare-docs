# Example: bgp with php car over sr

=== "Topology"

    ![Alt text](../d2/mpls-sr17/mpls-sr17.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.1
     segrout 10 1
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.1
     segrout 10 1
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.11 255.255.255.255
     ipv6 addr 4321::11 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     mpls enable
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    router bgp4 1
     vrf v1
     address car
     local-as 1
     router-id 4.4.4.1
     neigh 2.2.2.3 remote-as 1
     neigh 2.2.2.3 label-pop
     neigh 2.2.2.3 update lo1
     red conn
     exit
    router bgp6 1
     vrf v1
     address car
     local-as 1
     router-id 6.6.6.1
     neigh 4321::3 remote-as 1
     neigh 4321::3 label-pop
     neigh 4321::3 update lo1
     red conn
     exit
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     pseudo v1 lo2 pweompls 2.2.2.13 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 3.3.4.1 255.255.255.0
     pseudo v1 lo2 pweompls 4321::13 1234
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
     segrout 10 2
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.2
     segrout 10 2
     red conn
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
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1235::2 ffff::
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
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.3
     segrout 10 3
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.3
     segrout 10 3
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.13 255.255.255.255
     ipv6 addr 4321::13 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.3 255.255.255.0
     ipv6 addr 1235::3 ffff::
     mpls enable
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    router bgp4 1
     vrf v1
     address car
     local-as 1
     router-id 4.4.4.3
     neigh 2.2.2.1 remote-as 1
     neigh 2.2.2.1 label-pop
     neigh 2.2.2.1 update lo1
     red conn
     exit
    router bgp6 1
     vrf v1
     address car
     local-as 1
     router-id 6.6.6.3
     neigh 4321::1 remote-as 1
     neigh 4321::1 label-pop
     neigh 4321::1 update lo1
     red conn
     exit
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     pseudo v1 lo2 pweompls 2.2.2.11 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 3.3.4.2 255.255.255.0
     pseudo v1 lo2 pweompls 4321::11 1234
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r1 tping 100 20 2.2.2.3 vrf v1 sou lo1
    r1 tping 100 20 4321::2 vrf v1 sou lo1
    r1 tping 100 20 4321::3 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.3 vrf v1 sou lo1
    r2 tping 100 20 4321::1 vrf v1 sou lo1
    r2 tping 100 20 4321::3 vrf v1 sou lo1
    r3 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r3 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r3 tping 100 20 4321::1 vrf v1 sou lo1
    r3 tping 100 20 4321::2 vrf v1 sou lo1
    r1 tping 100 60 2.2.2.13 vrf v1 sou lo2
    r1 tping 100 60 4321::13 vrf v1 sou lo2
    r3 tping 100 60 2.2.2.11 vrf v1 sou lo2
    r3 tping 100 60 4321::11 vrf v1 sou lo2
    r1 tping 100 40 3.3.3.2 vrf v1
    r3 tping 100 40 3.3.3.1 vrf v1
    r1 tping 100 40 3.3.4.2 vrf v1
    r3 tping 100 40 3.3.4.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-sr17](../clab/mpls-sr17/mpls-sr17.yml) file  
        3. Launch ContainerLab `mpls-sr17.yml` topology:  

        ```
           containerlab deploy --topo mpls-sr17.yml  
        ```
        4. Destroy ContainerLab `mpls-sr17.yml` topology:  

        ```
           containerlab destroy --topo mpls-sr17.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-sr17.tst` file [here](../tst/mpls-sr17.tst)  
        3. Launch `mpls-sr17.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-sr17 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-sr17.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

