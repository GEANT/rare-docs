# Example: qos egress bandwidth action

=== "Topology"

    ![Alt text](../d2/qos-action10/qos-action10.svg)

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
     seq 10 act ban
      access-rate 81920
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
    r2 tping 100 5 1.1.1.1 vrf v1
    r2 tping 100 5 1234::1 vrf v1
    r2 tping 100 5 1.1.1.1 vrf v1 rep 100 tim 500 siz 100
    r2 tping 100 5 1234::1 vrf v1 rep 100 tim 500 siz 100
    r1 tping 100 5 1.1.1.2 vrf v1 rep 100 tim 500 siz 100
    r1 tping 100 5 1234::2 vrf v1 rep 100 tim 500 siz 100
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [qos-action10](../clab/qos-action10/qos-action10.yml) file  
        3. Launch ContainerLab `qos-action10.yml` topology:  

        ```
           containerlab deploy --topo qos-action10.yml  
        ```
        4. Destroy ContainerLab `qos-action10.yml` topology:  

        ```
           containerlab destroy --topo qos-action10.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `qos-action10.tst` file [here](../tst/qos-action10.tst)  
        3. Launch `qos-action10.tst` test:  

        ```
           java -jar ../../rtr.jar test tester qos-action10 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `qos-action10.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

