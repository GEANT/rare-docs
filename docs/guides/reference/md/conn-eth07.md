# Example: ethernet qinq1 encapsulation

=== "Topology"

    ![Alt text](../d2/conn-eth07/conn-eth07.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     enc qinq1
     exit
    int eth1.11
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
    int eth1
     enc qinq1
     exit
    int eth1.11
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
        2. Fetch [conn-eth07](../clab/conn-eth07/conn-eth07.yml) file  
        3. Launch ContainerLab `conn-eth07.yml` topology:  

        ```
           containerlab deploy --topo conn-eth07.yml  
        ```
        4. Destroy ContainerLab `conn-eth07.yml` topology:  

        ```
           containerlab destroy --topo conn-eth07.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-eth07.tst` file [here](../tst/conn-eth07.tst)  
        3. Launch `conn-eth07.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-eth07 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-eth07.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

