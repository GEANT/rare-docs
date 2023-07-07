# Example: ethernet over packet over udp

=== "Topology"

    ![Alt text](../d2/conn-pckou14/conn-pckou14.svg)

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
    bridge 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff:ffff::
     exit
    vpdn pou
     bridge-gr 1
     proxy p1
     tar 1.1.1.1
     prot pckoudp
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
        2. Fetch [conn-pckou14](../clab/conn-pckou14/conn-pckou14.yml) file  
        3. Launch ContainerLab `conn-pckou14.yml` topology:  

        ```
           containerlab deploy --topo conn-pckou14.yml  
        ```
        4. Destroy ContainerLab `conn-pckou14.yml` topology:  

        ```
           containerlab destroy --topo conn-pckou14.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-pckou14.tst` file [here](../tst/conn-pckou14.tst)  
        3. Launch `conn-pckou14.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-pckou14 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-pckou14.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

