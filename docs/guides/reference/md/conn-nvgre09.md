# Example: isdn tunneling with nvgre

=== "Topology"

    ![Alt text](../d2/conn-nvgre09/conn-nvgre09.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int ser1
     enc isdn
     isdn mode dce
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    int ser1
     enc isdn
     xconnect v1 eth1 nvgre 1.1.1.2 123
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff:ffff::
     exit
    int ser1
     enc isdn
     xconnect v1 eth1 nvgre 1.1.1.1 123
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int ser1
     enc isdn
     isdn mode dce
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 10 1.1.1.2 vrf v1
    r3 tping 100 10 1.1.1.1 vrf v1
    r1 tping 100 10 2.2.2.2 vrf v1
    r1 tping 100 10 4321::2 vrf v1
    r4 tping 100 10 2.2.2.1 vrf v1
    r4 tping 100 10 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-nvgre09](../clab/conn-nvgre09/conn-nvgre09.yml) file  
        3. Launch ContainerLab `conn-nvgre09.yml` topology:  

        ```
           containerlab deploy --topo conn-nvgre09.yml  
        ```
        4. Destroy ContainerLab `conn-nvgre09.yml` topology:  

        ```
           containerlab destroy --topo conn-nvgre09.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-nvgre09.tst` file [here](../tst/conn-nvgre09.tst)  
        3. Launch `conn-nvgre09.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-nvgre09 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-nvgre09.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

