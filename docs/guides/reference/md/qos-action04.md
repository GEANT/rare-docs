# Example: qos egress drop action

=== "Topology"

    ![Alt text](../d2/qos-action04/qos-action04.svg)

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
     seq 10 act drop
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
    r2 tping 0 5 1.1.1.1 vrf v1 siz 200
    r2 tping 0 5 1234::1 vrf v1 siz 200
    r1 tping 0 5 1.1.1.2 vrf v1 siz 200
    r1 tping 0 5 1234::2 vrf v1 siz 200
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [qos-action04](../clab/qos-action04/qos-action04.yml) file  
        3. Launch ContainerLab `qos-action04.yml` topology:  

        ```
           containerlab deploy --topo qos-action04.yml  
        ```
        4. Destroy ContainerLab `qos-action04.yml` topology:  

        ```
           containerlab destroy --topo qos-action04.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `qos-action04.tst` file [here](../tst/qos-action04.tst)  
        3. Launch `qos-action04.tst` test:  

        ```
           java -jar ../../rtr.jar test tester qos-action04 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `qos-action04.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

