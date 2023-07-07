# Example: interop1: dhcp client

=== "Topology"

    ![Alt text](../d2/intop1-dhcp02/intop1-dhcp02.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    prefix-list p4
     permit 0.0.0.0/0
     exit
    prefix-list p6
     permit ::/0
     exit
    int eth1
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.128
     ipv4 dhcp-client enable
     ipv4 dhcp-client early
     ipv4 gateway-prefix p4
     ipv6 addr 3333::3 ffff::
     ipv6 dhcp-client enable
     ipv6 dhcp-client prefix
     ipv6 gateway-prefix p6
     exit
    ```

    **r2**

    ```
    hostname r2
    ip routing
    ipv6 unicast-routing
    ipv6 local pool dhcpv6 1234:1234:1234::/40 48
    ipv6 dhcp pool dhcpv6
     prefix-delegation pool dhcpv6 lifetime 1800 1800
     exit
    interface loop0
     ipv6 address 4321::1/128
     exit
    interface gigabit1
     ip address 1.1.1.1 255.255.255.0
     ipv6 enable
     ipv6 dhcp server dhcpv6
     no shutdown
     exit
    ip dhcp pool p1
     network 1.1.1.0 255.255.255.0
     default-router 1.1.1.1
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 30 1.1.1.1 vrf v1
    r1 tping 100 30 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-dhcp02](../clab/intop1-dhcp02/intop1-dhcp02.yml) file  
        3. Launch ContainerLab `intop1-dhcp02.yml` topology:  

        ```
           containerlab deploy --topo intop1-dhcp02.yml  
        ```
        4. Destroy ContainerLab `intop1-dhcp02.yml` topology:  

        ```
           containerlab destroy --topo intop1-dhcp02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-dhcp02.tst` file [here](../tst/intop1-dhcp02.tst)  
        3. Launch `intop1-dhcp02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-dhcp02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-dhcp02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

