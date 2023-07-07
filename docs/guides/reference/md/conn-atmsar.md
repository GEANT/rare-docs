# Example: atmsar encapsulation

=== "Topology"

    ![Alt text](../d2/conn-atmsar/conn-atmsar.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int atm1
     atmsar vpi 123
     atmsar vci 1234
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
    int atm1
     atmsar vpi 123
     atmsar vci 1234
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
    r1 output show interface atm1 full
    output ../binTmp/conn-atmsar.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the interface:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-atmsar](../clab/conn-atmsar/conn-atmsar.yml) file  
        3. Launch ContainerLab `conn-atmsar.yml` topology:  

        ```
           containerlab deploy --topo conn-atmsar.yml  
        ```
        4. Destroy ContainerLab `conn-atmsar.yml` topology:  

        ```
           containerlab destroy --topo conn-atmsar.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-atmsar.tst` file [here](../tst/conn-atmsar.tst)  
        3. Launch `conn-atmsar.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-atmsar path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-atmsar.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

