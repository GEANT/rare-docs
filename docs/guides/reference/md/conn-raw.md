# Example: raw encapsulation

=== "Topology"

    ![Alt text](../d2/conn-raw/conn-raw.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int ser1
     enc raw
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
    int ser1
     enc raw
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 1.1.1.2 vrf v1
    r2 tping 100 5 1.1.1.1 vrf v1
    r1 tping 100 5 1234::2 vrf v1
    r2 tping 100 5 1234::1 vrf v1
    r1 output show inter ser1 full
    output ../binTmp/conn-raw.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the interface:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-raw](../clab/conn-raw/conn-raw.yml) file  
        3. Launch ContainerLab `conn-raw.yml` topology:  

        ```
           containerlab deploy --topo conn-raw.yml  
        ```
        4. Destroy ContainerLab `conn-raw.yml` topology:  

        ```
           containerlab destroy --topo conn-raw.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-raw.tst` file [here](../tst/conn-raw.tst)  
        3. Launch `conn-raw.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-raw path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-raw.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

