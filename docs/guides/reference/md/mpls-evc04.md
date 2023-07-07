# Example: bridged evcs and subif

=== "Topology"

    ![Alt text](../d2/mpls-evc04/mpls-evc04.svg)

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
    bridge 3
     exit
    int eth1
     service-inst 11 bri 1
     service-inst 13 bri 3
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1111::2 ffff::
     exit
    int eth1.12
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
        2. Fetch [mpls-evc04](../clab/mpls-evc04/mpls-evc04.yml) file  
        3. Launch ContainerLab `mpls-evc04.yml` topology:  

        ```
           containerlab deploy --topo mpls-evc04.yml  
        ```
        4. Destroy ContainerLab `mpls-evc04.yml` topology:  

        ```
           containerlab destroy --topo mpls-evc04.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-evc04.tst` file [here](../tst/mpls-evc04.tst)  
        3. Launch `mpls-evc04.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-evc04 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-evc04.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

