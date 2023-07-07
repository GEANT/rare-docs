# Example: interop2: ipip tunnel

=== "Topology"

    ![Alt text](../d2/intop2-tun02/intop2-tun02.svg)

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
     tunnel mode ipip
     tunnel source ethernet1
     tunnel destination 1.1.1.2
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 2222::1 ffff::
     exit
    int tun2
     tunnel vrf v1
     tunnel mode ipip
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
    interface gigabit0/0/0/0
     ipv4 address 1.1.1.2 255.255.255.0
     ipv6 address 1234::2/64
     no shutdown
     exit
    interface tunnel-ip1
     tunnel source gigabit0/0/0/0
     tunnel destination 1.1.1.1
     tunnel mode ipv4
     ipv4 address 2.2.2.2 255.255.255.0
     ipv6 address 2222::2/64
     exit
    interface tunnel-ip2
     tunnel source gigabit0/0/0/0
     tunnel destination 1234::1
     tunnel mode ipv6
     ipv4 address 3.3.3.2 255.255.255.0
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
        2. Fetch [intop2-tun02](../clab/intop2-tun02/intop2-tun02.yml) file  
        3. Launch ContainerLab `intop2-tun02.yml` topology:  

        ```
           containerlab deploy --topo intop2-tun02.yml  
        ```
        4. Destroy ContainerLab `intop2-tun02.yml` topology:  

        ```
           containerlab destroy --topo intop2-tun02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop2-tun02.tst` file [here](../tst/intop2-tun02.tst)  
        3. Launch `intop2-tun02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop2-tun02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop2-tun02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

