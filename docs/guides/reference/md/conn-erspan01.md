# Example: erspan over ipv4

=== "Topology"

    ![Alt text](../d2/conn-erspan01/conn-erspan01.svg)

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
     mac-learn
     exit
    vpdn er
     bridge-group 1
     proxy p1
     target 1.1.1.2
     vcid 123
     protocol erspan
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
     mac-learn
     exit
    vpdn er
     bridge-group 1
     proxy p1
     target 1.1.1.1
     vcid 123
     protocol erspan
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
    r2 output show bridge 1
    r2 output show inter bvi1 full
    r2 output show ipv4 arp bvi1
    r2 output show ipv6 neigh bvi1
    output ../binTmp/conn-erspan.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the bridge:
    here is the interface:
    here is the arp:
    here are the neighbors:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-erspan01](../clab/conn-erspan01/conn-erspan01.yml) file  
        3. Launch ContainerLab `conn-erspan01.yml` topology:  

        ```
           containerlab deploy --topo conn-erspan01.yml  
        ```
        4. Destroy ContainerLab `conn-erspan01.yml` topology:  

        ```
           containerlab destroy --topo conn-erspan01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-erspan01.tst` file [here](../tst/conn-erspan01.tst)  
        3. Launch `conn-erspan01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-erspan01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-erspan01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

