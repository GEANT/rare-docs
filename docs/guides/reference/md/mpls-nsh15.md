# Example: nsh over ipv6 tunnel

=== "Topology"

    ![Alt text](../d2/mpls-nsh15/mpls-nsh15.svg)

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
     ipv6 addr 1111::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int eth1
     nsh ena
     nsh xconn 2 255
     exit
    int ser1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 2222::1 ffff:ffff::
     ipv4 nsh ena
     ipv6 nsh ena
     exit
    nsh 2 255 tunnel v1 ser1 2222::2
    nsh 3 254 int eth1 0000.1111.2222 rawpack keephdr
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int ser1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 2222::2 ffff:ffff::
     ipv4 nsh ena
     ipv6 nsh ena
     exit
    int eth1
     nsh ena
     nsh xconn 3 255
     exit
    nsh 3 255 tunnel v1 ser1 2222::1
    nsh 2 254 int eth1 0000.1111.2222 rawpack keephdr
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1111::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 10 2.2.2.2 vrf v1
    r2 tping 100 10 2222::2 vrf v1
    r3 tping 100 10 2.2.2.1 vrf v1
    r3 tping 100 10 2222::1 vrf v1
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1111::2 vrf v1
    r4 tping 100 10 1.1.1.1 vrf v1
    r4 tping 100 10 1111::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-nsh15](../clab/mpls-nsh15/mpls-nsh15.yml) file  
        3. Launch ContainerLab `mpls-nsh15.yml` topology:  

        ```
           containerlab deploy --topo mpls-nsh15.yml  
        ```
        4. Destroy ContainerLab `mpls-nsh15.yml` topology:  

        ```
           containerlab destroy --topo mpls-nsh15.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-nsh15.tst` file [here](../tst/mpls-nsh15.tst)  
        3. Launch `mpls-nsh15.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-nsh15 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-nsh15.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

