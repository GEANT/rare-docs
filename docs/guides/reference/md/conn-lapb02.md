# Example: lapb mod128

=== "Topology"

    ![Alt text](../d2/conn-lapb02/conn-lapb02.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int ser1
     enc lapb
     lapb mode dce
     lapb modul 128
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
     enc lapb
     lapb modul 128
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 15 1.1.1.2 vrf v1
    r2 tping 100 15 1.1.1.1 vrf v1
    r1 tping 100 15 1234::2 vrf v1
    r2 tping 100 15 1234::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-lapb02](../clab/conn-lapb02/conn-lapb02.yml) file  
        3. Launch ContainerLab `conn-lapb02.yml` topology:  

        ```
           containerlab deploy --topo conn-lapb02.yml  
        ```
        4. Destroy ContainerLab `conn-lapb02.yml` topology:  

        ```
           containerlab destroy --topo conn-lapb02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-lapb02.tst` file [here](../tst/conn-lapb02.tst)  
        3. Launch `conn-lapb02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-lapb02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-lapb02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

