# Example: interworking with ethernet over packet over udp

=== "Topology"

    ![Alt text](../d2/conn-pckou15/conn-pckou15.svg)

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
     exit
    bridge 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff:ffff::
     exit
    server pckoudp pou
     bridge 1
     vrf v1
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int pweth1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff:ffff::
     pseudo v1 eth1 pckoudp 1.1.1.1 2554
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r2 tping 100 10 1.1.1.1 vrf v1
    r2 tping 100 60 2.2.2.1 vrf v1
    r2 tping 100 60 4321::1 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1
    r1 tping 100 60 4321::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-pckou15](../clab/conn-pckou15/conn-pckou15.yml) file  
        3. Launch ContainerLab `conn-pckou15.yml` topology:  

        ```
           containerlab deploy --topo conn-pckou15.yml  
        ```
        4. Destroy ContainerLab `conn-pckou15.yml` topology:  

        ```
           containerlab destroy --topo conn-pckou15.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-pckou15.tst` file [here](../tst/conn-pckou15.tst)  
        3. Launch `conn-pckou15.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-pckou15 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-pckou15.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

