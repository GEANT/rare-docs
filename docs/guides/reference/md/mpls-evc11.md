# Example: xconnect evcs terminated on vpdns

=== "Topology"

    ![Alt text](../d2/mpls-evc11/mpls-evc11.svg)

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
    int eth2
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 2222::1 ffff::
     exit
    int eth1
     service-inst 11 xconn v1 eth2 vxlan 2.2.2.2 123
     service-inst 12 xconn v1 eth2 geneve 2.2.2.2 123
     service-inst 13 xconn v1 eth2 etherip 2.2.2.2 123
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 2222::2 ffff::
     exit
    bridge 11
     exit
    bridge 12
     exit
    bridge 13
     exit
    vpdn bvi11
     bridge 11
     proxy p1
     target 2.2.2.1
     vcid 123
     protocol vxlan
     exit
    vpdn bvi12
     bridge 12
     proxy p1
     target 2.2.2.1
     vcid 123
     protocol geneve
     exit
    vpdn bvi13
     bridge 13
     proxy p1
     target 2.2.2.1
     vcid 123
     protocol etherip
     exit
    int bvi11
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1111::2 ffff::
     exit
    int bvi12
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1112::2 ffff::
     exit
    int bvi13
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
    r3 tping 100 10 1.1.1.1 vrf v1
    r3 tping 100 10 1111::1 vrf v1
    r3 tping 100 10 1.1.2.1 vrf v1
    r3 tping 100 10 1112::1 vrf v1
    r3 tping 100 10 1.1.3.1 vrf v1
    r3 tping 100 10 1113::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-evc11](../clab/mpls-evc11/mpls-evc11.yml) file  
        3. Launch ContainerLab `mpls-evc11.yml` topology:  

        ```
           containerlab deploy --topo mpls-evc11.yml  
        ```
        4. Destroy ContainerLab `mpls-evc11.yml` topology:  

        ```
           containerlab destroy --topo mpls-evc11.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-evc11.tst` file [here](../tst/mpls-evc11.tst)  
        3. Launch `mpls-evc11.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-evc11 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-evc11.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

