# Example: interop9: ethernet over mpls

=== "Topology"

    ![Alt text](../d2/intop9-ldp02/intop9-ldp02.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    proxy-profile p1
     vrf v1
     source lo0
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    bridge 1
     mac-learn
     exit
    int bvi1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     ipv6 addr 3333::1 ffff::
     exit
    vpdn eompls
     bridge-gr 1
     proxy p1
     target 2.2.2.2
     mtu 1500
     vcid 1234
     pwtype eth
     protocol pweompls
     exit
    ```

    **r2**

    ```
    hostname r2
    set interfaces ge-0/0/0.0 family inet address 1.1.1.2/24
    set interfaces ge-0/0/0.0 family inet6 address 1234:1::2/64
    set interfaces ge-0/0/0.0 family mpls
    set interfaces lo0.0 family inet address 2.2.2.2/32
    set interfaces lo0.0 family inet6 address 4321::2/128
    set protocols ldp interface ge-0/0/0.0
    set protocols ldp interface lo0.0
    set protocols mpls interface ge-0/0/0.0
    set routing-options rib inet.0 static route 2.2.2.1/32 next-hop 1.1.1.1
    set routing-options rib inet6.0 static route 4321::1/128 next-hop 1234:1::1
    set interfaces ge-0/0/1 encapsulation ethernet-ccc
    set interfaces ge-0/0/1.0 family ccc
    set protocols l2circuit neighbor 2.2.2.1 interface ge-0/0/1.0 virtual-circuit-id 1234
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
    r1 tping 100 10 1234:1::2 vrf v1
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 10 4321::2 vrf v1 sou lo0
    r1 tping 100 60 3.3.3.2 vrf v1
    r1 tping 100 60 3333::2 vrf v1
    r3 tping 100 60 3.3.3.1 vrf v1
    r3 tping 100 60 3333::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop9-ldp02](../clab/intop9-ldp02/intop9-ldp02.yml) file  
        3. Launch ContainerLab `intop9-ldp02.yml` topology:  

        ```
           containerlab deploy --topo intop9-ldp02.yml  
        ```
        4. Destroy ContainerLab `intop9-ldp02.yml` topology:  

        ```
           containerlab destroy --topo intop9-ldp02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop9-ldp02.tst` file [here](../tst/intop9-ldp02.tst)  
        3. Launch `intop9-ldp02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop9-ldp02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop9-ldp02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

