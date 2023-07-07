# Example: interop1: l2tp2 client

=== "Topology"

    ![Alt text](../d2/intop1-l2tp01/intop1-l2tp01.svg)

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
    vpdn l2tp
     int di1
     proxy p1
     tar 1.1.1.2
     called 1234
     calling 4321
     dir in
     prot l2tp2
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
    interface gigabit1
     ip address 1.1.1.2 255.255.255.0
     no shutdown
     exit
    ip local pool p1 2.2.2.11 2.2.2.99
    interface virtual-template1
     ip unnumbered Loopback0
     peer default ip address pool p1
     exit
    vpdn enable
    vpdn-group 1
     accept-dialin
      protocol l2tp
      virtual-template 1
     no l2tp tunnel authentication
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 60 2.2.2.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-l2tp01](../clab/intop1-l2tp01/intop1-l2tp01.yml) file  
        3. Launch ContainerLab `intop1-l2tp01.yml` topology:  

        ```
           containerlab deploy --topo intop1-l2tp01.yml  
        ```
        4. Destroy ContainerLab `intop1-l2tp01.yml` topology:  

        ```
           containerlab destroy --topo intop1-l2tp01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-l2tp01.tst` file [here](../tst/intop1-l2tp01.tst)  
        3. Launch `intop1-l2tp01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-l2tp01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-l2tp01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

