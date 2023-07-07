# Example: point2point ethernet encapsulation

=== "Topology"

    ![Alt text](../d2/conn-eth02/conn-eth02.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.254
     ipv6 addr 1234::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffe
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
     ipv4 addr 1.1.1.3 255.255.255.254
     ipv6 addr 1234::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffe
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 1.1.1.3 vrf v1
    r2 tping 100 5 1.1.1.2 vrf v1
    r1 tping 100 5 1234::3 vrf v1
    r2 tping 100 5 1234::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-eth02](../clab/conn-eth02/conn-eth02.yml) file  
        3. Launch ContainerLab `conn-eth02.yml` topology:  

        ```
           containerlab deploy --topo conn-eth02.yml  
        ```
        4. Destroy ContainerLab `conn-eth02.yml` topology:  

        ```
           containerlab destroy --topo conn-eth02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-eth02.tst` file [here](../tst/conn-eth02.tst)  
        3. Launch `conn-eth02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-eth02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-eth02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

