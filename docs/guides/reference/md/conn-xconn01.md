# Example: cross connect hdlc interfaces

=== "Topology"

    ![Alt text](../d2/conn-xconn01/conn-xconn01.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int ser1
     enc hdlc
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    int ser1
     enc hdlc
     exit
    int ser2
     enc hdlc
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
     enc hdlc
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
        2. Fetch [conn-xconn01](../clab/conn-xconn01/conn-xconn01.yml) file  
        3. Launch ContainerLab `conn-xconn01.yml` topology:  

        ```
           containerlab deploy --topo conn-xconn01.yml  
        ```
        4. Destroy ContainerLab `conn-xconn01.yml` topology:  

        ```
           containerlab destroy --topo conn-xconn01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-xconn01.tst` file [here](../tst/conn-xconn01.tst)  
        3. Launch `conn-xconn01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-xconn01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-xconn01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

