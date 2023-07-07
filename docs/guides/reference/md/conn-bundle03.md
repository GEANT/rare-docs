# Example: bundle of ethernet ports

=== "Topology"

    ![Alt text](../d2/conn-bundle03/conn-bundle03.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    bundle 1
     exit
    int eth1
     bundle-gr 1
     exit
    int eth2
     bundle-gr 1
     exit
    int bun1
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
    bundle 1
     exit
    int eth1
     bundle-gr 1
     exit
    int eth2
     bundle-gr 1
     exit
    int bun1
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
        2. Fetch [conn-bundle03](../clab/conn-bundle03/conn-bundle03.yml) file  
        3. Launch ContainerLab `conn-bundle03.yml` topology:  

        ```
           containerlab deploy --topo conn-bundle03.yml  
        ```
        4. Destroy ContainerLab `conn-bundle03.yml` topology:  

        ```
           containerlab destroy --topo conn-bundle03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-bundle03.tst` file [here](../tst/conn-bundle03.tst)  
        3. Launch `conn-bundle03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-bundle03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-bundle03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

