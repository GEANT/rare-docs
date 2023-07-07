# Example: bridged evcs over hdlc

=== "Topology"

    ![Alt text](../d2/mpls-evc02/mpls-evc02.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    bridge 1
     exit
    bridge 2
     exit
    bridge 3
     exit
    int ser1
     enc hdlc
     exit
    int ser1.11
     bridge-group 1
     exit
    int ser1.12
     bridge-group 2
     exit
    int ser1.13
     bridge-group 3
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1111::1 ffff::
     exit
    int bvi2
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1112::1 ffff::
     exit
    int bvi3
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
    int ser1
     enc hdlc
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
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-evc02](../clab/mpls-evc02/mpls-evc02.yml) file  
        3. Launch ContainerLab `mpls-evc02.yml` topology:  

        ```
           containerlab deploy --topo mpls-evc02.yml  
        ```
        4. Destroy ContainerLab `mpls-evc02.yml` topology:  

        ```
           containerlab destroy --topo mpls-evc02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-evc02.tst` file [here](../tst/mpls-evc02.tst)  
        3. Launch `mpls-evc02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-evc02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-evc02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

