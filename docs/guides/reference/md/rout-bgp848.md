# Example: unicast+mtree over bgp

=== "Topology"

    ![Alt text](../d2/rout-bgp848/rout-bgp848.svg)

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
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni mtree
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 2
     neigh 1.1.1.2 send-comm both
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni mtree
     local-as 1
     router-id 6.6.6.1
     neigh 1234:1::2 remote-as 2
     neigh 1234:1::2 send-comm both
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
     ipv6 addr 1234:1::2 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni mtree
     local-as 2
     router-id 4.4.4.2
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 send-comm both
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni mtree
     local-as 2
     router-id 6.6.6.2
     neigh 1234:1::1 remote-as 1
     neigh 1234:1::1 send-comm both
     red conn
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 60 4321::1 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp848](../clab/rout-bgp848/rout-bgp848.yml) file  
        3. Launch ContainerLab `rout-bgp848.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp848.yml  
        ```
        4. Destroy ContainerLab `rout-bgp848.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp848.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp848.tst` file [here](../tst/rout-bgp848.tst)  
        3. Launch `rout-bgp848.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp848 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp848.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

