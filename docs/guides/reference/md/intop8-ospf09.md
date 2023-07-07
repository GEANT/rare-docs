# Example: interop8: ospf md5 authentication

=== "Topology"

    ![Alt text](../d2/intop8-ospf09/intop8-ospf09.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router ospf4 1
     vrf v1
     router 4.4.4.1
     area 0 ena
     no area 0 host
     red conn
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.1
     area 0 ena
     no area 0 host
     red conn
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr fe80::1 ffff::
     router ospf4 1 ena
     router ospf4 1 password tester
     router ospf4 1 authen-id 123
     router ospf4 1 authen-type md5
     router ospf6 1 ena
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
    ip forwarding
    ipv6 forwarding
    interface lo
     ip addr 2.2.2.2/32
     ipv6 addr 4321::2/128
     exit
    router ospf
     redistribute connected
     exit
    router ospf6
     redistribute connected
     interface ens3 area 0.0.0.0
     exit
    interface ens3
     ip address 1.1.1.2/24
     ip ospf area 0
     ip ospf network point-to-point
     ip ospf authentication message-digest
     ip ospf message-digest-key 123 md5 tester
     ipv6 ospf6 network point-to-point
     no shutdown
     exit
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
        2. Fetch [intop8-ospf09](../clab/intop8-ospf09/intop8-ospf09.yml) file  
        3. Launch ContainerLab `intop8-ospf09.yml` topology:  

        ```
           containerlab deploy --topo intop8-ospf09.yml  
        ```
        4. Destroy ContainerLab `intop8-ospf09.yml` topology:  

        ```
           containerlab destroy --topo intop8-ospf09.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop8-ospf09.tst` file [here](../tst/intop8-ospf09.tst)  
        3. Launch `intop8-ospf09.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop8-ospf09 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop8-ospf09.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

