# Example: process redundancy

=== "Topology"

    ![Alt text](../d2/conn-redun/conn-redun.svg)

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
    ipv4 route v1 2.2.2.0 255.255.255.0 1.1.1.3
    ipv6 route v1 4321:: ffff:: 1234::3
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    bridge 1
     exit
    bridge 34
     mac-learn
     block-unicast
     exit
    bridge 35
     mac-learn
     block-unicast
     exit
    bridge 45
     mac-learn
     block-unicast
     exit
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     shut
     exit
    int eth3
     bridge-gr 1
     exit
    int eth4
     bridge-gr 1
     exit
    int eth31
     bridge-gr 34
     shut
     exit
    int eth41
     bridge-gr 34
     exit
    int eth32
     bridge-gr 35
     shut
     exit
    int eth51
     bridge-gr 35
     exit
    int eth42
     bridge-gr 45
     exit
    int eth52
     bridge-gr 45
     exit
    ```

    **r3 nowrite**

    ```
    hostname r3 nowrite
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.0
     ipv6 addr 4321::3 ffff::
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff::
     exit
    ```

    **r4 nowrite**

    ```
    hostname r4 nowrite
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.0
     ipv6 addr 4321::4 ffff::
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff::
     exit
    ```

    **r5 nowrite**

    ```
    hostname r5 nowrite
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.5 255.255.255.0
     ipv6 addr 4321::5 ffff::
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff::
     exit
    ```

=== "Verification"

    ```
    prio 20
    prio 10
    r1 tping 100 10 1.1.1.3 vrf v1 multi
    r1 tping 100 10 1234::3 vrf v1 multi
    r1 tping 100 10 2.2.2.4 vrf v1
    r1 tping 100 10 4321::4 vrf v1
    r2 send conf t
    r2 send int eth2
    r2 send no shut
    r2 send exit
    r2 send int eth31
    r2 send no shut
    r2 send exit
    r2 send int eth32
    r2 send no shut
    r2 send end
    r1 tping 100 10 1.1.1.3 vrf v1 multi
    r1 tping 100 10 1234::3 vrf v1 multi
    r1 tping 100 10 2.2.2.3 vrf v1
    r1 tping 100 10 4321::3 vrf v1
    r3 send relo forc
    r1 tping 100 10 1.1.1.3 vrf v1 multi
    r1 tping 100 10 1234::3 vrf v1 multi
    r1 tping 100 10 2.2.2.5 vrf v1
    r1 tping 100 10 4321::5 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-redun](../clab/conn-redun/conn-redun.yml) file  
        3. Launch ContainerLab `conn-redun.yml` topology:  

        ```
           containerlab deploy --topo conn-redun.yml  
        ```
        4. Destroy ContainerLab `conn-redun.yml` topology:  

        ```
           containerlab destroy --topo conn-redun.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-redun.tst` file [here](../tst/conn-redun.tst)  
        3. Launch `conn-redun.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-redun path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-redun.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

