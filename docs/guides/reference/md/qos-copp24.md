# Example: qos divert otherflowspec

=== "Topology"

    ![Alt text](../d2/qos-copp24/qos-copp24.svg)

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
     exit
    int ser2
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1235::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    vrf def v3
     rd 1:3
     exit
    vrf def v2
     rd 1:2
     exit
    vrf def v4
     rd 1:4
     exit
    access-list a4
     permit 1 any all any all
     exit
    access-list a6
     permit 58 any all any all
     exit
    policy-map p1
     seq 10 act trans
      match access-group a4
      set vrf v4
     exit
    policy-map p2
     seq 10 act trans
      match access-group a4
      set vrf v2
     exit
    policy-map p3
     seq 10 act trans
      match access-group a6
      set vrf v4
     exit
    policy-map p4
     seq 10 act trans
      match access-group a6
      set vrf v2
     exit
    int ser1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int ser2
     vrf for v2
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int ser3
     vrf for v3
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int ser4
     vrf for v4
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    router bgp4 1
     vrf v1
     afi-other ena
     no afi-other vpn
     afi-other flowspec-install
     afi-other flowspec-advert p3
     exit
    router bgp6 1
     vrf v1
     afi-other ena
     no afi-other vpn
     afi-other flowspec-install
     afi-other flowspec-advert p1
     exit
    router bgp4 3
     vrf v3
     afi-other ena
     no afi-other vpn
     afi-other flowspec-install
     afi-other flowspec-advert p4
     exit
    router bgp6 3
     vrf v3
     afi-other ena
     no afi-other vpn
     afi-other flowspec-install
     afi-other flowspec-advert p2
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int ser1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff::
     exit
    int ser2
     vrf for v1
     ipv4 addr 1.1.2.3 255.255.255.0
     ipv6 addr 1235::3 ffff::
     exit
    ```

=== "Verification"

    ```
    r3 tping 100 15 1.1.1.1 vrf v1 siz 200
    r3 tping 100 15 1234::1 vrf v1 siz 200
    r1 tping 100 15 1.1.1.3 vrf v1 siz 200
    r1 tping 100 15 1234::3 vrf v1 siz 200
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [qos-copp24](../clab/qos-copp24/qos-copp24.yml) file  
        3. Launch ContainerLab `qos-copp24.yml` topology:  

        ```
           containerlab deploy --topo qos-copp24.yml  
        ```
        4. Destroy ContainerLab `qos-copp24.yml` topology:  

        ```
           containerlab destroy --topo qos-copp24.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `qos-copp24.tst` file [here](../tst/qos-copp24.tst)  
        3. Launch `qos-copp24.tst` test:  

        ```
           java -jar ../../rtr.jar test tester qos-copp24 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `qos-copp24.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

