# Example: ppp with asymmetric multilink fragmentation

=== "Topology"

    ![Alt text](../d2/conn-ppp12/conn-ppp12.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int ser1
     enc ppp
     ppp ip4cp close
     ppp ip6cp close
     ppp multi 1500 short
     ppp frag 256
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
     enc ppp
     ppp ip4cp close
     ppp ip6cp close
     ppp multi 1500 long
     ppp frag 256
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 15 1.1.1.2 vrf v1 siz 1111
    r2 tping 100 15 1.1.1.1 vrf v1 siz 1111
    r1 tping 100 15 1234::2 vrf v1 siz 1111
    r2 tping 100 15 1234::1 vrf v1 siz 1111
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-ppp12](../clab/conn-ppp12/conn-ppp12.yml) file  
        3. Launch ContainerLab `conn-ppp12.yml` topology:  

        ```
           containerlab deploy --topo conn-ppp12.yml  
        ```
        4. Destroy ContainerLab `conn-ppp12.yml` topology:  

        ```
           containerlab destroy --topo conn-ppp12.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-ppp12.tst` file [here](../tst/conn-ppp12.tst)  
        3. Launch `conn-ppp12.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-ppp12 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-ppp12.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

