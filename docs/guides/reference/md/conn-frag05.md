# Example: pmtud out

=== "Topology"

    ![Alt text](../d2/conn-frag05/conn-frag05.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int ser1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     ipv4 pmtud-out 1400
     ipv6 pmtud-out 1400
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int ser1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     ipv4 pmtud-out 1400
     ipv6 pmtud-out 1400
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 15 1.1.1.2 vrf v1 siz 1400
    r2 tping 100 15 1.1.1.1 vrf v1 siz 1400
    r1 tping 100 15 1234::2 vrf v1 siz 1400
    r2 tping 100 15 1234::1 vrf v1 siz 1400
    r1 tping -100 15 1.1.1.2 vrf v1 siz 1401 error
    r2 tping -100 15 1.1.1.1 vrf v1 siz 1401 error
    r1 tping -100 15 1234::2 vrf v1 siz 1401 error
    r2 tping -100 15 1234::1 vrf v1 siz 1401 error
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-frag05](../clab/conn-frag05/conn-frag05.yml) file  
        3. Launch ContainerLab `conn-frag05.yml` topology:  

        ```
           containerlab deploy --topo conn-frag05.yml  
        ```
        4. Destroy ContainerLab `conn-frag05.yml` topology:  

        ```
           containerlab destroy --topo conn-frag05.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-frag05.tst` file [here](../tst/conn-frag05.tst)  
        3. Launch `conn-frag05.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-frag05 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-frag05.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

