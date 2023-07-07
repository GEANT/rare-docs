# Example: rift with bgp linkstate

=== "Topology"

    ![Alt text](../d2/rout-rift24/rout-rift24.svg)

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
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.101 255.255.255.255
     ipv6 addr 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    router rift4 1
     vrf v1
     router 41
     justadvert lo1
     exit
    router rift6 1
     vrf v1
     router 61
     justadvert lo1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     router rift4 1 ena
     router rift6 1 ena
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni linkstate
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 2
     neigh 1.1.1.2 linkstate
     afi-link rift4 1 0
     justadvert lo2
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni linkstate
     local-as 1
     router-id 6.6.6.1
     neigh 1234::2 remote-as 2
     neigh 1234::2 linkstate
     afi-link rift6 1 0
     justadvert lo2
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
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.102 255.255.255.255
     ipv6 addr 4321::102 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    router rift4 1
     vrf v1
     router 42
     justadvert lo1
     exit
    router rift6 1
     vrf v1
     router 62
     justadvert lo1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     router rift4 1 ena
     router rift6 1 ena
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni linkstate
     local-as 2
     router-id 4.4.4.2
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 linkstate
     afi-link rift4 1 0
     justadvert lo2
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni linkstate
     local-as 2
     router-id 6.6.6.2
     neigh 1234::1 remote-as 1
     neigh 1234::1 linkstate
     afi-link rift6 1 0
     justadvert lo2
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r2 tping 100 20 4321::1 vrf v1
    r1 tping 100 20 2.2.2.102 vrf v1
    r2 tping 100 20 2.2.2.101 vrf v1
    r1 tping 100 20 4321::102 vrf v1
    r2 tping 100 20 4321::101 vrf v1
    r2 output show ipv4 rift 1 nei
    r2 output show ipv6 rift 1 nei
    r2 output show ipv4 rift 1 dat
    r2 output show ipv6 rift 1 dat
    r2 output show ipv4 rift 1 tre n
    r2 output show ipv6 rift 1 tre n
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    r1 output show ipv4 bgp 1 uni dat
    r1 output show ipv6 bgp 1 uni dat
    r1 output show ipv4 bgp 1 links dat
    r1 output show ipv6 bgp 1 links dat
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-rift24](../clab/rout-rift24/rout-rift24.yml) file  
        3. Launch ContainerLab `rout-rift24.yml` topology:  

        ```
           containerlab deploy --topo rout-rift24.yml  
        ```
        4. Destroy ContainerLab `rout-rift24.yml` topology:  

        ```
           containerlab destroy --topo rout-rift24.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-rift24.tst` file [here](../tst/rout-rift24.tst)  
        3. Launch `rout-rift24.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-rift24 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-rift24.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

