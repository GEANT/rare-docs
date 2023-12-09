# Example: qos divert dapp

=== "Topology"

    ![Alt text](../d2/qos-copp22/qos-copp22.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int ser1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    int ser2
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1235::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v2
     rd 1:2
     exit
    vrf def v4
     rd 1:4
     exit
    policy-map p1
     seq 10 act trans
      set vrf v4
     exit
    policy-map p2
     seq 10 act trans
      set vrf v2
     exit
    vrf def v1
     rd 1:1
     dapp4 p1
     dapp6 p1
     exit
    vrf def v3
     rd 1:3
     dapp4 p2
     dapp6 p2
     exit
    int ser1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int ser2
     vrf for v2
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int ser3
     vrf for v3
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int ser4
     vrf for v4
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int ser1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff::
     exit
    int ser2
     vrf for v1
     ipv4 addr 1.1.2.3 255.255.255.0
     ipv6 addr 1235::3 ffff::
     exit
    ```

=== "Verification"

    ```
    r3 tping 100 15 1.1.1.1 vrf v1 siz 200
    r3 tping 100 15 1234::1 vrf v1 siz 200
    r1 tping 100 15 1.1.1.3 vrf v1 siz 200
    r1 tping 100 15 1234::3 vrf v1 siz 200
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [qos-copp22](../clab/qos-copp22/qos-copp22.yml) file  
        3. Launch ContainerLab `qos-copp22.yml` topology:  

        ```
           containerlab deploy --topo qos-copp22.yml  
        ```
        4. Destroy ContainerLab `qos-copp22.yml` topology:  

        ```
           containerlab destroy --topo qos-copp22.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `qos-copp22.tst` file [here](../tst/qos-copp22.tst)  
        3. Launch `qos-copp22.tst` test:  

        ```
           java -jar ../../rtr.jar test tester qos-copp22 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `qos-copp22.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

