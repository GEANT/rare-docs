# Example: qos egress acl matcher

=== "Topology"

    ![Alt text](../d2/qos-match10/qos-match10.svg)

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
    access a1
     permit all 1.1.1.1 255.255.255.255 all 2.2.2.2 255.255.255.255 all
     permit all 2.2.2.2 255.255.255.255 all 1.1.1.1 255.255.255.255 all
     permit all 1234::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     permit all 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all 1234::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     exit
    policy-map p1
     seq 10 act drop
      match access a1
     seq 20 act trans
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     service-policy-out p1
     exit
    int eth2
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
     service-policy-out p1
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
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 2.2.2.1
    ipv6 route v1 :: :: 4321::1
    ```

=== "Verification"

    ```
    r2 tping 100 5 2.2.2.2 vrf v1
    r2 tping 100 5 1.1.1.1 vrf v1
    r2 tping 100 5 4321::2 vrf v1
    r2 tping 100 5 1234::1 vrf v1
    r1 tping 0 5 2.2.2.2 vrf v1
    r3 tping 0 5 1.1.1.1 vrf v1
    r1 tping 0 5 4321::2 vrf v1
    r3 tping 0 5 1234::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [qos-match10](../clab/qos-match10/qos-match10.yml) file  
        3. Launch ContainerLab `qos-match10.yml` topology:  

        ```
           containerlab deploy --topo qos-match10.yml  
        ```
        4. Destroy ContainerLab `qos-match10.yml` topology:  

        ```
           containerlab destroy --topo qos-match10.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `qos-match10.tst` file [here](../tst/qos-match10.tst)  
        3. Launch `qos-match10.tst` test:  

        ```
           java -jar ../../rtr.jar test tester qos-match10 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `qos-match10.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

