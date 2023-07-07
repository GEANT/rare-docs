# Example: bridge pmtud out

=== "Topology"

    ![Alt text](../d2/conn-frag13/conn-frag13.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
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
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ```

    **r3**

    ```
    hostname r3
    bridge 1
     exit
    int eth1
     bridge-gr 1
     bridge-pmtud ipv4out 1400 3.3.3.3
     bridge-pmtud ipv6out 1400 3333::3
     exit
    int eth2
     bridge-gr 1
     bridge-pmtud ipv4out 1400 3.3.3.3
     bridge-pmtud ipv6out 1400 3333::3
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
        2. Fetch [conn-frag13](../clab/conn-frag13/conn-frag13.yml) file  
        3. Launch ContainerLab `conn-frag13.yml` topology:  

        ```
           containerlab deploy --topo conn-frag13.yml  
        ```
        4. Destroy ContainerLab `conn-frag13.yml` topology:  

        ```
           containerlab destroy --topo conn-frag13.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-frag13.tst` file [here](../tst/conn-frag13.tst)  
        3. Launch `conn-frag13.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-frag13 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-frag13.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

