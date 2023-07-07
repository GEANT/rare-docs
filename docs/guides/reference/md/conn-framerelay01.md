# Example: framerelay ansi

=== "Topology"

    ![Alt text](../d2/conn-framerelay01/conn-framerelay01.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int ser1
     enc frame
     framerelay mode dce
     framerelay lmi ansi
     framerelay dlci 123
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
     enc frame
     framerelay lmi ansi
     framerelay dlci 123
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
    output ../binTmp/conn-framerelay.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the interface:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-framerelay01](../clab/conn-framerelay01/conn-framerelay01.yml) file  
        3. Launch ContainerLab `conn-framerelay01.yml` topology:  

        ```
           containerlab deploy --topo conn-framerelay01.yml  
        ```
        4. Destroy ContainerLab `conn-framerelay01.yml` topology:  

        ```
           containerlab destroy --topo conn-framerelay01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-framerelay01.tst` file [here](../tst/conn-framerelay01.tst)  
        3. Launch `conn-framerelay01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-framerelay01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-framerelay01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

