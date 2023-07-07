# Example: interop8: ebgp

=== "Topology"

    ![Alt text](../d2/intop8-bgp01/intop8-bgp01.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 2
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
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
    ip forwarding
    ipv6 forwarding
    interface lo
     ip addr 2.2.2.2/32
     ipv6 addr 4321::2/128
     exit
    interface ens3
     ip address 1.1.1.2/24
     ipv6 address 1234::2/64
     no shutdown
     exit
    route-map all permit 10
     exit
    router bgp 2
     neighbor 1.1.1.1 remote-as 1
     neighbor 1234::1 remote-as 1
     address-family ipv4 unicast
      neighbor 1.1.1.1 activate
      neighbor 1.1.1.1 route-map all in
      neighbor 1.1.1.1 route-map all out
      no neighbor 1234::1 activate
      redistribute connected
     address-family ipv6 unicast
      no neighbor 1.1.1.1 activate
      neighbor 1234::1 activate
      neighbor 1234::1 route-map all in
      neighbor 1234::1 route-map all out
      redistribute connected
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234::2 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop8-bgp01](../clab/intop8-bgp01/intop8-bgp01.yml) file  
        3. Launch ContainerLab `intop8-bgp01.yml` topology:  

        ```
           containerlab deploy --topo intop8-bgp01.yml  
        ```
        4. Destroy ContainerLab `intop8-bgp01.yml` topology:  

        ```
           containerlab destroy --topo intop8-bgp01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop8-bgp01.tst` file [here](../tst/intop8-bgp01.tst)  
        3. Launch `intop8-bgp01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop8-bgp01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop8-bgp01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

