# Example: interop8: igmp3/mld2

=== "Topology"

    ![Alt text](../d2/intop8-mcast01/intop8-mcast01.svg)

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
     ipv6 addr 1234:1::1 ffff:ffff:ffff:ffff::
     ipv4 multi host-ena
     ipv4 multi host-pro
     ipv6 multi host-ena
     ipv6 multi host-pro
     exit
    ipv4 route v1 1.1.2.0 255.255.255.0 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff fe80::2
    ```

    **r2**

    ```
    hostname r2
    ip forwarding
    ipv6 forwarding
    interface ens3
     ip address 1.1.1.2/24
     ipv6 address 1234:1::2/64
     ip igmp
     ipv6 mld
     no shutdown
     exit
    interface ens4
     ip address 1.1.2.2/24
     ipv6 address 1234:2::2/64
     ip igmp
     ipv6 mld
     no shutdown
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1234:2::1 ffff:ffff:ffff:ffff::
     ipv4 multi host-ena
     ipv4 multi host-pro
     ipv6 multi host-ena
     ipv6 multi host-pro
     exit
    ipv4 route v1 1.1.1.0 255.255.255.0 1.1.2.2
    ipv6 route v1 1234:1::1 ffff:ffff:ffff:ffff:: 1234:2::2
    ipv4 mroute v1 1.1.1.0 255.255.255.0 1.1.2.2
    ipv6 mroute v1 1234:1::1 ffff:ffff:ffff:ffff:: 1234:2::2
    ipv4 multi v1 join 232.2.2.2 1.1.1.1
    ipv6 multi v1 join ff06::1 1234:1::1
    ```

=== "Verification"

    ```
    r1 tping 100 60 1.1.1.1 vrf v1 sou eth1
    r1 tping 100 60 1234:1::1 vrf v1 sou eth1
    r3 tping 100 60 1.1.2.1 vrf v1 sou eth1
    r3 tping 100 60 1234:2::1 vrf v1 sou eth1
    r1 tping 100 60 232.2.2.2 vrf v1 sou eth1
    !r1 tping 100 60 ff06::1 vrf v1 sou eth1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop8-mcast01](../clab/intop8-mcast01/intop8-mcast01.yml) file  
        3. Launch ContainerLab `intop8-mcast01.yml` topology:  

        ```
           containerlab deploy --topo intop8-mcast01.yml  
        ```
        4. Destroy ContainerLab `intop8-mcast01.yml` topology:  

        ```
           containerlab destroy --topo intop8-mcast01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop8-mcast01.tst` file [here](../tst/intop8-mcast01.tst)  
        3. Launch `intop8-mcast01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop8-mcast01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop8-mcast01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

