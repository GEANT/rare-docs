# Example: bridged evcs over ethernet

=== "Topology"

    ![Alt text](../d2/mpls-evc01/mpls-evc01.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1111::1 ffff::
     exit
    int eth1.12
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1112::1 ffff::
     exit
    int eth1.13
     vrf for v1
     ipv4 addr 1.1.3.1 255.255.255.0
     ipv6 addr 1113::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    bridge 1
     exit
    bridge 2
     exit
    bridge 3
     exit
    int eth1
     service-inst 11 bri 1
     service-inst 12 bri 2
     service-inst 13 bri 3
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1111::2 ffff::
     exit
    int bvi2
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1112::2 ffff::
     exit
    int bvi3
     vrf for v1
     ipv4 addr 1.1.3.2 255.255.255.0
     ipv6 addr 1113::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1111::2 vrf v1
    r1 tping 100 10 1.1.2.2 vrf v1
    r1 tping 100 10 1112::2 vrf v1
    r1 tping 100 10 1.1.3.2 vrf v1
    r1 tping 100 10 1113::2 vrf v1
    r2 tping 100 10 1.1.1.1 vrf v1
    r2 tping 100 10 1111::1 vrf v1
    r2 tping 100 10 1.1.2.1 vrf v1
    r2 tping 100 10 1112::1 vrf v1
    r2 tping 100 10 1.1.3.1 vrf v1
    r2 tping 100 10 1113::1 vrf v1
    r2 output show inter eth1 full
    r2 output show bridge 1
    r2 output show bridge 2
    r2 output show bridge 3
    output ../binTmp/mpls-evc.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the interface:
    here is the bridge:
    here is the bridge:
    here is the bridge:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-evc01](../clab/mpls-evc01/mpls-evc01.yml) file  
        3. Launch ContainerLab `mpls-evc01.yml` topology:  

        ```
           containerlab deploy --topo mpls-evc01.yml  
        ```
        4. Destroy ContainerLab `mpls-evc01.yml` topology:  

        ```
           containerlab destroy --topo mpls-evc01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-evc01.tst` file [here](../tst/mpls-evc01.tst)  
        3. Launch `mpls-evc01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-evc01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-evc01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

