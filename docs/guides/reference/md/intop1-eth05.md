# Example: interop1: point2point ethernet encapsulation

=== "Topology"

    ![Alt text](../d2/intop1-eth05/intop1-eth05.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.254
     ipv6 addr 1234::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffe
     exit
    ```

    **r2**

    ```
    hostname r2
    ip routing
    ipv6 unicast-routing
    interface gigabit1
     ip address 1.1.1.3 255.255.255.254
     ipv6 address 1234::3/127
     no shutdown
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.3 vrf v1
    r1 tping 100 10 1234::3 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-eth05](../clab/intop1-eth05/intop1-eth05.yml) file  
        3. Launch ContainerLab `intop1-eth05.yml` topology:  

        ```
           containerlab deploy --topo intop1-eth05.yml  
        ```
        4. Destroy ContainerLab `intop1-eth05.yml` topology:  

        ```
           containerlab destroy --topo intop1-eth05.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-eth05.tst` file [here](../tst/intop1-eth05.tst)  
        3. Launch `intop1-eth05.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-eth05 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-eth05.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

