# Example: ppp routes with radius authentication

=== "Topology"

    ![Alt text](../d2/conn-ppp09/conn-ppp09.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    prefix-list p4
     permit 0.0.0.0/0
     exit
    prefix-list p6
     permit ::/0
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int ser1
     enc ppp
     ppp ip4cp open
     ppp ip4cp local 0.0.0.0
     ppp ip6cp open
     ppp user c
     ppp pass c
     vrf for v1
     ipv4 addr dynamic dynamic
     ipv4 gateway-prefix p4
     ipv6 addr dynamic dynamic
     ipv6 gateway-prefix p6
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    proxy-profile p1
     vrf v1
     exit
    client proxy p1
    aaa radius usr
     secret c
     server 3.3.3.3
     exit
    int eth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     exit
    int ser1
     enc ppp
     ppp ip4cp local 1.1.1.2
     ppp ip6cp open
     ppp auth usr
     vrf for v1
     ipv4 addr dynamic dynamic
     ipv6 addr dynamic dynamic
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
     ipv4 addr 3.3.3.3 255.255.255.0
     exit
    aaa userlist usr
     username c password c
     username c ipv4addr 1.1.1.1
     username c ipv4route 2.2.2.1/32 dist 123
     username c ipv6addr 1234::1
     username c ipv6ifid 1234-1234-1234-1234
     username c ipv6route 4321::1/128 dist 222
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
    r2 tping 100 15 3.3.3.3 vrf v1
    r1 tping 100 15 1.1.1.2 vrf v1
    r2 tping 100 15 1.1.1.1 vrf v1
    r1 tping 100 15 2.2.2.2 vrf v1
    r2 tping 100 15 2.2.2.1 vrf v1
    r1 tping 100 15 4321::2 vrf v1 sou lo1
    r2 tping 100 15 4321::1 vrf v1 sou lo1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-ppp09](../clab/conn-ppp09/conn-ppp09.yml) file  
        3. Launch ContainerLab `conn-ppp09.yml` topology:  

        ```
           containerlab deploy --topo conn-ppp09.yml  
        ```
        4. Destroy ContainerLab `conn-ppp09.yml` topology:  

        ```
           containerlab destroy --topo conn-ppp09.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-ppp09.tst` file [here](../tst/conn-ppp09.tst)  
        3. Launch `conn-ppp09.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-ppp09 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-ppp09.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

