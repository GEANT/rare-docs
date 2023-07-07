# Example: nsh over ethernet bridge

=== "Topology"

    ![Alt text](../d2/mpls-nsh03/mpls-nsh03.svg)

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
    bridge 1
     exit
    int eth2.11
     bridge-gr 1
     exit
    int bvi1
     nsh ena
     exit
    nsh 2 255 int bvi1 0000.1111.2222
    nsh 3 254 int eth1 0000.1111.2222 rawpack keephdr
    ```

    **r3**

    ```
    hostname r3
    bridge 1
     exit
    int eth1.11
     bridge-gr 1
     exit
    int bvi1
     nsh ena
     exit
    int eth2
     nsh ena
     nsh xconn 3 255
     exit
    nsh 3 255 int bvi1 0000.1111.2222
    nsh 2 254 int eth2 0000.1111.2222 rawpack keephdr
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
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1111::2 vrf v1
    r4 tping 100 10 1.1.1.1 vrf v1
    r4 tping 100 10 1111::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-nsh03](../clab/mpls-nsh03/mpls-nsh03.yml) file  
        3. Launch ContainerLab `mpls-nsh03.yml` topology:  

        ```
           containerlab deploy --topo mpls-nsh03.yml  
        ```
        4. Destroy ContainerLab `mpls-nsh03.yml` topology:  

        ```
           containerlab destroy --topo mpls-nsh03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-nsh03.tst` file [here](../tst/mpls-nsh03.tst)  
        3. Launch `mpls-nsh03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-nsh03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-nsh03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

