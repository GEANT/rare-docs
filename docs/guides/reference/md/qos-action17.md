# Example: qos ingress rate limit action

=== "Topology"

    ![Alt text](../d2/qos-action17/qos-action17.svg)

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
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     rate-limit-in 819 100
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
        2. Fetch [qos-action17](../clab/qos-action17/qos-action17.yml) file  
        3. Launch ContainerLab `qos-action17.yml` topology:  

        ```
           containerlab deploy --topo qos-action17.yml  
        ```
        4. Destroy ContainerLab `qos-action17.yml` topology:  

        ```
           containerlab destroy --topo qos-action17.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `qos-action17.tst` file [here](../tst/qos-action17.tst)  
        3. Launch `qos-action17.tst` test:  

        ```
           java -jar ../../rtr.jar test tester qos-action17 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `qos-action17.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

