# Example: qos priority dapp

=== "Topology"

    ![Alt text](../d2/qos-copp10/qos-copp10.svg)

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
     seq 10 act pri
      access-rate 163840
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
    r2 tping 100 5 1.1.1.1 vrf v1
    r2 tping 100 5 1234::1 vrf v1
    r2 tping 85-95 5 1.1.1.1 vrf v1 rep 100 tim 500 siz 100
    r2 tping 85-95 5 1234::1 vrf v1 rep 100 tim 500 siz 100
    r1 tping 85-95 5 1.1.1.2 vrf v1 rep 100 tim 500 siz 100
    r1 tping 85-95 5 1234::2 vrf v1 rep 100 tim 500 siz 100
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [qos-copp10](../clab/qos-copp10/qos-copp10.yml) file  
        3. Launch ContainerLab `qos-copp10.yml` topology:  

        ```
           containerlab deploy --topo qos-copp10.yml  
        ```
        4. Destroy ContainerLab `qos-copp10.yml` topology:  

        ```
           containerlab destroy --topo qos-copp10.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `qos-copp10.tst` file [here](../tst/qos-copp10.tst)  
        3. Launch `qos-copp10.tst` test:  

        ```
           java -jar ../../rtr.jar test tester qos-copp10 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `qos-copp10.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

