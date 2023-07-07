# Example: qos ingress matcher on bridged traffic

=== "Topology"

    ![Alt text](../d2/qos-match13/qos-match13.svg)

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
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.2
    ipv6 route v1 :: :: 1234::2
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    bridge 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff::
     exit
    policy-map p1
     seq 10 act drop
      match length 300-500
     seq 20 act trans
     exit
    int eth1
     bridge-gr 1
     service-policy-in p1
     exit
    int eth2
     bridge-gr 1
     service-policy-in p1
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 1.1.1.2 vrf v1 siz 200
    r3 tping 100 5 1.1.1.1 vrf v1 siz 200
    r1 tping 100 5 1234::2 vrf v1 siz 200
    r3 tping 100 5 1234::1 vrf v1 siz 200
    r1 tping 0 5 1.1.1.2 vrf v1 siz 400
    r3 tping 0 5 1.1.1.1 vrf v1 siz 400
    r1 tping 0 5 1234::2 vrf v1 siz 400
    r3 tping 0 5 1234::1 vrf v1 siz 400
    r1 tping 100 5 1.1.1.2 vrf v1 siz 600
    r3 tping 100 5 1.1.1.1 vrf v1 siz 600
    r1 tping 100 5 1234::2 vrf v1 siz 600
    r3 tping 100 5 1234::1 vrf v1 siz 600
    r2 tping 100 5 1.1.1.2 vrf v1 siz 200
    r2 tping 100 5 1.1.1.1 vrf v1 siz 200
    r2 tping 100 5 1234::2 vrf v1 siz 200
    r2 tping 100 5 1234::1 vrf v1 siz 200
    r2 tping 0 5 1.1.1.2 vrf v1 siz 400
    r2 tping 0 5 1.1.1.1 vrf v1 siz 400
    r2 tping 0 5 1234::2 vrf v1 siz 400
    r2 tping 0 5 1234::1 vrf v1 siz 400
    r2 tping 100 5 1.1.1.2 vrf v1 siz 600
    r2 tping 100 5 1.1.1.1 vrf v1 siz 600
    r2 tping 100 5 1234::2 vrf v1 siz 600
    r2 tping 100 5 1234::1 vrf v1 siz 600
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [qos-match13](../clab/qos-match13/qos-match13.yml) file  
        3. Launch ContainerLab `qos-match13.yml` topology:  

        ```
           containerlab deploy --topo qos-match13.yml  
        ```
        4. Destroy ContainerLab `qos-match13.yml` topology:  

        ```
           containerlab destroy --topo qos-match13.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `qos-match13.tst` file [here](../tst/qos-match13.tst)  
        3. Launch `qos-match13.tst` test:  

        ```
           java -jar ../../rtr.jar test tester qos-match13 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `qos-match13.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

