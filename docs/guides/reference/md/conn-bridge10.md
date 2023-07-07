# Example: bridge with spantree

=== "Topology"

    ![Alt text](../d2/conn-bridge10/conn-bridge10.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    bridge 1
     stp-priority 40960
     stp-mode ieee
     mac-learn
     exit
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int eth3
     bridge-gr 1
     exit
    int eth4
     bridge-gr 1
     exit
    int bvi1
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
     stp-priority 20480
     stp-mode ieee
     mac-learn
     exit
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int eth3
     bridge-gr 1
     exit
    int eth4
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 30 1.1.1.2 vrf v1
    r1 tping 100 30 1234::2 vrf v1
    r2 tping 100 30 1.1.1.1 vrf v1
    r2 tping 100 30 1234::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-bridge10](../clab/conn-bridge10/conn-bridge10.yml) file  
        3. Launch ContainerLab `conn-bridge10.yml` topology:  

        ```
           containerlab deploy --topo conn-bridge10.yml  
        ```
        4. Destroy ContainerLab `conn-bridge10.yml` topology:  

        ```
           containerlab destroy --topo conn-bridge10.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-bridge10.tst` file [here](../tst/conn-bridge10.tst)  
        3. Launch `conn-bridge10.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-bridge10 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-bridge10.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

