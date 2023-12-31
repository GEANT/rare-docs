# Example: interop2: igmp3/mld2

=== "Topology"

    ![Alt text](../d2/intop2-mcast01/intop2-mcast01.svg)

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
     ipv4 multi host-ena
     ipv4 multi host-pro
     ipv6 multi host-ena
     ipv6 multi host-pro
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 address 1234::1 ffff::
     ipv4 multi host-ena
     ipv4 multi host-pro
     ipv6 multi host-ena
     ipv6 multi host-pro
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
    ```

    **r2**

    ```
    hostname r2
    interface gigabit0/0/0/0
     ipv4 address 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2/64
     no shutdown
     exit
    interface loopback0
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2/128
     exit
    router static
     address-family ipv4 unicast 2.2.2.1/32 gigabit0/0/0/0 1.1.1.1
     address-family ipv6 unicast 4321::1/128 gigabit0/0/0/0 1234::1
     address-family ipv4
      interface Loopback0 enable
      interface gigabit0/0/0/0 enable
      static-rpf 2.2.2.1 32 gigabit0/0/0/0 1.1.1.1
     address-family ipv6
      interface Loopback0 enable
      interface gigabit0/0/0/0 enable
      static-rpf 4321::1 128 gigabit0/0/0/0 1234::1
    router pim
     address-family ipv4
      interface Loopback0 enable
      interface gigabit0/0/0/0 enable
     address-family ipv6
      interface Loopback0 enable
      interface gigabit0/0/0/0 enable
    router igmp interface gigabit0/0/0/0
      join-group 232.2.2.2 2.2.2.1
      version 3
    router mld interface gigabit0/0/0/0
      join-group ff06::1 4321::1
      version 2
    router igmp
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
        2. Fetch [intop2-mcast01](../clab/intop2-mcast01/intop2-mcast01.yml) file  
        3. Launch ContainerLab `intop2-mcast01.yml` topology:  

        ```
           containerlab deploy --topo intop2-mcast01.yml  
        ```
        4. Destroy ContainerLab `intop2-mcast01.yml` topology:  

        ```
           containerlab destroy --topo intop2-mcast01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop2-mcast01.tst` file [here](../tst/intop2-mcast01.tst)  
        3. Launch `intop2-mcast01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop2-mcast01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop2-mcast01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

