# Example: serial hairpin

=== "Topology"

    ![Alt text](../d2/conn-hairpin02/conn-hairpin02.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    vrf def v2
     rd 1:2
     exit
    hairpin 1
     no ether
     exit
    int hairpin11
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    int hairpin12
     vrf for v2
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 1.1.1.2 vrf v1
    r1 tping 100 5 1.1.1.1 vrf v2
    r1 tping 100 5 1234::2 vrf v1
    r1 tping 100 5 1234::1 vrf v2
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-hairpin02](../clab/conn-hairpin02/conn-hairpin02.yml) file  
        3. Launch ContainerLab `conn-hairpin02.yml` topology:  

        ```
           containerlab deploy --topo conn-hairpin02.yml  
        ```
        4. Destroy ContainerLab `conn-hairpin02.yml` topology:  

        ```
           containerlab destroy --topo conn-hairpin02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-hairpin02.tst` file [here](../tst/conn-hairpin02.tst)  
        3. Launch `conn-hairpin02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-hairpin02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-hairpin02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

