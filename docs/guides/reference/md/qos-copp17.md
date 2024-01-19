# Example: qos policer otherflowspec

=== "Topology"

    ![Alt text](../d2/qos-copp17/qos-copp17.svg)

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
     seq 10 act pol
      access-rate 163840
      match access-group a4
     exit
    policy-map p6
     seq 10 act pol
      access-rate 163840
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
    r2 tping 100 5 1.1.1.1 vrf v1
    r2 tping 100 5 1234::1 vrf v1
    r2 tping 85-95 5 1.1.1.1 vrf v1 rep 100 tim 500 siz 100
    r2 tping 85-95 5 1234::1 vrf v1 rep 100 tim 500 siz 100
    r1 tping 85-95 5 1.1.1.2 vrf v1 rep 100 tim 500 siz 100
    r1 tping 85-95 5 1234::2 vrf v1 rep 100 tim 500 siz 100
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [qos-copp17](../clab/qos-copp17/qos-copp17.yml) file  
        3. Launch ContainerLab `qos-copp17.yml` topology:  

        ```
           containerlab deploy --topo qos-copp17.yml  
        ```
        4. Destroy ContainerLab `qos-copp17.yml` topology:  

        ```
           containerlab destroy --topo qos-copp17.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `qos-copp17.tst` file [here](../tst/qos-copp17.tst)  
        3. Launch `qos-copp17.tst` test:  

        ```
           java -jar ../../rtr.jar test tester qos-copp17 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `qos-copp17.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```
