# Example: interop1: lacp

=== "Topology"

    ![Alt text](../d2/intop1-eth06/intop1-eth06.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     lacp 0000.0000.1111 123 12345
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    ip routing
    ipv6 unicast-routing
    interface port-channel1
     ip address 1.1.1.2 255.255.255.0
     ipv6 address 1234::2/64
     no shutdown
     exit
    interface gigabit1
     lacp rate fast
     channel-group 1 mode active
     no shutdown
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-eth06](../clab/intop1-eth06/intop1-eth06.yml) file  
        3. Launch ContainerLab `intop1-eth06.yml` topology:  

        ```
           containerlab deploy --topo intop1-eth06.yml  
        ```
        4. Destroy ContainerLab `intop1-eth06.yml` topology:  

        ```
           containerlab destroy --topo intop1-eth06.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-eth06.tst` file [here](../tst/intop1-eth06.tst)  
        3. Launch `intop1-eth06.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-eth06 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-eth06.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

