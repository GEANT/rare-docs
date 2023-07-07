# Example: port mode ppp over l2tp3

=== "Topology"

    ![Alt text](../d2/conn-l2tp10/conn-l2tp10.svg)

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
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.252
     exit
    vpdn l2tp
     interface di1
     proxy p1
     tar 1.1.1.2
     vcid 1234
     dir out
     pwt hdlc
     prot l2tp3
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
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.252
     exit
    vpdn l2tp
     interface di1
     proxy p1
     tar 1.1.1.1
     vcid 1234
     dir in
     pwt hdlc
     prot l2tp3
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 60 2.2.2.1 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-l2tp10](../clab/conn-l2tp10/conn-l2tp10.yml) file  
        3. Launch ContainerLab `conn-l2tp10.yml` topology:  

        ```
           containerlab deploy --topo conn-l2tp10.yml  
        ```
        4. Destroy ContainerLab `conn-l2tp10.yml` topology:  

        ```
           containerlab destroy --topo conn-l2tp10.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-l2tp10.tst` file [here](../tst/conn-l2tp10.tst)  
        3. Launch `conn-l2tp10.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-l2tp10 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-l2tp10.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

