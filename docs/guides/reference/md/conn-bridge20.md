# Example: bridged ethernet over l2tp3

=== "Topology"

    ![Alt text](../d2/conn-bridge20/conn-bridge20.svg)

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
     tunnel key 1234
     tunnel mode l2tp3
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
     tunnel key 1234
     tunnel mode l2tp3
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
        2. Fetch [conn-bridge20](../clab/conn-bridge20/conn-bridge20.yml) file  
        3. Launch ContainerLab `conn-bridge20.yml` topology:  

        ```
           containerlab deploy --topo conn-bridge20.yml  
        ```
        4. Destroy ContainerLab `conn-bridge20.yml` topology:  

        ```
           containerlab destroy --topo conn-bridge20.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-bridge20.tst` file [here](../tst/conn-bridge20.tst)  
        3. Launch `conn-bridge20.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-bridge20 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-bridge20.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

