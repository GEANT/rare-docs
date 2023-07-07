# Example: interop1: dhcp server

=== "Topology"

    ![Alt text](../d2/intop1-dhcp01/intop1-dhcp01.svg)

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
    server dhcp4 dh
     pool 1.1.1.11 1.1.1.99
     gateway 1.1.1.1
     netmask 255.255.255.0
     interface ethernet1
     static 0000.0000.1100 1.1.1.2
     vrf v1
     exit
    server dhcp6 dh
     netmask ffff:ffff:ffff:ffff::
     gateway 1234::1
     static 0000.0000.1100 1234::2
     interface ethernet1
     vrf v1
     exit
    ```

    **r2**

    ```
    hostname r2
    ip routing
    ipv6 unicast-routing
    interface loop0
     ipv6 address fe80::1 link-local
     ipv6 enable
     ipv6 address prefix ::/128
     exit
    interface gigabit1
     ip address dhcp
     ipv6 address fe80::1 link-local
     ipv6 enable
     ipv6 dhcp client pd hint 1234::2/64
     ipv6 dhcp client pd prefix
     no shutdown
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 30 1.1.1.2 vrf v1
    !r1 tping 100 30 1234::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-dhcp01](../clab/intop1-dhcp01/intop1-dhcp01.yml) file  
        3. Launch ContainerLab `intop1-dhcp01.yml` topology:  

        ```
           containerlab deploy --topo intop1-dhcp01.yml  
        ```
        4. Destroy ContainerLab `intop1-dhcp01.yml` topology:  

        ```
           containerlab destroy --topo intop1-dhcp01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-dhcp01.tst` file [here](../tst/intop1-dhcp01.tst)  
        3. Launch `intop1-dhcp01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-dhcp01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-dhcp01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

