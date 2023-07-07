# Example: bgp distance

=== "Topology"

    ![Alt text](../d2/rout-bgp066/rout-bgp066.svg)

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
     ipv4 addr 2.2.2.111 255.255.255.255
     ipv6 addr 4321::111 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.222 255.255.255.255
     ipv6 addr 4321::222 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    server telnet tel
     vrf v1
     port 666
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 1
     red conn
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.1
     neigh 1234:1::2 remote-as 1
     red conn
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
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     exit
    prefix-list p4
     sequence 10 deny 2.2.2.222/32
     sequence 20 permit 0.0.0.0/0 le 32
     exit
    prefix-list p6
     sequence 10 deny 4321::222/128
     sequence 20 permit ::/0 le 128
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.2
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 prefix-list-in p4
     neigh 1.1.1.1 distance 123
     neigh 1.1.1.6 remote-as 1
     neigh 1.1.1.6 prefix-list-in p4
     neigh 1.1.1.6 distance 234
     red conn
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.2
     neigh 1234:1::1 remote-as 1
     neigh 1234:1::1 prefix-list-in p6
     neigh 1234:1::1 distance 123
     neigh 1234:2::2 remote-as 1
     neigh 1234:2::2 prefix-list-in p6
     neigh 1234:2::2 distance 234
     red conn
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.111 255.255.255.255
     ipv6 addr 4321::111 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.3
     neigh 1.1.1.5 remote-as 1
     red conn
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.3
     neigh 1234:2::1 remote-as 1
     red conn
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1
    r1 tping 100 60 4321::2 vrf v1
    r1 tping 0 60 2.2.2.3 vrf v1
    r1 tping 0 60 4321::3 vrf v1
    r3 tping 0 60 2.2.2.1 vrf v1
    r3 tping 0 60 4321::1 vrf v1
    r3 tping 100 60 2.2.2.2 vrf v1
    r3 tping 100 60 4321::2 vrf v1
    r2 tping 100 60 2.2.2.1 vrf v1
    r2 tping 100 60 4321::1 vrf v1
    r2 tping 100 60 2.2.2.3 vrf v1
    r2 tping 100 60 4321::3 vrf v1
    r2 tping 100 60 2.2.2.111 vrf v1
    r2 tping 100 60 4321::111 vrf v1
    r2 tping 0 60 2.2.2.222 vrf v1
    r2 tping 0 60 4321::222 vrf v1
    r2 send telnet 2.2.2.111 666 vrf v1
    r2 tping 100 60 2.2.2.222 vrf v1
    r2 send exit
    r2 read closed
    r2 tping 0 60 2.2.2.222 vrf v1
    r2 send telnet 4321::111 666 vrf v1
    r2 tping 100 60 2.2.2.222 vrf v1
    r2 send exit
    r2 read closed
    r2 tping 0 60 2.2.2.222 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp066](../clab/rout-bgp066/rout-bgp066.yml) file  
        3. Launch ContainerLab `rout-bgp066.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp066.yml  
        ```
        4. Destroy ContainerLab `rout-bgp066.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp066.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp066.tst` file [here](../tst/rout-bgp066.tst)  
        3. Launch `rout-bgp066.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp066 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp066.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

