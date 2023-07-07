# Example: ebgp with safe policy

=== "Topology"

    ![Alt text](../d2/rout-bgp563/rout-bgp563.svg)

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
     ipv6 addr 1234::1 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     safe-ebgp
     address uni
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 2
     red conn
     exit
    router bgp6 1
     vrf v1
     safe-ebgp
     address uni
     local-as 1
     router-id 6.6.6.1
     neigh 1234::2 remote-as 2
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
     no safe-ebgp
     address uni
     local-as 2
     router-id 4.4.4.2
     neigh 1.1.1.1 remote-as 1
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 2
     router-id 6.6.6.2
     neigh 1234::1 remote-as 1
     red conn
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 1.1.1.2 vrf v1
    r1 tping 100 60 1234::2 vrf v1
    r2 tping 100 60 1.1.1.1 vrf v1
    r2 tping 100 60 1234::1 vrf v1
    r1 tping 0 60 2.2.2.2 vrf v1
    r1 tping 0 60 4321::2 vrf v1
    r2 tping 0 60 2.2.2.1 vrf v1
    r2 tping 0 60 4321::1 vrf v1
    r1 send conf t
    r1 send router bgp4 1
    r1 send no safe-ebgp
    r1 send exit
    r1 send router bgp6 1
    r1 send no safe-ebgp
    r1 send end
    r1 tping 100 60 2.2.2.2 vrf v1
    r1 tping 100 60 4321::2 vrf v1
    r2 tping 100 60 2.2.2.1 vrf v1
    r2 tping 100 60 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp563](../clab/rout-bgp563/rout-bgp563.yml) file  
        3. Launch ContainerLab `rout-bgp563.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp563.yml  
        ```
        4. Destroy ContainerLab `rout-bgp563.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp563.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp563.tst` file [here](../tst/rout-bgp563.tst)  
        3. Launch `rout-bgp563.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp563 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp563.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

