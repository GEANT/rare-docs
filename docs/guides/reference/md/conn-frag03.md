# Example: precise mtu enforcement

=== "Topology"

    ![Alt text](../d2/conn-frag03/conn-frag03.svg)

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
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 15 1.1.1.2 vrf v1 siz 1500
    r2 tping 100 15 1.1.1.1 vrf v1 siz 1500
    r1 tping 100 15 1234::2 vrf v1 siz 1500
    r2 tping 100 15 1234::1 vrf v1 siz 1500
    r1 tping 0 15 1.1.1.2 vrf v1 siz 1501
    r2 tping 0 15 1.1.1.1 vrf v1 siz 1501
    r1 tping 0 15 1234::2 vrf v1 siz 1501
    r2 tping 0 15 1234::1 vrf v1 siz 1501
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-frag03](../clab/conn-frag03/conn-frag03.yml) file  
        3. Launch ContainerLab `conn-frag03.yml` topology:  

        ```
           containerlab deploy --topo conn-frag03.yml  
        ```
        4. Destroy ContainerLab `conn-frag03.yml` topology:  

        ```
           containerlab destroy --topo conn-frag03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-frag03.tst` file [here](../tst/conn-frag03.tst)  
        3. Launch `conn-frag03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-frag03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-frag03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

