# Example: interop2: verify source

=== "Topology"

    ![Alt text](../d2/intop2-eth07/intop2-eth07.svg)

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
     ipv4 verify rx
     ipv6 verify rx
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
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop2-eth07](../clab/intop2-eth07/intop2-eth07.yml) file  
        3. Launch ContainerLab `intop2-eth07.yml` topology:  

        ```
           containerlab deploy --topo intop2-eth07.yml  
        ```
        4. Destroy ContainerLab `intop2-eth07.yml` topology:  

        ```
           containerlab destroy --topo intop2-eth07.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop2-eth07.tst` file [here](../tst/intop2-eth07.tst)  
        3. Launch `intop2-eth07.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop2-eth07 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop2-eth07.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

