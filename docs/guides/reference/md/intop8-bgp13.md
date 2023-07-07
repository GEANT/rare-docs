# Example: interop8: bgp large community

=== "Topology"

    ![Alt text](../d2/intop8-bgp13/intop8-bgp13.svg)

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
    route-map rm1
     sequence 10 act deny
      match lrgcomm 1234:1234:4321
     sequence 20 act permit
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 1
     neigh 1.1.1.2 route-map-in rm1
     red conn
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.1
     neigh 1234::2 remote-as 1
     neigh 1234::2 route-map-in rm1
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
     ip addr 2.2.2.3/32
     ip addr 2.2.2.4/32
     ipv6 addr 4321::2/128
     ipv6 addr 4321::3/128
     ipv6 addr 4321::4/128
     exit
    interface ens3
     ip address 1.1.1.2/24
     ipv6 address 1234::2/64
     no shutdown
     exit
    ip prefix-list pl1 seq 5 permit 2.2.2.3/32
    route-map rm1 permit 10
     match ip address prefix-list pl1
     set large-community 1234:1234:4321
    route-map rm1 permit 20
     set large-community 1234:1234:1234
    ipv6 prefix-list pl2 seq 5 permit 4321::3/128
    route-map rm2 permit 10
     match ipv6 address prefix-list pl2
     set large-community 1234:1234:4321
    route-map rm2 permit 20
     set large-community 1234:1234:1234
    router bgp 1
     neighbor 1.1.1.1 remote-as 1
     neighbor 1234::1 remote-as 1
     address-family ipv4 unicast
      neighbor 1.1.1.1 activate
      no neighbor 1234::1 activate
      redistribute connected route-map rm1
     address-family ipv6 unicast
      no neighbor 1.1.1.1 activate
      neighbor 1234::1 activate
      redistribute connected route-map rm2
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234::2 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 0 60 2.2.2.3 vrf v1 sou lo0
    r1 tping 0 60 4321::3 vrf v1 sou lo0
    r1 tping 100 60 2.2.2.4 vrf v1 sou lo0
    r1 tping 100 60 4321::4 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop8-bgp13](../clab/intop8-bgp13/intop8-bgp13.yml) file  
        3. Launch ContainerLab `intop8-bgp13.yml` topology:  

        ```
           containerlab deploy --topo intop8-bgp13.yml  
        ```
        4. Destroy ContainerLab `intop8-bgp13.yml` topology:  

        ```
           containerlab destroy --topo intop8-bgp13.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop8-bgp13.tst` file [here](../tst/intop8-bgp13.tst)  
        3. Launch `intop8-bgp13.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop8-bgp13 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop8-bgp13.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

