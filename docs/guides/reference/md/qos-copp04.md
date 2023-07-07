# Example: qos egress drop copp

=== "Topology"

    ![Alt text](../d2/qos-copp04/qos-copp04.svg)

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
     seq 10 act drop
     exit
    vrf def v1
     rd 1:1
     copp4out p1
     copp6out p1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
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
        2. Fetch [qos-copp04](../clab/qos-copp04/qos-copp04.yml) file  
        3. Launch ContainerLab `qos-copp04.yml` topology:  

        ```
           containerlab deploy --topo qos-copp04.yml  
        ```
        4. Destroy ContainerLab `qos-copp04.yml` topology:  

        ```
           containerlab destroy --topo qos-copp04.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `qos-copp04.tst` file [here](../tst/qos-copp04.tst)  
        3. Launch `qos-copp04.tst` test:  

        ```
           java -jar ../../rtr.jar test tester qos-copp04 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `qos-copp04.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

