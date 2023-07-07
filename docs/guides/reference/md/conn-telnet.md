# Example: ppp over telnet

=== "Topology"

    ![Alt text](../d2/conn-telnet/conn-telnet.svg)

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
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.252
     exit
    aaa userlist usr
     username c password c
     username c privilege 14
     exit
    server tel tel
     vrf v1
     login authen usr
     security protocol telnet
     exec int di1
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
    prefix-list p1
     permit 0.0.0.0/0
     exit
    int di1
     enc ppp
     vrf for v1
     ipv4 addr 4.4.4.4 255.255.255.128
     ppp ip4cp open
     ppp ip4cp local 0.0.0.0
     ipv4 gateway-prefix p1
     exit
    int eth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.252
     exit
    chat-script login
     recv 5000 .*ser
     send c
     binsend 13
     recv 5000 .*ass
     send c
     binsend 13
     send ppp
     binsend 13
     exit
    vpdn tel
     interface di1
     proxy p1
     script login
     target 3.3.3.1
     vcid 23
     protocol telnet
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 30 2.2.2.0 vrf v1
    r2 tping 100 5 1.1.1.1 vrf v1
    r2 output show inter dia1 full
    output ../binTmp/conn-telnet.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the interface:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-telnet](../clab/conn-telnet/conn-telnet.yml) file  
        3. Launch ContainerLab `conn-telnet.yml` topology:  

        ```
           containerlab deploy --topo conn-telnet.yml  
        ```
        4. Destroy ContainerLab `conn-telnet.yml` topology:  

        ```
           containerlab destroy --topo conn-telnet.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-telnet.tst` file [here](../tst/conn-telnet.tst)  
        3. Launch `conn-telnet.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-telnet path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-telnet.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

