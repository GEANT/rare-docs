# Example: sr te over exthdr

=== "Topology"

    ![Alt text](../d2/mpls-sr11/mpls-sr11.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    access-list all
     permit all any all any all
     exit
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     ipv4 srh enable
     ipv6 srh enable
     exit
    interface tun1
     tunnel vrf v1
     tunnel source ethernet1
     tunnel destination 1.1.2.3
     tunnel domain-name 1.1.1.2
     tunnel mode srext
     vrf forwarding v1
     ipv4 address 3.3.3.1 255.255.255.252
     exit
    interface tun2
     tunnel vrf v1
     tunnel source ethernet1
     tunnel destination 1235::3
     tunnel domain-name 1234::2
     tunnel mode srext
     vrf forwarding v1
     ipv6 address 3333::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    access-list all
     permit all any all any all
     exit
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     ipv4 srh enable
     ipv6 srh enable
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1235::2 ffff::
     ipv4 srh enable
     ipv6 srh enable
     exit
    ```

    **r3**

    ```
    hostname r3
    access-list all
     permit all any all any all
     exit
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.3 255.255.255.0
     ipv6 addr 1235::3 ffff::
     ipv4 srh enable
     ipv6 srh enable
     exit
    interface tun1
     tunnel vrf v1
     tunnel source ethernet1
     tunnel destination 1.1.1.1
     tunnel domain-name 1.1.2.2
     tunnel mode srext
     vrf forwarding v1
     ipv4 address 3.3.3.2 255.255.255.252
     exit
    interface tun2
     tunnel vrf v1
     tunnel source ethernet1
     tunnel destination 1234::1
     tunnel domain-name 1235::2
     tunnel mode srext
     vrf forwarding v1
     ipv6 address 3333::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 1.1.1.2 vrf v1
    r1 tping 100 20 1234::2 vrf v1
    r2 tping 100 20 1.1.1.1 vrf v1
    r2 tping 100 20 1234::1 vrf v1
    r2 tping 100 20 1.1.2.3 vrf v1
    r2 tping 100 20 1235::3 vrf v1
    r3 tping 100 20 1.1.2.2 vrf v1
    r3 tping 100 20 1235::2 vrf v1
    r1 tping 100 20 3.3.3.2 vrf v1 sou tun1
    r3 tping 100 20 3.3.3.1 vrf v1 sou tun1
    r1 tping 100 20 3333::2 vrf v1 sou tun2
    r3 tping 100 20 3333::1 vrf v1 sou tun2
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-sr11](../clab/mpls-sr11/mpls-sr11.yml) file  
        3. Launch ContainerLab `mpls-sr11.yml` topology:  

        ```
           containerlab deploy --topo mpls-sr11.yml  
        ```
        4. Destroy ContainerLab `mpls-sr11.yml` topology:  

        ```
           containerlab destroy --topo mpls-sr11.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-sr11.tst` file [here](../tst/mpls-sr11.tst)  
        3. Launch `mpls-sr11.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-sr11 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-sr11.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

