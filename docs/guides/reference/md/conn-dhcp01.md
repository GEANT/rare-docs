# Example: dhcp

=== "Topology"

    ![Alt text](../d2/conn-dhcp01/conn-dhcp01.svg)

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
     ipv6 prefix-suppress
     exit
    int lo0
     vrf for v1
     ipv4 addr 4.4.4.4 255.255.255.255
     ipv6 addr 4444::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    server dhcp4 dh4
     pool 1.1.1.2 1.1.1.199
     gateway 1.1.1.1
     netmask 255.255.255.0
     interface ethernet1
     vrf v1
     exit
    server dhcp6 dh6
     netmask ffff:ffff:ffff:ffff::
     gateway 1234::1
     interface ethernet1
     vrf v1
     exit
    ```

    **r2**

    ```
    hostname r2
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
     ipv4 gateway-prefix p4
     ipv6 addr 3333::3 ffff::
     ipv6 dhcp-client enable
     ipv6 gateway-prefix p6
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 20 1.1.1.1 vrf v1
    r2 tping 100 20 1234::1 vrf v1
    r2 tping 100 5 4.4.4.4 vrf v1
    r2 tping 100 5 4444::4 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-dhcp01](../clab/conn-dhcp01/conn-dhcp01.yml) file  
        3. Launch ContainerLab `conn-dhcp01.yml` topology:  

        ```
           containerlab deploy --topo conn-dhcp01.yml  
        ```
        4. Destroy ContainerLab `conn-dhcp01.yml` topology:  

        ```
           containerlab destroy --topo conn-dhcp01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-dhcp01.tst` file [here](../tst/conn-dhcp01.tst)  
        3. Launch `conn-dhcp01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-dhcp01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-dhcp01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

