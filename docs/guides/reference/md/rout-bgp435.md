# Example: unicast+ouni over bgp route server

=== "Topology"

    ![Alt text](../d2/rout-bgp435/rout-bgp435.svg)

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
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni ouni
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.3 remote-as 3
     afi-other ena
     no afi-other vpn
     afi-other red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni ouni
     local-as 1
     router-id 6.6.6.1
     neigh 1234:1::3 remote-as 3
     afi-other ena
     no afi-other vpn
     afi-other red conn
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
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni ouni
     local-as 2
     router-id 4.4.4.2
     neigh 1.1.1.3 remote-as 3
     afi-other ena
     no afi-other vpn
     afi-other red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni ouni
     local-as 2
     router-id 6.6.6.2
     neigh 1234:1::3 remote-as 3
     afi-other ena
     no afi-other vpn
     afi-other red conn
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
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234:1::3 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni ouni
     local-as 3
     router-id 4.4.4.3
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 route-server
     neigh 1.1.1.2 remote-as 2
     neigh 1.1.1.2 route-server
     afi-other ena
     no afi-other vpn
     afi-other red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni ouni
     local-as 3
     router-id 6.6.6.3
     neigh 1234:1::1 remote-as 1
     neigh 1234:1::1 route-server
     neigh 1234:1::2 remote-as 2
     neigh 1234:1::2 route-server
     afi-other ena
     no afi-other vpn
     afi-other red conn
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
        2. Fetch [rout-bgp435](../clab/rout-bgp435/rout-bgp435.yml) file  
        3. Launch ContainerLab `rout-bgp435.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp435.yml  
        ```
        4. Destroy ContainerLab `rout-bgp435.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp435.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp435.tst` file [here](../tst/rout-bgp435.tst)  
        3. Launch `rout-bgp435.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp435 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp435.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

