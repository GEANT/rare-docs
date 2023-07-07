# Example: interop1: gre tunnel

=== "Topology"

    ![Alt text](../d2/intop1-tun01/intop1-tun01.svg)

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
    int tun1
     tunnel vrf v1
     tunnel mode gre
     tunnel source ethernet1
     tunnel destination 1.1.1.2
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 2222::1 ffff::
     exit
    int tun2
     tunnel vrf v1
     tunnel mode gre
     tunnel source ethernet1
     tunnel destination 1234::2
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     ipv6 addr 3333::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    ip routing
    ipv6 unicast-routing
    interface gigabit1
     ip address 1.1.1.2 255.255.255.0
     ipv6 address 1234::2/64
     no shutdown
     exit
    interface tunnel1
     tunnel source gigabit1
     tunnel destination 1.1.1.1
     tunnel mode gre ip
     ip address 2.2.2.2 255.255.255.0
     ipv6 address 2222::2/64
     exit
    interface tunnel2
     tunnel source gigabit1
     tunnel destination 1234::1
     tunnel mode gre ipv6
     ip address 3.3.3.2 255.255.255.0
     ipv6 address 3333::2/64
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234::2 vrf v1
    r1 tping 100 10 2.2.2.2 vrf v1
    r1 tping 100 10 2222::2 vrf v1
    r1 tping 100 10 3.3.3.2 vrf v1
    r1 tping 100 10 3333::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-tun01](../clab/intop1-tun01/intop1-tun01.yml) file  
        3. Launch ContainerLab `intop1-tun01.yml` topology:  

        ```
           containerlab deploy --topo intop1-tun01.yml  
        ```
        4. Destroy ContainerLab `intop1-tun01.yml` topology:  

        ```
           containerlab destroy --topo intop1-tun01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-tun01.tst` file [here](../tst/intop1-tun01.tst)  
        3. Launch `intop1-tun01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-tun01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-tun01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

