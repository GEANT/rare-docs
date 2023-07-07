# Example: nsh over ethernet vlan

=== "Topology"

    ![Alt text](../d2/mpls-nsh02/mpls-nsh02.svg)

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
    int eth2.11
     nsh ena
     exit
    nsh 2 255 int eth2.11 0000.1111.2222
    nsh 3 254 int eth1 0000.1111.2222 rawpack keephdr
    ```

    **r3**

    ```
    hostname r3
    int eth1.11
     nsh ena
     exit
    int eth2
     nsh ena
     nsh xconn 3 255
     exit
    nsh 3 255 int eth1.11 0000.1111.2222
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
        2. Fetch [mpls-nsh02](../clab/mpls-nsh02/mpls-nsh02.yml) file  
        3. Launch ContainerLab `mpls-nsh02.yml` topology:  

        ```
           containerlab deploy --topo mpls-nsh02.yml  
        ```
        4. Destroy ContainerLab `mpls-nsh02.yml` topology:  

        ```
           containerlab destroy --topo mpls-nsh02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-nsh02.tst` file [here](../tst/mpls-nsh02.tst)  
        3. Launch `mpls-nsh02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-nsh02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-nsh02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

