# Example: fragmentation and reassembly

=== "Topology"

    ![Alt text](../d2/conn-frag01/conn-frag01.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int ser1
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
    vrf def v1
     rd 1:1
     exit
    int ser1
     mtu 1500
     enforce-mtu both
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     ipv4 reassembly 16
     ipv4 fragmentation 1400
     ipv6 reassembly 16
     ipv6 fragmentation 1400
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 15 1.1.1.2 vrf v1 siz 222
    r2 tping 100 15 1.1.1.1 vrf v1 siz 222
    r1 tping 100 15 1234::2 vrf v1 siz 222
    r2 tping 100 15 1234::1 vrf v1 siz 222
    r1 tping 100 15 1.1.1.2 vrf v1 siz 2222
    r2 tping 100 15 1.1.1.1 vrf v1 siz 2222
    r1 tping 100 15 1234::2 vrf v1 siz 2222
    r2 tping 100 15 1234::1 vrf v1 siz 2222
    r1 tping -100 5 1.1.1.2 vrf v1 siz 2222 dont error
    r2 tping -100 5 1.1.1.1 vrf v1 siz 2222 dont error
    r1 tping -100 5 1234::2 vrf v1 siz 2222 dont error
    r2 tping -100 5 1234::1 vrf v1 siz 2222 dont error
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-frag01](../clab/conn-frag01/conn-frag01.yml) file  
        3. Launch ContainerLab `conn-frag01.yml` topology:  

        ```
           containerlab deploy --topo conn-frag01.yml  
        ```
        4. Destroy ContainerLab `conn-frag01.yml` topology:  

        ```
           containerlab destroy --topo conn-frag01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-frag01.tst` file [here](../tst/conn-frag01.tst)  
        3. Launch `conn-frag01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-frag01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-frag01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

