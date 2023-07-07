# Example: ppp with eap authentication

=== "Topology"

    ![Alt text](../d2/conn-ppp07/conn-ppp07.svg)

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
     ppp user c
     ppp pass c
     ppp refuseauth chap
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
    aaa userlist usr
     username c password c
     exit
    int ser1
     enc ppp
     ppp ip4cp close
     ppp ip6cp close
     ppp auth usr
     ppp refuseauth pap
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 15 1.1.1.2 vrf v1
    r2 tping 100 15 1.1.1.1 vrf v1
    r1 tping 100 15 1234::2 vrf v1
    r2 tping 100 15 1234::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-ppp07](../clab/conn-ppp07/conn-ppp07.yml) file  
        3. Launch ContainerLab `conn-ppp07.yml` topology:  

        ```
           containerlab deploy --topo conn-ppp07.yml  
        ```
        4. Destroy ContainerLab `conn-ppp07.yml` topology:  

        ```
           containerlab destroy --topo conn-ppp07.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-ppp07.tst` file [here](../tst/conn-ppp07.tst)  
        3. Launch `conn-ppp07.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-ppp07 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-ppp07.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

