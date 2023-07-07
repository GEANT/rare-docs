# Example: ppp labeled gateway

=== "Topology"

    ![Alt text](../d2/conn-ppp15/conn-ppp15.svg)

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
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 1234:: ffff:: all 1234:: ffff:: all
     permit all any all any all
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
     ipv4 gateway-label expli
     ipv6 gateway-label expli
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     no ipv4 unreachables
     no ipv6 unreachables
     mpls enable
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 1234:: ffff:: all 1234:: ffff:: all
     permit all any all any all
     exit
    prefix-list p6
     permit 1234::1/128
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
     ipv4 gateway-label expli
     ipv6 gateway-label expli
     ipv6 slaac ena
     ipv6 gateway-prefix p6
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     no ipv4 unreachables
     no ipv6 unreachables
     mpls enable
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
        2. Fetch [conn-ppp15](../clab/conn-ppp15/conn-ppp15.yml) file  
        3. Launch ContainerLab `conn-ppp15.yml` topology:  

        ```
           containerlab deploy --topo conn-ppp15.yml  
        ```
        4. Destroy ContainerLab `conn-ppp15.yml` topology:  

        ```
           containerlab destroy --topo conn-ppp15.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-ppp15.tst` file [here](../tst/conn-ppp15.tst)  
        3. Launch `conn-ppp15.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-ppp15 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-ppp15.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

