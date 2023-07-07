# Example: ppp with packet over udp

=== "Topology"

    ![Alt text](../d2/conn-pckou01/conn-pckou01.svg)

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
    int di1
     enc ppp
     ppp ip4cp close
     ppp ip6cp close
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
     exit
    vpdn pou
     interface dialer1
     proxy p1
     target 1.1.1.2
     vcid 1234
     protocol pckoudp
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
    int di1
     enc ppp
     ppp ip4cp close
     ppp ip6cp close
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    vpdn pou
     interface dialer1
     proxy p1
     target 1.1.1.1
     vcid 1234
     protocol pckoudp
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 2.2.2.2 vrf v1
    r1 tping 100 10 4321::2 vrf v1
    r2 tping 100 10 2.2.2.1 vrf v1
    r2 tping 100 10 4321::1 vrf v1
    r1 output show inter dia1 full
    output ../binTmp/conn-pckou.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the interface:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-pckou01](../clab/conn-pckou01/conn-pckou01.yml) file  
        3. Launch ContainerLab `conn-pckou01.yml` topology:  

        ```
           containerlab deploy --topo conn-pckou01.yml  
        ```
        4. Destroy ContainerLab `conn-pckou01.yml` topology:  

        ```
           containerlab destroy --topo conn-pckou01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-pckou01.tst` file [here](../tst/conn-pckou01.tst)  
        3. Launch `conn-pckou01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-pckou01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-pckou01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

