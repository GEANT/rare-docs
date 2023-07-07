# Example: cross connect lapb interfaces

=== "Topology"

    ![Alt text](../d2/conn-xconn03/conn-xconn03.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int ser1
     enc lapb
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    int ser1
     enc lapb
     lapb mode dce
     exit
    int ser2
     enc lapb
     lapb mode dce
     exit
    connect con
     side1 ser1
     side2 ser2
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int ser1
     enc lapb
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
        2. Fetch [conn-xconn03](../clab/conn-xconn03/conn-xconn03.yml) file  
        3. Launch ContainerLab `conn-xconn03.yml` topology:  

        ```
           containerlab deploy --topo conn-xconn03.yml  
        ```
        4. Destroy ContainerLab `conn-xconn03.yml` topology:  

        ```
           containerlab destroy --topo conn-xconn03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-xconn03.tst` file [here](../tst/conn-xconn03.tst)  
        3. Launch `conn-xconn03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-xconn03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-xconn03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

