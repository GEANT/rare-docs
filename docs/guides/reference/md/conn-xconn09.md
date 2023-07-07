# Example: cross connect vlan subinterfaces

=== "Topology"

    ![Alt text](../d2/conn-xconn09/conn-xconn09.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    int eth1.11
     exit
    int eth2.22
     exit
    connect con
     side1 eth1.11
     side2 eth2.22
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth1.22
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 30 2.2.2.2 vrf v1
    r1 tping 100 30 4321::2 vrf v1
    r3 tping 100 30 2.2.2.1 vrf v1
    r3 tping 100 30 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-xconn09](../clab/conn-xconn09/conn-xconn09.yml) file  
        3. Launch ContainerLab `conn-xconn09.yml` topology:  

        ```
           containerlab deploy --topo conn-xconn09.yml  
        ```
        4. Destroy ContainerLab `conn-xconn09.yml` topology:  

        ```
           containerlab destroy --topo conn-xconn09.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-xconn09.tst` file [here](../tst/conn-xconn09.tst)  
        3. Launch `conn-xconn09.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-xconn09 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-xconn09.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

