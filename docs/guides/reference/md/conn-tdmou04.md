# Example: lapb with tdmoudp

=== "Topology"

    ![Alt text](../d2/conn-tdmou04/conn-tdmou04.svg)

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
     enc lapb
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
     exit
    vpdn pou
     interface dialer1
     proxy p1
     target 1.1.1.2
     vcid 1234
     mtu 7
     protocol tdmoudp
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
     enc lapb
     lapb mode dce
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    vpdn pou
     interface dialer1
     proxy p1
     target 1.1.1.1
     vcid 1234
     mtu 7
     protocol tdmoudp
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r2 tping 100 10 1.1.1.1 vrf v1
    r1 tping 100 30 2.2.2.2 vrf v1
    r1 tping 100 30 4321::2 vrf v1
    r2 tping 100 30 2.2.2.1 vrf v1
    r2 tping 100 30 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-tdmou04](../clab/conn-tdmou04/conn-tdmou04.yml) file  
        3. Launch ContainerLab `conn-tdmou04.yml` topology:  

        ```
           containerlab deploy --topo conn-tdmou04.yml  
        ```
        4. Destroy ContainerLab `conn-tdmou04.yml` topology:  

        ```
           containerlab destroy --topo conn-tdmou04.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-tdmou04.tst` file [here](../tst/conn-tdmou04.tst)  
        3. Launch `conn-tdmou04.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-tdmou04 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-tdmou04.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

