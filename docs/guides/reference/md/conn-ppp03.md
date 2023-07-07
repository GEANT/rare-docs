# Example: ppp with radius authentication

=== "Topology"

    ![Alt text](../d2/conn-ppp03/conn-ppp03.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int ser1
     enc ppp
     ppp ip4cp close
     ppp ip6cp close
     ppp user c
     ppp pass c
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
    proxy-profile p1
     vrf v1
     exit
    client proxy p1
    aaa radius usr
     secret c
     server 2.2.2.2
     exit
    int eth1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     exit
    int ser1
     enc ppp
     ppp ip4cp close
     ppp ip6cp close
     ppp auth usr
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
    int eth1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     exit
    aaa userlist usr
     username c password c
     exit
    server radius rad
     authen usr
     secret c
     logg
     vrf v1
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 15 2.2.2.2 vrf v1
    r1 tping 100 15 1.1.1.2 vrf v1
    r2 tping 100 15 1.1.1.1 vrf v1
    r1 tping 100 15 1234::2 vrf v1
    r2 tping 100 15 1234::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-ppp03](../clab/conn-ppp03/conn-ppp03.yml) file  
        3. Launch ContainerLab `conn-ppp03.yml` topology:  

        ```
           containerlab deploy --topo conn-ppp03.yml  
        ```
        4. Destroy ContainerLab `conn-ppp03.yml` topology:  

        ```
           containerlab destroy --topo conn-ppp03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-ppp03.tst` file [here](../tst/conn-ppp03.tst)  
        3. Launch `conn-ppp03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-ppp03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-ppp03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

