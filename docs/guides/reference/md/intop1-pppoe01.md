# Example: interop1: pppoe client

=== "Topology"

    ![Alt text](../d2/intop1-pppoe01/intop1-pppoe01.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    prefix-list p1
     permit 0.0.0.0/0
     exit
    int di1
     enc ppp
     ppp ip4cp open
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.0
     ppp ip4cp local 0.0.0.0
     ipv4 gateway-prefix p1
     exit
    int eth1
     p2poe client di1
     exit
    ```

    **r2**

    ```
    hostname r2
    ip routing
    ipv6 unicast-routing
    interface Loopback0
     ip address 2.2.2.1 255.255.255.255
     exit
    ip local pool p1 2.2.2.11 2.2.2.99
    interface virtual-template1
     ip unnumbered Loopback0
     peer default ip address pool p1
     exit
    vpdn enable
    bba-group pppoe global
     virtual-template 1
     ac name inet
     exit
    interface gigabit1
     pppoe enable group global
     no shutdown
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-pppoe01](../clab/intop1-pppoe01/intop1-pppoe01.yml) file  
        3. Launch ContainerLab `intop1-pppoe01.yml` topology:  

        ```
           containerlab deploy --topo intop1-pppoe01.yml  
        ```
        4. Destroy ContainerLab `intop1-pppoe01.yml` topology:  

        ```
           containerlab destroy --topo intop1-pppoe01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-pppoe01.tst` file [here](../tst/intop1-pppoe01.tst)  
        3. Launch `intop1-pppoe01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-pppoe01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-pppoe01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

