# Example: ppp with asymmetric multilink

=== "Topology"

    ![Alt text](../d2/conn-ppp13/conn-ppp13.svg)

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
        2. Fetch [conn-ppp13](../clab/conn-ppp13/conn-ppp13.yml) file  
        3. Launch ContainerLab `conn-ppp13.yml` topology:  

        ```
           containerlab deploy --topo conn-ppp13.yml  
        ```
        4. Destroy ContainerLab `conn-ppp13.yml` topology:  

        ```
           containerlab destroy --topo conn-ppp13.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-ppp13.tst` file [here](../tst/conn-ppp13.tst)  
        3. Launch `conn-ppp13.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-ppp13 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-ppp13.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

