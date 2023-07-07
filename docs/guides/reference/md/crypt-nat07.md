# Example: ipv4-ipv6 protocol translation

=== "Topology"

    ![Alt text](../d2/crypt-nat07/crypt-nat07.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.2
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     exit
    int eth2
     vrf for v1
     ipv6 addr 1234::101:106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffc
     exit
    int tun1
     tunnel vrf v1
     tunnel key 120
     tunnel mode 6to4
     tunnel source eth2
     tunnel destination 1234::101:101
     vrf for v1
     ipv4 addr 1.1.1.0 255.255.255.0
     ipv6 addr 1234::101:100 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ff00
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv6 addr 1234::101:105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffc
     exit
    ipv6 route v1 :: :: 1234::101:106
    ```

=== "Verification"

    ```
    r2 tping 100 5 1.1.1.1 vrf v1
    r2 tping 100 5 1234::101:105 vrf v1
    r1 tping 100 5 1.1.1.5 vrf v1
    r3 tping 100 5 1234::101:101 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-nat07](../clab/crypt-nat07/crypt-nat07.yml) file  
        3. Launch ContainerLab `crypt-nat07.yml` topology:  

        ```
           containerlab deploy --topo crypt-nat07.yml  
        ```
        4. Destroy ContainerLab `crypt-nat07.yml` topology:  

        ```
           containerlab destroy --topo crypt-nat07.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-nat07.tst` file [here](../tst/crypt-nat07.tst)  
        3. Launch `crypt-nat07.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-nat07 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-nat07.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

