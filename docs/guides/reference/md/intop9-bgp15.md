# Example: interop9: vpls/bgp over bgp

=== "Topology"

    ![Alt text](../d2/intop9-bgp15/intop9-bgp15.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    bridge 1
     rd 1:1
     rt-both 1:1
     mac-learn
     private
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int bvi1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.252
     ipv6 addr 3333::1 ffff::
     exit
    router bgp4 1
     vrf v1
     address vpls
     local-as 1
     router-id 4.4.4.1
     neigh 2.2.2.2 remote-as 1
     neigh 2.2.2.2 update lo0
     neigh 2.2.2.2 send-comm both
     afi-vpls 1:1 bridge 1
     afi-vpls 1:1 ve-id 1 10
     afi-vpls 1:1 update lo0
     exit
    router bgp6 1
     vrf v1
     address vpls
     local-as 1
     router-id 6.6.6.1
     neigh 4321::2 remote-as 1
     neigh 4321::2 update lo0
     neigh 4321::2 send-comm both
     exit
    ```

    **r2**

    ```
    hostname r2
    set interfaces ge-0/0/0.0 family inet address 1.1.1.2/24
    set interfaces ge-0/0/0.0 family inet6 address 1234::2/64
    set interfaces ge-0/0/0.0 family mpls
    set interfaces lo0.0 family inet address 2.2.2.2/32
    set interfaces lo0.0 family inet6 address 4321::2/128
    set protocols ldp interface ge-0/0/0.0
    set protocols mpls interface ge-0/0/0.0
    set routing-options rib inet.0 static route 2.2.2.1/32 next-hop 1.1.1.1
    set routing-options rib inet6.0 static route 4321::1/128 next-hop 1234::1
    set routing-options autonomous-system 1
    set protocols bgp group peers type internal
    set protocols bgp group peers peer-as 1
    set protocols bgp group peers neighbor 2.2.2.1
    set protocols bgp group peers local-address 2.2.2.2
    set protocols bgp group peers family l2vpn signaling
    set interfaces ge-0/0/1 encapsulation ethernet-vpls
    set interfaces ge-0/0/1.0 family vpls
    set routing-instances b1 instance-type vpls
    set routing-instances b1 vlan-id none
    set routing-instances b1 interface ge-0/0/1.0
    set routing-instances b1 route-distinguisher 1:1
    set routing-instances b1 vrf-target target:1:1
    set routing-instances b1 protocols vpls no-tunnel-services
    set routing-instances b1 protocols vpls site-range 10
    set routing-instances b1 protocols vpls site s2 site-identifier 2
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     ipv6 addr 3333::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234::2 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 3.3.3.2 vrf v1
    r1 tping 100 60 3333::2 vrf v1
    r3 tping 100 60 3.3.3.1 vrf v1
    r3 tping 100 60 3333::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop9-bgp15](../clab/intop9-bgp15/intop9-bgp15.yml) file  
        3. Launch ContainerLab `intop9-bgp15.yml` topology:  

        ```
           containerlab deploy --topo intop9-bgp15.yml  
        ```
        4. Destroy ContainerLab `intop9-bgp15.yml` topology:  

        ```
           containerlab destroy --topo intop9-bgp15.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop9-bgp15.tst` file [here](../tst/intop9-bgp15.tst)  
        3. Launch `intop9-bgp15.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop9-bgp15 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop9-bgp15.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

