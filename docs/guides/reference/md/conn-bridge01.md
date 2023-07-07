# Example: chain bridged ethernet

=== "Topology"

    ![Alt text](../d2/conn-bridge01/conn-bridge01.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    bridge 1
     exit
    int eth1
     bridge-gr 1
     exit
    int bvi1
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
    bridge 1
     mac-learn
     exit
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    bridge 1
     mac-learn
     exit
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff::
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.4 255.255.255.0
     ipv6 addr 1234::4 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 1.1.1.2 vrf v1
    r1 tping 100 5 1.1.1.3 vrf v1
    r1 tping 100 5 1.1.1.4 vrf v1
    r1 tping 100 5 1234::2 vrf v1
    r1 tping 100 5 1234::3 vrf v1
    r1 tping 100 5 1234::4 vrf v1
    r2 tping 100 5 1.1.1.1 vrf v1
    r2 tping 100 5 1.1.1.3 vrf v1
    r2 tping 100 5 1.1.1.4 vrf v1
    r2 tping 100 5 1234::1 vrf v1
    r2 tping 100 5 1234::3 vrf v1
    r2 tping 100 5 1234::4 vrf v1
    r3 tping 100 5 1.1.1.1 vrf v1
    r3 tping 100 5 1.1.1.2 vrf v1
    r3 tping 100 5 1.1.1.4 vrf v1
    r3 tping 100 5 1234::1 vrf v1
    r3 tping 100 5 1234::2 vrf v1
    r3 tping 100 5 1234::4 vrf v1
    r4 tping 100 5 1.1.1.1 vrf v1
    r4 tping 100 5 1.1.1.2 vrf v1
    r4 tping 100 5 1.1.1.3 vrf v1
    r4 tping 100 5 1234::1 vrf v1
    r4 tping 100 5 1234::2 vrf v1
    r4 tping 100 5 1234::3 vrf v1
    r2 output show bridge 1
    r2 output show inter bvi1 full
    r2 output show ipv4 arp bvi1
    r2 output show ipv6 neigh bvi1
    output ../binTmp/conn-bridge.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the bridge:
    here is the interface:
    here is the arp:
    here are the neighbors:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-bridge01](../clab/conn-bridge01/conn-bridge01.yml) file  
        3. Launch ContainerLab `conn-bridge01.yml` topology:  

        ```
           containerlab deploy --topo conn-bridge01.yml  
        ```
        4. Destroy ContainerLab `conn-bridge01.yml` topology:  

        ```
           containerlab destroy --topo conn-bridge01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-bridge01.tst` file [here](../tst/conn-bridge01.tst)  
        3. Launch `conn-bridge01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-bridge01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-bridge01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

