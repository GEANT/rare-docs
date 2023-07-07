# Example: framerelay q933

=== "Topology"

    ![Alt text](../d2/conn-framerelay03/conn-framerelay03.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int ser1
     enc frame
     framerelay mode dce
     framerelay lmi q933
     framerelay dlci 123
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int ser1
     enc frame
     framerelay lmi q933
     framerelay dlci 123
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 1.1.1.2 vrf v1
    r2 tping 100 5 1.1.1.1 vrf v1
    r1 tping 100 5 1234::2 vrf v1
    r2 tping 100 5 1234::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-framerelay03](../clab/conn-framerelay03/conn-framerelay03.yml) file  
        3. Launch ContainerLab `conn-framerelay03.yml` topology:  

        ```
           containerlab deploy --topo conn-framerelay03.yml  
        ```
        4. Destroy ContainerLab `conn-framerelay03.yml` topology:  

        ```
           containerlab destroy --topo conn-framerelay03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-framerelay03.tst` file [here](../tst/conn-framerelay03.tst)  
        3. Launch `conn-framerelay03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-framerelay03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-framerelay03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

