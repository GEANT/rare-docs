# Example: qos egress ethertype matcher

=== "Topology"

    ![Alt text](../d2/qos-match12/qos-match12.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    policy-map p1
     seq 10 act trans
      match ethtyp 34525
     seq 20 act drop
     exit
    int eth1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     ipv6 addr 3333::1 ffff::
     service-policy-out p1
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
     ipv4 addr 3.3.3.2 255.255.255.0
     ipv6 addr 3333::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 3.3.3.1 vrf v1
    r1 tping 100 5 3333::1 vrf v1
    r2 tping 100 5 3.3.3.2 vrf v1
    r2 tping 100 5 3333::2 vrf v1
    r2 tping 0 5 3.3.3.1 vrf v1
    r2 tping 100 5 3333::1 vrf v1
    r1 tping 0 5 3.3.3.2 vrf v1
    r1 tping 100 5 3333::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [qos-match12](../clab/qos-match12/qos-match12.yml) file  
        3. Launch ContainerLab `qos-match12.yml` topology:  

        ```
           containerlab deploy --topo qos-match12.yml  
        ```
        4. Destroy ContainerLab `qos-match12.yml` topology:  

        ```
           containerlab destroy --topo qos-match12.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `qos-match12.tst` file [here](../tst/qos-match12.tst)  
        3. Launch `qos-match12.tst` test:  

        ```
           java -jar ../../rtr.jar test tester qos-match12 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `qos-match12.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

