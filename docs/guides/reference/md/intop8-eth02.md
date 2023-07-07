# Example: interop8: verify source

=== "Topology"

    ![Alt text](../d2/intop8-eth02/intop8-eth02.svg)

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
    ip forwarding
    ipv6 forwarding
    interface ens3
     ip address 1.1.1.2/24
     ipv6 address 1234::2/64
     no shutdown
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 15 1.1.1.2 vrf v1
    r1 tping 100 15 1234::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop8-eth02](../clab/intop8-eth02/intop8-eth02.yml) file  
        3. Launch ContainerLab `intop8-eth02.yml` topology:  

        ```
           containerlab deploy --topo intop8-eth02.yml  
        ```
        4. Destroy ContainerLab `intop8-eth02.yml` topology:  

        ```
           containerlab destroy --topo intop8-eth02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop8-eth02.tst` file [here](../tst/intop8-eth02.tst)  
        3. Launch `intop8-eth02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop8-eth02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop8-eth02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

