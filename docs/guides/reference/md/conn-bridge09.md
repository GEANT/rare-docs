# Example: bridged ethernet over gre

=== "Topology"

    ![Alt text](../d2/conn-bridge09/conn-bridge09.svg)

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
     vrf for v1
     ipv4 addr 9.9.9.1 255.255.255.252
     ipv6 addr 9999::1 ffff::
     exit
    int tun1
     tunnel vrf v1
     tunnel mode gre
     tunnel source ethernet2
     tunnel destination 9999::2
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
     exit
    int eth1
     vrf for v1
     ipv4 addr 9.9.9.2 255.255.255.252
     ipv6 addr 9999::2 ffff::
     exit
    int tun1
     tunnel vrf v1
     tunnel mode gre
     tunnel source ethernet1
     tunnel destination 9999::1
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff::
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 5 1.1.1.3 vrf v1
    r1 tping 100 5 1.1.1.2 vrf v1
    r1 tping 100 5 1.1.1.3 vrf v1
    r1 tping 100 5 1234::2 vrf v1
    r1 tping 100 5 1234::3 vrf v1
    r2 tping 100 5 1.1.1.1 vrf v1
    r2 tping 100 5 1.1.1.3 vrf v1
    r2 tping 100 5 1234::1 vrf v1
    r2 tping 100 5 1234::3 vrf v1
    r3 tping 100 5 1.1.1.1 vrf v1
    r3 tping 100 5 1.1.1.2 vrf v1
    r3 tping 100 5 1234::1 vrf v1
    r3 tping 100 5 1234::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-bridge09](../clab/conn-bridge09/conn-bridge09.yml) file  
        3. Launch ContainerLab `conn-bridge09.yml` topology:  

        ```
           containerlab deploy --topo conn-bridge09.yml  
        ```
        4. Destroy ContainerLab `conn-bridge09.yml` topology:  

        ```
           containerlab destroy --topo conn-bridge09.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-bridge09.tst` file [here](../tst/conn-bridge09.tst)  
        3. Launch `conn-bridge09.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-bridge09 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-bridge09.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

