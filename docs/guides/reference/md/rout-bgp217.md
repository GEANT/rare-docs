# Example: ibgp with ttl-security

=== "Topology"

    ![Alt text](../d2/rout-bgp217/rout-bgp217.svg)

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
    access-list test4
     permit 6 any all any all ttl 110-120
     deny 6 any all any all
     permit all any all any all
     exit
    access-list test6
     permit 6 any all any all ttl 110-120
     deny 6 any all any all
     permit all any all any all
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234::1 ffff:ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     ipv4 access-group-out test4
     ipv6 access-group-out test6
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 1
     neigh 1.1.1.2 ttl-sec 115
     neigh 1.1.1.2 connection pass
     red conn
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.1
     neigh 1234::2 remote-as 1
     neigh 1234::2 ttl-sec 115
     neigh 1234::2 connection pass
     red conn
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
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234::2 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.2
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 ttl-sec 115
     neigh 1.1.1.1 connection act
     red conn
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.2
     neigh 1234::1 remote-as 1
     neigh 1234::1 ttl-sec 115
     neigh 1234::1 connection act
     red conn
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1
    r1 tping 100 60 4321::2 vrf v1
    r2 tping 100 60 2.2.2.1 vrf v1
    r2 tping 100 60 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp217](../clab/rout-bgp217/rout-bgp217.yml) file  
        3. Launch ContainerLab `rout-bgp217.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp217.yml  
        ```
        4. Destroy ContainerLab `rout-bgp217.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp217.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp217.tst` file [here](../tst/rout-bgp217.tst)  
        3. Launch `rout-bgp217.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp217 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp217.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

