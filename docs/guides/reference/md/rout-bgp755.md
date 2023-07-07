# Example: ocar+octp over ebgp

=== "Topology"

    ![Alt text](../d2/rout-bgp755/rout-bgp755.svg)

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
     mpls ena
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address ocar octp
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 2
     afi-other ena
     afi-other red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address ocar octp
     local-as 1
     router-id 6.6.6.1
     neigh 1234:1::2 remote-as 2
     afi-other ena
     afi-other red conn
     exit
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     pseudo v1 lo0 pweompls 2.2.2.2 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 3.3.4.1 255.255.255.0
     pseudo v1 lo0 pweompls 4321::2 1234
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
     mpls ena
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address ocar octp
     local-as 2
     router-id 4.4.4.2
     neigh 1.1.1.1 remote-as 1
     afi-other ena
     afi-other red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address ocar octp
     local-as 2
     router-id 6.6.6.2
     neigh 1234:1::1 remote-as 1
     afi-other ena
     afi-other red conn
     exit
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     pseudo v1 lo0 pweompls 2.2.2.1 1234
     exit
    int pweth2
     vrf for v1
     ipv4 addr 3.3.4.2 255.255.255.0
     pseudo v1 lo0 pweompls 4321::1 1234
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 60 4321::1 vrf v1 sou lo0
    r1 tping 100 40 3.3.3.2 vrf v1
    r2 tping 100 40 3.3.3.1 vrf v1
    r1 tping 100 40 3.3.4.2 vrf v1
    r2 tping 100 40 3.3.4.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp755](../clab/rout-bgp755/rout-bgp755.yml) file  
        3. Launch ContainerLab `rout-bgp755.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp755.yml  
        ```
        4. Destroy ContainerLab `rout-bgp755.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp755.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp755.tst` file [here](../tst/rout-bgp755.tst)  
        3. Launch `rout-bgp755.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp755 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp755.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

