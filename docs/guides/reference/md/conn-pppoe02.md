# Example: pppoe over bridge encapsulation

=== "Topology"

    ![Alt text](../d2/conn-pppoe02/conn-pppoe02.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    bridge 1
     exit
    int lo0
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.255
     exit
    ipv4 pool p4 2.2.2.1 0.0.0.1 254
    int di1
     enc ppp
     vrf for v1
     ipv4 addr 2.2.2.0 255.255.255.255
     ppp ip4cp local 2.2.2.0
     ipv4 pool p4
     ppp ip4cp open
     exit
    int eth1
     bridge-gr 1
     exit
    int bvi1
     p2poe server di1
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    bridge 1
     exit
    prefix-list p1
     permit 0.0.0.0/0
     exit
    int di1
     enc ppp
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.128
     ppp ip4cp open
     ppp ip4cp local 0.0.0.0
     ipv4 gateway-prefix p1
     exit
    int eth1
     bridge-gr 1
     exit
    int bvi1
     p2poe client di1
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 30 2.2.2.0 vrf v1
    r2 tping 100 30 1.1.1.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-pppoe02](../clab/conn-pppoe02/conn-pppoe02.yml) file  
        3. Launch ContainerLab `conn-pppoe02.yml` topology:  

        ```
           containerlab deploy --topo conn-pppoe02.yml  
        ```
        4. Destroy ContainerLab `conn-pppoe02.yml` topology:  

        ```
           containerlab destroy --topo conn-pppoe02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-pppoe02.tst` file [here](../tst/conn-pppoe02.tst)  
        3. Launch `conn-pppoe02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-pppoe02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-pppoe02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

