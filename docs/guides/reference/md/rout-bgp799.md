# Example: bgp routepolicy filtering with aggregator with soft-reconfig

=== "Topology"

    ![Alt text](../d2/rout-bgp799/rout-bgp799.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    bridge 1
     mac-learn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 1
     neigh 1.1.1.2 soft-reconfig
     neigh 1.1.1.2 route-reflect
     neigh 1.1.1.3 remote-as 1
     neigh 1.1.1.3 soft-reconfig
     neigh 1.1.1.3 route-reflect
     red conn
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.1
     neigh 1234:1::2 remote-as 1
     neigh 1234:1::2 soft-reconfig
     neigh 1234:1::2 route-reflect
     neigh 1234:1::3 remote-as 1
     neigh 1234:1::3 soft-reconfig
     neigh 1234:1::3 route-reflect
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
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234:1::2 ffff:ffff::
     exit
    route-policy rm1
     set aggregator 1234 1.1.1.111
     pass
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.2
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 soft-reconfig
     red conn route-policy rm1
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.2
     neigh 1234:1::1 remote-as 1
     neigh 1234:1::1 soft-reconfig
     red conn route-policy rm1
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
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234:1::3 ffff:ffff::
     exit
    route-policy rm1
     if aggregator 1234
      drop
     else
      pass
     enif
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.3
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 soft-reconfig
     neigh 1.1.1.1 route-policy-in rm1
     red conn
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.3
     neigh 1234:1::1 remote-as 1
     neigh 1234:1::1 soft-reconfig
     neigh 1234:1::1 route-policy-in rm1
     red conn
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1
    r1 tping 100 60 4321::2 vrf v1
    r1 tping 100 60 2.2.2.3 vrf v1
    r1 tping 100 60 4321::3 vrf v1
    r2 tping 100 60 2.2.2.1 vrf v1
    r2 tping 100 60 4321::1 vrf v1
    r2 tping 100 60 2.2.2.3 vrf v1
    r2 tping 100 60 4321::3 vrf v1
    r3 tping 100 60 2.2.2.1 vrf v1
    r3 tping 100 60 4321::1 vrf v1
    r3 tping 0 60 2.2.2.2 vrf v1
    r3 tping 0 60 4321::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp799](../clab/rout-bgp799/rout-bgp799.yml) file  
        3. Launch ContainerLab `rout-bgp799.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp799.yml  
        ```
        4. Destroy ContainerLab `rout-bgp799.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp799.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp799.tst` file [here](../tst/rout-bgp799.tst)  
        3. Launch `rout-bgp799.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp799 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp799.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

