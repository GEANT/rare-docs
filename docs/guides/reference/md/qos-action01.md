# Example: qos ingress transmit action

=== "Topology"

    ![Alt text](../d2/qos-action01/qos-action01.svg)

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
     service-policy-in p1
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 5 1.1.1.1 vrf v1 siz 200
    r2 tping 100 5 1234::1 vrf v1 siz 200
    r1 tping 100 5 1.1.1.2 vrf v1 siz 200
    r1 tping 100 5 1234::2 vrf v1 siz 200
    r2 output show policy int eth1 in
    output ../binTmp/qos-transmit.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the policy:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [qos-action01](../clab/qos-action01/qos-action01.yml) file  
        3. Launch ContainerLab `qos-action01.yml` topology:  

        ```
           containerlab deploy --topo qos-action01.yml  
        ```
        4. Destroy ContainerLab `qos-action01.yml` topology:  

        ```
           containerlab destroy --topo qos-action01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `qos-action01.tst` file [here](../tst/qos-action01.tst)  
        3. Launch `qos-action01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester qos-action01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `qos-action01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

