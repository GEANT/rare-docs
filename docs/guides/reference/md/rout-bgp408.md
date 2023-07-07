# Example: bgp remove private as out with routemap

=== "Topology"

    ![Alt text](../d2/rout-bgp408/rout-bgp408.svg)

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
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 65534
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 1
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 65534
     router-id 6.6.6.1
     neigh 1234:1::2 remote-as 1
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
    route-map rm1
     sequence 10 act perm
      match private
      clear private
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 1
     router-id 4.4.4.3
     neigh 1.1.1.1 remote-as 65534
     neigh 1.1.1.1 route-map-out rm1
     neigh 1.1.1.6 remote-as 65534
     neigh 1.1.1.6 route-map-out rm1
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 1
     router-id 6.6.6.3
     neigh 1234:1::1 remote-as 65534
     neigh 1234:1::1 route-map-out rm1
     neigh 1234:2::2 remote-as 65534
     neigh 1234:2::2 route-map-out rm1
     red conn
     exit
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
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 65534
     router-id 4.4.4.3
     neigh 1.1.1.5 remote-as 1
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 65534
     router-id 6.6.6.3
     neigh 1234:2::1 remote-as 1
     red conn
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 60 2.2.2.1 vrf v1
    r2 tping 100 60 2.2.2.3 vrf v1
    r2 tping 100 60 4321::3 vrf v1
    r2 tping 100 60 4321::1 vrf v1
    r1 tping 0 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.3 vrf v1 sou lo0
    r1 tping 0 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 4321::3 vrf v1 sou lo0
    r3 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r3 tping 0 60 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 60 4321::1 vrf v1 sou lo0
    r3 tping 0 60 4321::2 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp408](../clab/rout-bgp408/rout-bgp408.yml) file  
        3. Launch ContainerLab `rout-bgp408.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp408.yml  
        ```
        4. Destroy ContainerLab `rout-bgp408.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp408.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp408.tst` file [here](../tst/rout-bgp408.tst)  
        3. Launch `rout-bgp408.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp408 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp408.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

