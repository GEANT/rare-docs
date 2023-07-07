# Example: bgp ecmp connection

=== "Topology"

    ![Alt text](../d2/rout-bgp413/rout-bgp413.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     exit
    int eth1.22
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.252
     ipv6 addr 1234:21::1 ffff:ffff::
     exit
    int eth2.11
     vrf for v1
     ipv4 addr 1.1.1.10 255.255.255.252
     ipv6 addr 1234:3::2 ffff:ffff::
     exit
    int eth2.22
     vrf for v1
     ipv4 addr 1.1.2.10 255.255.255.252
     ipv6 addr 1234:23::2 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 2
     neigh 1.1.1.9 remote-as 3
     neigh 1.1.2.2 remote-as 2
     neigh 1.1.2.9 remote-as 3
     neigh 1.1.1.2 additional-path-tx uni
     neigh 1.1.1.9 additional-path-tx uni
     neigh 1.1.2.2 additional-path-tx uni
     neigh 1.1.2.9 additional-path-tx uni
     neigh 1.1.1.2 additional-path-rx uni
     neigh 1.1.1.9 additional-path-rx uni
     neigh 1.1.2.2 additional-path-rx uni
     neigh 1.1.2.9 additional-path-rx uni
     red conn
     ecmp
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 1
     router-id 6.6.6.1
     neigh 1234:1::2 remote-as 2
     neigh 1234:3::1 remote-as 3
     neigh 1234:21::2 remote-as 2
     neigh 1234:23::1 remote-as 3
     neigh 1234:1::2 additional-path-tx uni
     neigh 1234:3::1 additional-path-tx uni
     neigh 1234:21::2 additional-path-tx uni
     neigh 1234:23::1 additional-path-tx uni
     neigh 1234:1::2 additional-path-rx uni
     neigh 1234:3::1 additional-path-rx uni
     neigh 1234:21::2 additional-path-rx uni
     neigh 1234:23::1 additional-path-rx uni
     red conn
     ecmp
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     exit
    int eth1.22
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.252
     ipv6 addr 1234:21::2 ffff:ffff::
     exit
    int eth2.11
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     exit
    int eth2.22
     vrf for v1
     ipv4 addr 1.1.2.5 255.255.255.252
     ipv6 addr 1234:22::1 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 2
     router-id 4.4.4.2
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.6 remote-as 3
     neigh 1.1.2.1 remote-as 1
     neigh 1.1.2.6 remote-as 3
     neigh 1.1.1.1 additional-path-tx uni
     neigh 1.1.1.6 additional-path-tx uni
     neigh 1.1.2.1 additional-path-tx uni
     neigh 1.1.2.6 additional-path-tx uni
     neigh 1.1.1.1 additional-path-rx uni
     neigh 1.1.1.6 additional-path-rx uni
     neigh 1.1.2.1 additional-path-rx uni
     neigh 1.1.2.6 additional-path-rx uni
     red conn
     ecmp
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 2
     router-id 6.6.6.2
     neigh 1234:1::1 remote-as 1
     neigh 1234:2::2 remote-as 3
     neigh 1234:21::1 remote-as 1
     neigh 1234:22::2 remote-as 3
     neigh 1234:1::1 additional-path-tx uni
     neigh 1234:2::2 additional-path-tx uni
     neigh 1234:21::1 additional-path-tx uni
     neigh 1234:22::2 additional-path-tx uni
     neigh 1234:1::1 additional-path-rx uni
     neigh 1234:2::2 additional-path-rx uni
     neigh 1234:21::1 additional-path-rx uni
     neigh 1234:22::2 additional-path-rx uni
     red conn
     ecmp
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     exit
    int eth1.22
     vrf for v1
     ipv4 addr 1.1.2.6 255.255.255.252
     ipv6 addr 1234:22::2 ffff:ffff::
     exit
    int eth2.11
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     ipv6 addr 1234:3::1 ffff:ffff::
     exit
    int eth2.22
     vrf for v1
     ipv4 addr 1.1.2.9 255.255.255.252
     ipv6 addr 1234:23::1 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 3
     router-id 4.4.4.3
     neigh 1.1.1.5 remote-as 2
     neigh 1.1.1.10 remote-as 1
     neigh 1.1.2.5 remote-as 2
     neigh 1.1.2.10 remote-as 1
     neigh 1.1.1.5 additional-path-tx uni
     neigh 1.1.1.10 additional-path-tx uni
     neigh 1.1.2.5 additional-path-tx uni
     neigh 1.1.2.10 additional-path-tx uni
     neigh 1.1.1.5 additional-path-rx uni
     neigh 1.1.1.10 additional-path-rx uni
     neigh 1.1.2.5 additional-path-rx uni
     neigh 1.1.2.10 additional-path-rx uni
     red conn
     ecmp
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 3
     router-id 6.6.6.3
     neigh 1234:2::1 remote-as 2
     neigh 1234:3::2 remote-as 1
     neigh 1234:22::1 remote-as 2
     neigh 1234:23::2 remote-as 1
     neigh 1234:2::1 additional-path-tx uni
     neigh 1234:3::2 additional-path-tx uni
     neigh 1234:22::1 additional-path-tx uni
     neigh 1234:23::2 additional-path-tx uni
     neigh 1234:2::1 additional-path-rx uni
     neigh 1234:3::2 additional-path-rx uni
     neigh 1234:22::1 additional-path-rx uni
     neigh 1234:23::2 additional-path-rx uni
     red conn
     ecmp
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 40 2.2.2.2 vrf v1 sou lo1
    r1 tping 100 40 2.2.2.3 vrf v1 sou lo1
    r1 tping 100 40 4321::2 vrf v1 sou lo1
    r1 tping 100 40 4321::3 vrf v1 sou lo1
    r2 tping 100 40 2.2.2.1 vrf v1 sou lo1
    r2 tping 100 40 2.2.2.3 vrf v1 sou lo1
    r2 tping 100 40 4321::1 vrf v1 sou lo1
    r2 tping 100 40 4321::3 vrf v1 sou lo1
    r3 tping 100 40 2.2.2.1 vrf v1 sou lo1
    r3 tping 100 40 2.2.2.2 vrf v1 sou lo1
    r3 tping 100 40 4321::1 vrf v1 sou lo1
    r3 tping 100 40 4321::2 vrf v1 sou lo1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp413](../clab/rout-bgp413/rout-bgp413.yml) file  
        3. Launch ContainerLab `rout-bgp413.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp413.yml  
        ```
        4. Destroy ContainerLab `rout-bgp413.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp413.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp413.tst` file [here](../tst/rout-bgp413.tst)  
        3. Launch `rout-bgp413.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp413 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp413.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

