# Example: xot pad

=== "Topology"

    ![Alt text](../d2/conn-xotpad/conn-xotpad.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.255
     exit
    int eth1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.252
     exit
    server xot xot
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
    client proxy p1
    int eth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.252
     exit
    ```

=== "Verification"

    ```
    r2 send pack xot 3.3.3.1 11 22
    r2 tping 100 5 1.1.1.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-xotpad](../clab/conn-xotpad/conn-xotpad.yml) file  
        3. Launch ContainerLab `conn-xotpad.yml` topology:  

        ```
           containerlab deploy --topo conn-xotpad.yml  
        ```
        4. Destroy ContainerLab `conn-xotpad.yml` topology:  

        ```
           containerlab destroy --topo conn-xotpad.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-xotpad.tst` file [here](../tst/conn-xotpad.tst)  
        3. Launch `conn-xotpad.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-xotpad path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-xotpad.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

