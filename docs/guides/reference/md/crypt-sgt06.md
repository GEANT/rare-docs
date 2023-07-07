# Example: sgt ppp encapsulation

=== "Topology"

    ![Alt text](../d2/crypt-sgt06/crypt-sgt06.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int ser1
     vrf for v1
     enc ppp
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     sgt ena
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int ser1
     enc ppp
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     sgt ena
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
        2. Fetch [crypt-sgt06](../clab/crypt-sgt06/crypt-sgt06.yml) file  
        3. Launch ContainerLab `crypt-sgt06.yml` topology:  

        ```
           containerlab deploy --topo crypt-sgt06.yml  
        ```
        4. Destroy ContainerLab `crypt-sgt06.yml` topology:  

        ```
           containerlab destroy --topo crypt-sgt06.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-sgt06.tst` file [here](../tst/crypt-sgt06.tst)  
        3. Launch `crypt-sgt06.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-sgt06 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-sgt06.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

