# Example: interop2: ospf nssa area

=== "Topology"

    ![Alt text](../d2/intop2-ospf06/intop2-ospf06.svg)

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
     area 1 ena
     area 1 nssa
     exit
    router ospf6 1
     vrf v1
     router 6.6.6.1
     area 1 ena
     area 1 nssa
     no area 1 host
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr fe80::1 ffff::
     router ospf4 1 ena
     router ospf6 1 ena
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router ospf4 1 ena
     router ospf6 1 ena
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
    router ospf 1
     redistribute connected
     area 1
      nssa
      interface loopback0 passive
      interface gigabit0/0/0/0 network point-to-point
    router ospfv3 1
     redistribute connected
     area 1
      nssa
      interface loopback0 passive
      interface gigabit0/0/0/0 network point-to-point
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
        2. Fetch [intop2-ospf06](../clab/intop2-ospf06/intop2-ospf06.yml) file  
        3. Launch ContainerLab `intop2-ospf06.yml` topology:  

        ```
           containerlab deploy --topo intop2-ospf06.yml  
        ```
        4. Destroy ContainerLab `intop2-ospf06.yml` topology:  

        ```
           containerlab destroy --topo intop2-ospf06.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop2-ospf06.tst` file [here](../tst/intop2-ospf06.tst)  
        3. Launch `intop2-ospf06.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop2-ospf06 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop2-ospf06.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

