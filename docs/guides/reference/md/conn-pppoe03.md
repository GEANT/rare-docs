# Example: ppp relay over pppoe

=== "Topology"

    ![Alt text](../d2/conn-pppoe03/conn-pppoe03.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int di1
     enc ppp
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     exit
    int eth1
     p2poe client di1
     exit
    ```

    **r2**

    ```
    hostname r2
    int eth1
     p2poe relay ser1
     exit
    int ser1
     enc raw
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int ser1
     enc ppp
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     exit
    int di1
     enc ppp
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     exit
    int eth1
     p2poe relay di1
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int di1
     enc ppp
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     exit
    int eth1
     p2poe client di1
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 30 1.1.1.2 vrf v1
    r3 tping 100 30 1.1.1.1 vrf v1
    r3 tping 100 30 1.1.1.6 vrf v1
    r4 tping 100 30 1.1.1.5 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-pppoe03](../clab/conn-pppoe03/conn-pppoe03.yml) file  
        3. Launch ContainerLab `conn-pppoe03.yml` topology:  

        ```
           containerlab deploy --topo conn-pppoe03.yml  
        ```
        4. Destroy ContainerLab `conn-pppoe03.yml` topology:  

        ```
           containerlab destroy --topo conn-pppoe03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-pppoe03.tst` file [here](../tst/conn-pppoe03.tst)  
        3. Launch `conn-pppoe03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-pppoe03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-pppoe03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

