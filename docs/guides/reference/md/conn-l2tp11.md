# Example: ethernet over l2tp3

=== "Topology"

    ![Alt text](../d2/conn-l2tp11/conn-l2tp11.svg)

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
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff:ffff::
     exit
    vpdn l2tp
     bridge-gr 1
     proxy p1
     tar 1.1.1.2
     vcid 1234
     dir out
     pwt eth
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
    bridge 1
     mac-learn
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff:ffff::
     exit
    int eth2
     bridge-gr 1
     exit
    vpdn l2tp
     bridge-gr 1
     proxy p1
     tar 1.1.1.1
     vcid 1234
     dir in
     pwt eth
     prot l2tp3
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
     ipv4 addr 2.2.2.3 255.255.255.0
     ipv6 addr 4321::3 ffff:ffff::
     exit
    ```

=== "Verification"

    ```
    r3 tping 100 60 2.2.2.2 vrf v1
    r3 tping 100 60 2.2.2.1 vrf v1
    r3 tping 100 60 4321::2 vrf v1
    r3 tping 100 60 4321::1 vrf v1
    r2 tping 100 60 2.2.2.3 vrf v1
    r2 tping 100 60 2.2.2.1 vrf v1
    r2 tping 100 60 4321::3 vrf v1
    r2 tping 100 60 4321::1 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1
    r1 tping 100 60 2.2.2.3 vrf v1
    r1 tping 100 60 4321::2 vrf v1
    r1 tping 100 60 4321::3 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-l2tp11](../clab/conn-l2tp11/conn-l2tp11.yml) file  
        3. Launch ContainerLab `conn-l2tp11.yml` topology:  

        ```
           containerlab deploy --topo conn-l2tp11.yml  
        ```
        4. Destroy ContainerLab `conn-l2tp11.yml` topology:  

        ```
           containerlab destroy --topo conn-l2tp11.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-l2tp11.tst` file [here](../tst/conn-l2tp11.tst)  
        3. Launch `conn-l2tp11.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-l2tp11 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-l2tp11.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

