# Example: qos ingress dscp set

=== "Topology"

    ![Alt text](../d2/qos-set04/qos-set04.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    policy-map p1
     seq 10 act drop
      match dscp 12
     seq 20 act trans
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     service-policy-in p1
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
    policy-map p1
     seq 10 act trans
      match length 300-500
      set dscp 12
     seq 20 act trans
      set dscp 11
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     service-policy-in p1
     exit
    int eth2
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
     service-policy-in p1
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    policy-map p1
     seq 10 act drop
      match dscp 12
     seq 20 act trans
     exit
    int eth1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     service-policy-in p1
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 2.2.2.1
    ipv6 route v1 :: :: 4321::1
    ```

=== "Verification"

    ```
    r1 tping 100 5 2.2.2.2 vrf v1 siz 200
    r3 tping 100 5 1.1.1.1 vrf v1 siz 200
    r1 tping 100 5 4321::2 vrf v1 siz 200
    r3 tping 100 5 1234::1 vrf v1 siz 200
    r1 tping 0 5 2.2.2.2 vrf v1 siz 400
    r3 tping 0 5 1.1.1.1 vrf v1 siz 400
    r1 tping 0 5 4321::2 vrf v1 siz 400
    r3 tping 0 5 1234::1 vrf v1 siz 400
    r1 tping 100 5 2.2.2.2 vrf v1 siz 600
    r3 tping 100 5 1.1.1.1 vrf v1 siz 600
    r1 tping 100 5 4321::2 vrf v1 siz 600
    r3 tping 100 5 1234::1 vrf v1 siz 600
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [qos-set04](../clab/qos-set04/qos-set04.yml) file  
        3. Launch ContainerLab `qos-set04.yml` topology:  

        ```
           containerlab deploy --topo qos-set04.yml  
        ```
        4. Destroy ContainerLab `qos-set04.yml` topology:  

        ```
           containerlab destroy --topo qos-set04.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `qos-set04.tst` file [here](../tst/qos-set04.tst)  
        3. Launch `qos-set04.tst` test:  

        ```
           java -jar ../../rtr.jar test tester qos-set04 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `qos-set04.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

