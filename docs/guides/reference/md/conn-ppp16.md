# Example: ppp no remote address

=== "Topology"

    ![Alt text](../d2/conn-ppp16/conn-ppp16.svg)

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
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 2222::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
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
    prefix-list p4
     permit 2.2.2.1/32
     exit
    prefix-list p6
     permit 2222::1/128
     exit
    int lo1
     vrf for v1
     ipv4 addr 1.1.1.0 255.255.255.252
     ipv6 addr 1234::0 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ff00
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
     ipv4 gateway-prefix p4
     ipv6 gateway-prefix p6
     no ipv4 gateway-remote
     no ipv6 gateway-remote
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 15 1.1.1.2 vrf v1 sou lo0
    r1 tping 100 15 1234::2 vrf v1 sou lo0
    r2 tping 0 15 1.1.1.1 vrf v1
    r2 tping 0 15 1234::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-ppp16](../clab/conn-ppp16/conn-ppp16.yml) file  
        3. Launch ContainerLab `conn-ppp16.yml` topology:  

        ```
           containerlab deploy --topo conn-ppp16.yml  
        ```
        4. Destroy ContainerLab `conn-ppp16.yml` topology:  

        ```
           containerlab destroy --topo conn-ppp16.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-ppp16.tst` file [here](../tst/conn-ppp16.tst)  
        3. Launch `conn-ppp16.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-ppp16 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-ppp16.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

