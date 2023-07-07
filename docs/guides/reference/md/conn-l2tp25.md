# Example: ppp over authenticated l2tp3 server

=== "Topology"

    ![Alt text](../d2/conn-l2tp25/conn-l2tp25.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    int lo0
     vrf for v1
     ipv4 addr 4.4.4.4 255.255.255.255
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
    server l2tp3 l2tp
     clone di1
     password tester
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
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    prefix-list p1
     permit 0.0.0.0/0
     exit
    int di1
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.128
     ppp ip4cp open
     ppp ip4cp local 0.0.0.0
     ipv4 gateway-prefix p1
     exit
    vpdn l2tp
     int di1
     proxy p1
     tar 1.1.1.1
     called 1234
     calling 4321
     vcid 1234
     dir out
     password tester
     pwt ppp
     prot l2tp3
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 60 2.2.2.0 vrf v1
    r2 tping 100 60 4.4.4.4 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-l2tp25](../clab/conn-l2tp25/conn-l2tp25.yml) file  
        3. Launch ContainerLab `conn-l2tp25.yml` topology:  

        ```
           containerlab deploy --topo conn-l2tp25.yml  
        ```
        4. Destroy ContainerLab `conn-l2tp25.yml` topology:  

        ```
           containerlab destroy --topo conn-l2tp25.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-l2tp25.tst` file [here](../tst/conn-l2tp25.tst)  
        3. Launch `conn-l2tp25.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-l2tp25 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-l2tp25.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

