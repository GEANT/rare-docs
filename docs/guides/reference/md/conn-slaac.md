# Example: slaac

=== "Topology"

    ![Alt text](../d2/conn-slaac/conn-slaac.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv6 addr 1234::1 ffff::
     exit
    int lo0
     vrf for v1
     ipv6 addr 4444::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    prefix-list p6
     permit ::/0
     exit
    int eth1
     vrf for v1
     ipv6 addr 3333::3 ffff::
     ipv6 slaac ena
     ipv6 gateway-prefix p6
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 20 1234::1 vrf v1
    r2 tping 100 5 4444::4 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-slaac](../clab/conn-slaac/conn-slaac.yml) file  
        3. Launch ContainerLab `conn-slaac.yml` topology:  

        ```
           containerlab deploy --topo conn-slaac.yml  
        ```
        4. Destroy ContainerLab `conn-slaac.yml` topology:  

        ```
           containerlab destroy --topo conn-slaac.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-slaac.tst` file [here](../tst/conn-slaac.tst)  
        3. Launch `conn-slaac.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-slaac path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-slaac.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

