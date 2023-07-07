# Example: qos egress transmit action

=== "Topology"

    ![Alt text](../d2/qos-action02/qos-action02.svg)

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
    policy-map p1
     seq 10 act trans
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     service-policy-out p1
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
        2. Fetch [qos-action02](../clab/qos-action02/qos-action02.yml) file  
        3. Launch ContainerLab `qos-action02.yml` topology:  

        ```
           containerlab deploy --topo qos-action02.yml  
        ```
        4. Destroy ContainerLab `qos-action02.yml` topology:  

        ```
           containerlab destroy --topo qos-action02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `qos-action02.tst` file [here](../tst/qos-action02.tst)  
        3. Launch `qos-action02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester qos-action02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `qos-action02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

