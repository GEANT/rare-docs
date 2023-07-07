# Example: nsh switch

=== "Topology"

    ![Alt text](../d2/mpls-nsh11/mpls-nsh11.svg)

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
    int eth1
     nsh ena
     nsh xconn 2 255
     exit
    int eth2
     nsh ena
     exit
    nsh 2 255 int eth2 0000.1111.2222
    nsh 5 252 int eth1 0000.1111.2222 rawpack keephdr
    ```

    **r3**

    ```
    hostname r3
    int eth1
     nsh ena
     exit
    int eth2
     nsh ena
     exit
    nsh 3 254 int eth1 0000.1111.2222 switch 5 252
    nsh 2 254 int eth2 0000.1111.2222 switch 4 252
    ```

    **r4**

    ```
    hostname r4
    int eth1
     nsh ena
     exit
    int eth2
     nsh ena
     nsh xconn 3 255
     exit
    nsh 3 255 int eth1 0000.1111.2222
    nsh 4 252 int eth2 0000.1111.2222 rawpack keephdr
    ```

    **r5**

    ```
    hostname r5
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
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1111::2 vrf v1
    r5 tping 100 10 1.1.1.1 vrf v1
    r5 tping 100 10 1111::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-nsh11](../clab/mpls-nsh11/mpls-nsh11.yml) file  
        3. Launch ContainerLab `mpls-nsh11.yml` topology:  

        ```
           containerlab deploy --topo mpls-nsh11.yml  
        ```
        4. Destroy ContainerLab `mpls-nsh11.yml` topology:  

        ```
           containerlab destroy --topo mpls-nsh11.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-nsh11.tst` file [here](../tst/mpls-nsh11.tst)  
        3. Launch `mpls-nsh11.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-nsh11 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-nsh11.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

