# Example: interop1: pim

=== "Topology"

    ![Alt text](../d2/intop1-mcast02/intop1-mcast02.svg)

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
     ipv4 pim ena
     ipv6 pim ena
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr fe80::1 ffff::
     ipv4 pim ena
     ipv6 pim ena
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff fe80::2
    ```

    **r2**

    ```
    hostname r2
    ip routing
    ipv6 unicast-routing
    ip multicast-routing distributed
    ipv6 multicast-routing
    ip pim ssm default
    interface gigabit1
     ip address 1.1.1.2 255.255.255.0
     ipv6 enable
     ipv6 address fe80::2 link-local
     ip pim sparse-mode
     ip igmp version 3
     ipv6 pim
     no shutdown
     exit
    ip route 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route 4321::1/128 gigabit1 fe80::1
    interface loopback0
     ip addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2/128
     ip pim sparse-mode
     ip igmp version 3
     ipv6 pim
     ip igmp join-group 232.2.2.2 source 2.2.2.1
     ipv6 mld join-group ff06::1 4321::1
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r1 tping 100 60 232.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 ff06::1 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-mcast02](../clab/intop1-mcast02/intop1-mcast02.yml) file  
        3. Launch ContainerLab `intop1-mcast02.yml` topology:  

        ```
           containerlab deploy --topo intop1-mcast02.yml  
        ```
        4. Destroy ContainerLab `intop1-mcast02.yml` topology:  

        ```
           containerlab destroy --topo intop1-mcast02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-mcast02.tst` file [here](../tst/intop1-mcast02.tst)  
        3. Launch `intop1-mcast02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-mcast02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-mcast02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

