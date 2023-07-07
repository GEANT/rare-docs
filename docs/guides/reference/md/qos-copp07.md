# Example: qos transmit dapp

=== "Topology"

    ![Alt text](../d2/qos-copp07/qos-copp07.svg)

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
    policy-map p1
     seq 10 act trans
     exit
    vrf def v1
     rd 1:1
     dapp4 p1
     dapp6 p1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 5 1.1.1.1 vrf v1 siz 200
    r2 tping 100 5 1234::1 vrf v1 siz 200
    r1 tping 100 5 1.1.1.2 vrf v1 siz 200
    r1 tping 100 5 1234::2 vrf v1 siz 200
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [qos-copp07](../clab/qos-copp07/qos-copp07.yml) file  
        3. Launch ContainerLab `qos-copp07.yml` topology:  

        ```
           containerlab deploy --topo qos-copp07.yml  
        ```
        4. Destroy ContainerLab `qos-copp07.yml` topology:  

        ```
           containerlab destroy --topo qos-copp07.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `qos-copp07.tst` file [here](../tst/qos-copp07.tst)  
        3. Launch `qos-copp07.tst` test:  

        ```
           java -jar ../../rtr.jar test tester qos-copp07 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `qos-copp07.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

