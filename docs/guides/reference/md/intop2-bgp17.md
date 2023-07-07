# Example: interop2: bgp extended community

=== "Topology"

    ![Alt text](../d2/intop2-bgp17/intop2-bgp17.svg)

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
      match extcomm 17153:33036:1234
     sequence 20 act permit
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 1
     neigh 1.1.1.2 route-map-in rm1
     neigh 1.1.1.2 send-comm both
     red conn
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.1
     neigh 1234::2 remote-as 1
     neigh 1234::2 route-map-in rm1
     neigh 1234::2 send-comm both
     red conn
     exit
    ```

    **r2**

    ```
    hostname r2
    interface loopback0
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2/128
     exit
    interface loopback1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3/128
     exit
    interface loopback2
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4/128
     exit
    interface gigabit0/0/0/0
     ipv4 address 1.1.1.2 255.255.255.0
     ipv6 address 1234::2/64
     no shutdown
     exit
    route-policy rp1
     if destination in (2.2.2.3/32, 4321::3/128) then
      set extcommunity cost (igp:12:1234)
     else
      set extcommunity cost (igp:23:4321)
     endif
     pass
     end-policy
    router bgp 1
     address-family ipv4 unicast
      redistribute connected route-policy rp1
     address-family ipv6 unicast
      redistribute connected route-policy rp1
     neighbor 1.1.1.1
      remote-as 1
      address-family ipv4 unicast
     neighbor 1234::1
      remote-as 1
      address-family ipv6 unicast
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
        2. Fetch [intop2-bgp17](../clab/intop2-bgp17/intop2-bgp17.yml) file  
        3. Launch ContainerLab `intop2-bgp17.yml` topology:  

        ```
           containerlab deploy --topo intop2-bgp17.yml  
        ```
        4. Destroy ContainerLab `intop2-bgp17.yml` topology:  

        ```
           containerlab destroy --topo intop2-bgp17.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop2-bgp17.tst` file [here](../tst/intop2-bgp17.tst)  
        3. Launch `intop2-bgp17.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop2-bgp17 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop2-bgp17.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

