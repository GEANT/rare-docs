# Example: interop1: vxlan tunnel

=== "Topology"

    ![Alt text](../d2/intop1-tun03/intop1-tun03.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    bridge 1
     exit
    vpdn bvi1
     bridge-group 1
     proxy p1
     target 1.1.1.2
     vcid 1111
     pwtype atm-port
     protocol vxlan
     exit
    int bvi1
     macaddr 0000.0000.1234
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 2222::1 ffff::
     ipv4 host-static 2.2.2.2 0000.0000.4321
     ipv6 host-static 2222::2 0000.0000.4321
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
    vxlan source-port-range dummy-l2-tunnel-udp 4789 4789
    interface Tunnel1
     tunnel source gigabit1
     tunnel destination 1.1.1.1
     tunnel mode vxlan ipv4 0000.0000.4321 0000.0000.1234
     tunnel vxlan vni 1111
     ip address 2.2.2.2 255.255.255.252
     ipv6 address 2222::2/64
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234::2 vrf v1
    r1 tping 100 10 2.2.2.2 vrf v1
    !r1 tping 100 10 2222::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-tun03](../clab/intop1-tun03/intop1-tun03.yml) file  
        3. Launch ContainerLab `intop1-tun03.yml` topology:  

        ```
           containerlab deploy --topo intop1-tun03.yml  
        ```
        4. Destroy ContainerLab `intop1-tun03.yml` topology:  

        ```
           containerlab destroy --topo intop1-tun03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-tun03.tst` file [here](../tst/intop1-tun03.tst)  
        3. Launch `intop1-tun03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-tun03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-tun03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

