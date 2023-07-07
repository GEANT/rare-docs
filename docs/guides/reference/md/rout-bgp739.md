# Example: ocar bgp ingress route filtering with routemap

=== "Topology"

    ![Alt text](../d2/rout-bgp739/rout-bgp739.svg)

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
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.11 255.255.255.255
     ipv6 addr 4321::11 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.21 255.255.255.255
     ipv6 addr 4321::21 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     mpls enable
     exit
    route-map p4
     sequence 10 act deny
      match network 2.2.2.12/32
     sequence 20 act perm
      match network 0.0.0.0/0 le 32
     exit
    route-map p6
     sequence 10 act deny
      match network 4321::12/128
     sequence 20 act perm
      match network ::/0 le 128
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address ocar
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 2
     neigh 1.1.1.2 other-route-map-in p6
     afi-other ena
     afi-other red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address ocar
     local-as 1
     router-id 6.6.6.1
     neigh 1234:1::2 remote-as 2
     neigh 1234:1::2 other-route-map-in p4
     afi-other ena
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
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.12 255.255.255.255
     ipv6 addr 4321::12 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.22 255.255.255.255
     ipv6 addr 4321::22 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     mpls enable
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address ocar
     local-as 2
     router-id 4.4.4.2
     neigh 1.1.1.1 remote-as 1
     afi-other ena
     afi-other red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address ocar
     local-as 2
     router-id 6.6.6.2
     neigh 1234:1::1 remote-as 1
     afi-other ena
     afi-other red conn
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1
    r1 tping 100 60 4321::2 vrf v1
    r1 tping 0 60 2.2.2.12 vrf v1
    r1 tping 0 60 4321::12 vrf v1
    r1 tping 100 60 2.2.2.22 vrf v1
    r1 tping 100 60 4321::22 vrf v1
    r2 tping 100 60 2.2.2.1 vrf v1
    r2 tping 100 60 4321::1 vrf v1
    r2 tping 100 60 2.2.2.11 vrf v1
    r2 tping 100 60 4321::11 vrf v1
    r2 tping 100 60 2.2.2.21 vrf v1
    r2 tping 100 60 4321::21 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp739](../clab/rout-bgp739/rout-bgp739.yml) file  
        3. Launch ContainerLab `rout-bgp739.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp739.yml  
        ```
        4. Destroy ContainerLab `rout-bgp739.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp739.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp739.tst` file [here](../tst/rout-bgp739.tst)  
        3. Launch `rout-bgp739.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp739 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp739.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

