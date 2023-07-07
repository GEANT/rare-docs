# Example: interop1: bgp aspath

=== "Topology"

    ![Alt text](../d2/intop1-bgp07/intop1-bgp07.svg)

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
      match aspath .*1234.*
     sequence 20 act permit
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 2
     neigh 1.1.1.2 route-map-in rm1
     red conn
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 1
     router-id 6.6.6.1
     neigh 1234::2 remote-as 2
     neigh 1234::2 route-map-in rm1
     red conn
     exit
    ```

    **r2**

    ```
    hostname r2
    ip routing
    ipv6 unicast-routing
    interface loopback0
     ip addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2/128
     exit
    interface loopback1
     ip addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3/128
     exit
    interface loopback2
     ip addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4/128
     exit
    interface gigabit1
     ip address 1.1.1.2 255.255.255.0
     ipv6 address 1234::2/64
     no shutdown
     exit
    ip prefix-list pl4 seq 5 permit 2.2.2.3/32
    ipv6 prefix-list pl6 seq 5 permit 4321::3/128
    route-map rm4 permit 10
     match ip address prefix-list pl4
     set as-path prepend 1234
     exit
    route-map rm4 permit 20
     set as-path prepend 4321
     exit
    route-map rm6 permit 10
     match ipv6 address prefix-list pl6
     set as-path prepend 1234
     exit
    route-map rm6 permit 20
     set as-path prepend 4321
     exit
    router bgp 2
     address-family ipv4 unicast
      neighbor 1.1.1.1 remote-as 1
      neighbor 1.1.1.1 route-map rm4 out
      redistribute connected
     address-family ipv6 unicast
      neighbor 1234::1 remote-as 1
      neighbor 1234::1 route-map rm6 out
      redistribute connected
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234::2 vrf v1
    r1 tping 100 120 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 120 4321::2 vrf v1 sou lo0
    r1 tping 0 120 2.2.2.3 vrf v1 sou lo0
    r1 tping 0 120 4321::3 vrf v1 sou lo0
    r1 tping 100 120 2.2.2.4 vrf v1 sou lo0
    r1 tping 100 120 4321::4 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-bgp07](../clab/intop1-bgp07/intop1-bgp07.yml) file  
        3. Launch ContainerLab `intop1-bgp07.yml` topology:  

        ```
           containerlab deploy --topo intop1-bgp07.yml  
        ```
        4. Destroy ContainerLab `intop1-bgp07.yml` topology:  

        ```
           containerlab destroy --topo intop1-bgp07.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-bgp07.tst` file [here](../tst/intop1-bgp07.tst)  
        3. Launch `intop1-bgp07.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-bgp07 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-bgp07.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

