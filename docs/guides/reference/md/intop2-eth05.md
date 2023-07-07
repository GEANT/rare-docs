# Example: interop2: lacp

=== "Topology"

    ![Alt text](../d2/intop2-eth05/intop2-eth05.svg)

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
    interface bundle-ether1
     ipv4 address 1.1.1.2 255.255.255.0
     ipv6 address 1234::2/64
     no shutdown
     exit
    interface gigabit0/0/0/0
     bundle id 1 mode active
     lacp period short
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
        2. Fetch [intop2-eth05](../clab/intop2-eth05/intop2-eth05.yml) file  
        3. Launch ContainerLab `intop2-eth05.yml` topology:  

        ```
           containerlab deploy --topo intop2-eth05.yml  
        ```
        4. Destroy ContainerLab `intop2-eth05.yml` topology:  

        ```
           containerlab destroy --topo intop2-eth05.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop2-eth05.tst` file [here](../tst/intop2-eth05.tst)  
        3. Launch `intop2-eth05.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop2-eth05 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop2-eth05.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

