# Example: interop9: fragmentation and reassembly

=== "Topology"

    ![Alt text](../d2/intop9-eth03/intop9-eth03.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     mtu 1500
     enforce-mtu both
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     ipv4 reassembly 16
     ipv4 fragmentation 1400
     ipv6 reassembly 16
     ipv6 fragmentation 1400
     exit
    ```

    **r2**

    ```
    hostname r2
    set interfaces ge-0/0/0.0 family inet address 1.1.1.2/24
    set interfaces ge-0/0/0.0 family inet6 address 1234::2/64
    ```

=== "Verification"

    ```
    r1 tping 100 15 1.1.1.2 vrf v1 siz 222
    r1 tping 100 15 1234::2 vrf v1 siz 222
    r1 tping 100 15 1.1.1.2 vrf v1 siz 2222
    r1 tping 100 15 1234::2 vrf v1 siz 2222
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop9-eth03](../clab/intop9-eth03/intop9-eth03.yml) file  
        3. Launch ContainerLab `intop9-eth03.yml` topology:  

        ```
           containerlab deploy --topo intop9-eth03.yml  
        ```
        4. Destroy ContainerLab `intop9-eth03.yml` topology:  

        ```
           containerlab destroy --topo intop9-eth03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop9-eth03.tst` file [here](../tst/intop9-eth03.tst)  
        3. Launch `intop9-eth03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop9-eth03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop9-eth03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

