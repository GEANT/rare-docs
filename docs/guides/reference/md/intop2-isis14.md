# Example: interop2: integrated isis

=== "Topology"

    ![Alt text](../d2/intop2-isis14/intop2-isis14.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.1111.00
     red conn
     afi-other enable
     afi-other red conn
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr fe80::1 ffff::
     router isis4 1 ena
     router isis4 1 other-ena
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    ```

    **r2**

    ```
    hostname r2
    interface loopback0
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2/128
     exit
    interface gigabit0/0/0/0
     ipv4 address 1.1.1.2 255.255.255.0
     ipv6 enable
     no shutdown
     exit
    router isis 1
     net 48.0000.0000.1234.00
     address-family ipv4 unicast
      metric-style wide
      redistribute connected
     address-family ipv6 unicast
      metric-style wide
      single-topology
      redistribute connected
     interface gigabit0/0/0/0
      point-to-point
      address-family ipv4 unicast
      address-family ipv6 unicast
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop2-isis14](../clab/intop2-isis14/intop2-isis14.yml) file  
        3. Launch ContainerLab `intop2-isis14.yml` topology:  

        ```
           containerlab deploy --topo intop2-isis14.yml  
        ```
        4. Destroy ContainerLab `intop2-isis14.yml` topology:  

        ```
           containerlab destroy --topo intop2-isis14.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop2-isis14.tst` file [here](../tst/intop2-isis14.tst)  
        3. Launch `intop2-isis14.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop2-isis14 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop2-isis14.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

