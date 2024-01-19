# Example: interop9: dot1q encapsulation

=== "Topology"

    ![Alt text](../d2/intop9-eth02/intop9-eth02.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1.123
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    set interfaces ge-0/0/0 vlan-tagging
    set interfaces ge-0/0/0.123 vlan-id 123
    set interfaces ge-0/0/0.123 family inet address 1.1.1.2/24
    set interfaces ge-0/0/0.123 family inet6 address 1234::2/64
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop9-eth02](../clab/intop9-eth02/intop9-eth02.yml) file  
        3. Launch ContainerLab `intop9-eth02.yml` topology:  

        ```
           containerlab deploy --topo intop9-eth02.yml  
        ```
        4. Destroy ContainerLab `intop9-eth02.yml` topology:  

        ```
           containerlab destroy --topo intop9-eth02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop9-eth02.tst` file [here](../tst/intop9-eth02.tst)  
        3. Launch `intop9-eth02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop9-eth02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop9-eth02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```
