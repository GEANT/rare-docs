# Example: interop2: bgp 6pe

=== "Topology"

    ![Alt text](../d2/intop2-bgp21/intop2-bgp21.svg)

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
     mpls enable
     mpls ldp4
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    router bgp4 1
     vrf v1
     address olab
     local-as 1
     router-id 4.4.4.1
     neigh 2.2.2.2 remote-as 1
     neigh 2.2.2.2 update lo0
     neigh 2.2.2.2 send-comm both
     afi-other ena
     afi-other red conn
     exit
    ```

    **r2**

    ```
    hostname r2
    interface loopback0
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2/128
     exit
    interface gigabit0/0/0/0
     ipv4 address 1.1.1.2 255.255.255.0
     no shutdown
     exit
    mpls ldp
     address-family ipv4
     interface gigabit0/0/0/0
      address-family ipv4
    router static
     address-family ipv4 unicast 2.2.2.1/32 1.1.1.1 gigabit0/0/0/0
     exit
    router bgp 1
     address-family ipv4 unicast
      allocate-label all
      redistribute connected
     address-family ipv6 unicast
      allocate-label all
      redistribute connected
     neighbor 2.2.2.1
      remote-as 1
      update-source loopback0
      address-family ipv4 labeled-unicast
      address-family ipv6 labeled-unicast
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 60 4321::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop2-bgp21](../clab/intop2-bgp21/intop2-bgp21.yml) file  
        3. Launch ContainerLab `intop2-bgp21.yml` topology:  

        ```
           containerlab deploy --topo intop2-bgp21.yml  
        ```
        4. Destroy ContainerLab `intop2-bgp21.yml` topology:  

        ```
           containerlab destroy --topo intop2-bgp21.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop2-bgp21.tst` file [here](../tst/intop2-bgp21.tst)  
        3. Launch `intop2-bgp21.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop2-bgp21 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop2-bgp21.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

