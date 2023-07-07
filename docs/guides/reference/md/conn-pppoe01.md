# Example: pppoe over ethernet encapsulation

=== "Topology"

    ![Alt text](../d2/conn-pppoe01/conn-pppoe01.svg)

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
     p2poe server di1
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
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
     p2poe client di1
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 30 2.2.2.0 vrf v1
    r2 tping 100 30 1.1.1.1 vrf v1
    r2 output show inter dia1 full
    output ../binTmp/conn-pppoe.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the interface:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-pppoe01](../clab/conn-pppoe01/conn-pppoe01.yml) file  
        3. Launch ContainerLab `conn-pppoe01.yml` topology:  

        ```
           containerlab deploy --topo conn-pppoe01.yml  
        ```
        4. Destroy ContainerLab `conn-pppoe01.yml` topology:  

        ```
           containerlab destroy --topo conn-pppoe01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-pppoe01.tst` file [here](../tst/conn-pppoe01.tst)  
        3. Launch `conn-pppoe01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-pppoe01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-pppoe01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

