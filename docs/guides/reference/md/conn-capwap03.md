# Example: capwap over loopback

=== "Topology"

    ![Alt text](../d2/conn-capwap03/conn-capwap03.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     exit
    int lo0
     vrf for v1
     ipv4 addr 1.1.1.101 255.255.255.255
     exit
    proxy-profile p1
     vrf v1
     source lo0
     exit
    ipv4 route v1 1.1.1.102 255.255.255.255 1.1.1.2
    bridge 1
     exit
    vpdn vx
     bridge-group 1
     proxy p1
     target 1.1.1.102
     protocol capwap
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     exit
    int lo0
     vrf for v1
     ipv4 addr 1.1.1.102 255.255.255.255
     exit
    proxy-profile p1
     vrf v1
     source lo0
     exit
    ipv4 route v1 1.1.1.101 255.255.255.255 1.1.1.1
    bridge 1
     exit
    vpdn vx
     bridge-group 1
     proxy p1
     target 1.1.1.101
     protocol capwap
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 2.2.2.2 vrf v1
    r2 tping 100 5 2.2.2.1 vrf v1
    r1 tping 100 5 4321::2 vrf v1
    r2 tping 100 5 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-capwap03](../clab/conn-capwap03/conn-capwap03.yml) file  
        3. Launch ContainerLab `conn-capwap03.yml` topology:  

        ```
           containerlab deploy --topo conn-capwap03.yml  
        ```
        4. Destroy ContainerLab `conn-capwap03.yml` topology:  

        ```
           containerlab destroy --topo conn-capwap03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-capwap03.tst` file [here](../tst/conn-capwap03.tst)  
        3. Launch `conn-capwap03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-capwap03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-capwap03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```
