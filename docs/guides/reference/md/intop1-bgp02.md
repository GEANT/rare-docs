# Example: interop1: ibgp

=== "Topology"

    ![Alt text](../d2/intop1-bgp02/intop1-bgp02.svg)

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
     neigh 1234::2 remote-as 1
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
    interface gigabit1
     ip address 1.1.1.2 255.255.255.0
     ipv6 address 1234::2/64
     no shutdown
     exit
    router bgp 1
     address-family ipv4 unicast
      neighbor 1.1.1.1 remote-as 1
      redistribute connected
     address-family ipv6 unicast
      neighbor 1234::1 remote-as 1
      redistribute connected
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234::2 vrf v1
    r1 tping 100 120 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 120 4321::2 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-bgp02](../clab/intop1-bgp02/intop1-bgp02.yml) file  
        3. Launch ContainerLab `intop1-bgp02.yml` topology:  

        ```
           containerlab deploy --topo intop1-bgp02.yml  
        ```
        4. Destroy ContainerLab `intop1-bgp02.yml` topology:  

        ```
           containerlab destroy --topo intop1-bgp02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-bgp02.tst` file [here](../tst/intop1-bgp02.tst)  
        3. Launch `intop1-bgp02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-bgp02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-bgp02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

