# Example: ppp address propagation

=== "Topology"

    ![Alt text](../d2/conn-ppp14/conn-ppp14.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    aaa userlist usr
     username c password c
     exit
    int ser1
     enc ppp
     ppp ip4cp open
     ppp ip6cp open
     ppp auth usr
     ppp ip4cp local 1.1.1.1
     ppp ip4cp peer 1.1.1.2
     ppp ip6cp keep
     ppp ip6cp local 0000-0000-0000-0001
     ppp ip6cp peer 0000-0000-0000-0002
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff:ffff:ffff:ffff::
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
     ppp ip4cp open
     ppp ip6cp open
     ppp user c
     ppp pass c
     ppp ip4cp local 0.0.0.0
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.255
     ipv6 addr 3333::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     ipv6 slaac ena
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
        2. Fetch [conn-ppp14](../clab/conn-ppp14/conn-ppp14.yml) file  
        3. Launch ContainerLab `conn-ppp14.yml` topology:  

        ```
           containerlab deploy --topo conn-ppp14.yml  
        ```
        4. Destroy ContainerLab `conn-ppp14.yml` topology:  

        ```
           containerlab destroy --topo conn-ppp14.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-ppp14.tst` file [here](../tst/conn-ppp14.tst)  
        3. Launch `conn-ppp14.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-ppp14 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-ppp14.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

