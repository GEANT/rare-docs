# Example: llcudp over ipv6

=== "Topology"

    ![Alt text](../d2/conn-llcudp02/conn-llcudp02.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    bridge 1
     exit
    vpdn vx
     bridge-group 1
     proxy p1
     target 1234::2
     protocol llcudp
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
    vpdn vx
     bridge-group 1
     proxy p1
     target 1234::1
     protocol llcudp
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
        2. Fetch [conn-llcudp02](../clab/conn-llcudp02/conn-llcudp02.yml) file  
        3. Launch ContainerLab `conn-llcudp02.yml` topology:  

        ```
           containerlab deploy --topo conn-llcudp02.yml  
        ```
        4. Destroy ContainerLab `conn-llcudp02.yml` topology:  

        ```
           containerlab destroy --topo conn-llcudp02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-llcudp02.tst` file [here](../tst/conn-llcudp02.tst)  
        3. Launch `conn-llcudp02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-llcudp02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-llcudp02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

