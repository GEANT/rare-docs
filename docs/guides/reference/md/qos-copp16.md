# Example: qos drop otherflowspec

=== "Topology"

    ![Alt text](../d2/qos-copp16/qos-copp16.svg)

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
    access-list a4
     permit 1 any all any all
     exit
    access-list a6
     permit 58 any all any all
     exit
    policy-map p4
     seq 10 act drop
      match access-group a4
     exit
    policy-map p6
     seq 10 act drop
      match access-group a6
     exit
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    router bgp4 1
     vrf v1
     afi-other ena
     no afi-other vpn
     afi-other flowspec-install
     afi-other flowspec-advert p6
     exit
    router bgp6 1
     vrf v1
     afi-other ena
     no afi-other vpn
     afi-other flowspec-install
     afi-other flowspec-advert p4
     exit
    ```

=== "Verification"

    ```
    r2 tping 0 5 1.1.1.1 vrf v1 siz 200
    r2 tping 0 5 1234::1 vrf v1 siz 200
    r1 tping 0 5 1.1.1.2 vrf v1 siz 200
    r1 tping 0 5 1234::2 vrf v1 siz 200
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [qos-copp16](../clab/qos-copp16/qos-copp16.yml) file  
        3. Launch ContainerLab `qos-copp16.yml` topology:  

        ```
           containerlab deploy --topo qos-copp16.yml  
        ```
        4. Destroy ContainerLab `qos-copp16.yml` topology:  

        ```
           containerlab destroy --topo qos-copp16.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `qos-copp16.tst` file [here](../tst/qos-copp16.tst)  
        3. Launch `qos-copp16.tst` test:  

        ```
           java -jar ../../rtr.jar test tester qos-copp16 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `qos-copp16.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

