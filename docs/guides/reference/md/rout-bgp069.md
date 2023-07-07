# Example: confed bgp in chain with soft-reconfig

=== "Topology"

    ![Alt text](../d2/rout-bgp069/rout-bgp069.svg)

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
     address uni
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 2
     neigh 1.1.1.2 soft-reconfig
     neigh 1.1.1.2 confed
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 1
     router-id 6.6.6.1
     neigh 1234:1::2 remote-as 2
     neigh 1234:1::2 soft-reconfig
     neigh 1234:1::2 confed
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
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 2
     router-id 4.4.4.2
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 soft-reconfig
     neigh 1.1.1.1 confed
     neigh 1.1.1.6 remote-as 3
     neigh 1.1.1.6 soft-reconfig
     neigh 1.1.1.6 confed
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 2
     router-id 6.6.6.2
     neigh 1234:1::1 remote-as 1
     neigh 1234:1::1 soft-reconfig
     neigh 1234:1::1 confed
     neigh 1234:2::2 remote-as 3
     neigh 1234:2::2 soft-reconfig
     neigh 1234:2::2 confed
     red conn
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
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
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     ipv6 addr 1234:3::1 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 3
     router-id 4.4.4.3
     neigh 1.1.1.5 remote-as 2
     neigh 1.1.1.5 soft-reconfig
     neigh 1.1.1.5 confed
     neigh 1.1.1.10 remote-as 4
     neigh 1.1.1.10 soft-reconfig
     neigh 1.1.1.10 confed
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 3
     router-id 6.6.6.3
     neigh 1234:2::1 remote-as 2
     neigh 1234:2::1 soft-reconfig
     neigh 1234:2::1 confed
     neigh 1234:3::2 remote-as 4
     neigh 1234:3::2 soft-reconfig
     neigh 1234:3::2 confed
     red conn
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
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
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 4
     router-id 4.4.4.4
     neigh 1.1.1.9 remote-as 3
     neigh 1.1.1.9 soft-reconfig
     neigh 1.1.1.9 confed
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 4
     router-id 6.6.6.4
     neigh 1234:3::1 remote-as 3
     neigh 1234:3::1 soft-reconfig
     neigh 1234:3::1 confed
     red conn
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 40 2.2.2.2 vrf v1
    r1 tping 100 40 4321::2 vrf v1
    r1 tping 0 60 2.2.2.3 vrf v1
    r1 tping 0 60 4321::3 vrf v1
    r1 tping 0 60 2.2.2.4 vrf v1
    r1 tping 0 60 4321::4 vrf v1
    r2 tping 100 60 2.2.2.1 vrf v1
    r2 tping 100 60 4321::1 vrf v1
    r2 tping 100 60 2.2.2.3 vrf v1
    r2 tping 100 60 4321::3 vrf v1
    r2 tping 0 60 2.2.2.4 vrf v1
    r2 tping 0 60 4321::4 vrf v1
    r3 tping 0 60 2.2.2.1 vrf v1
    r3 tping 0 60 4321::1 vrf v1
    r3 tping 100 60 2.2.2.2 vrf v1
    r3 tping 100 60 4321::2 vrf v1
    r3 tping 100 60 2.2.2.4 vrf v1
    r3 tping 100 60 4321::4 vrf v1
    r4 tping 0 60 2.2.2.1 vrf v1
    r4 tping 0 60 4321::1 vrf v1
    r4 tping 0 60 2.2.2.2 vrf v1
    r4 tping 0 60 4321::2 vrf v1
    r4 tping 100 60 2.2.2.3 vrf v1
    r4 tping 100 60 4321::3 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp069](../clab/rout-bgp069/rout-bgp069.yml) file  
        3. Launch ContainerLab `rout-bgp069.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp069.yml  
        ```
        4. Destroy ContainerLab `rout-bgp069.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp069.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp069.tst` file [here](../tst/rout-bgp069.tst)  
        3. Launch `rout-bgp069.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp069 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp069.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

