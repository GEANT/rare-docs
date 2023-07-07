# Example: interop8: fragmentation and reassembly

=== "Topology"

    ![Alt text](../d2/intop8-eth01/intop8-eth01.svg)

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
    r1 tping 100 15 1.1.1.2 vrf v1 siz 222
    r1 tping 100 15 1234::2 vrf v1 siz 222
    r1 tping 100 15 1.1.1.2 vrf v1 siz 2222
    r1 tping 100 15 1234::2 vrf v1 siz 2222
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop8-eth01](../clab/intop8-eth01/intop8-eth01.yml) file  
        3. Launch ContainerLab `intop8-eth01.yml` topology:  

        ```
           containerlab deploy --topo intop8-eth01.yml  
        ```
        4. Destroy ContainerLab `intop8-eth01.yml` topology:  

        ```
           containerlab destroy --topo intop8-eth01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop8-eth01.tst` file [here](../tst/intop8-eth01.tst)  
        3. Launch `intop8-eth01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop8-eth01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop8-eth01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

