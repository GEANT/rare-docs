# Example: static routing with interface

=== "Topology"

    ![Alt text](../d2/rout-static07/rout-static07.svg)

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
     ipv6 addr 1234::1 ffff:ffff::
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff:ffff::
     exit
    ipv4 route v1 1.1.1.2 255.255.255.255 1.1.1.2 inter eth1
    ipv4 route v1 1.1.1.3 255.255.255.255 1.1.1.3 inter eth2
    ipv6 route v1 1234::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2 int eth1
    ipv6 route v1 1234::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::3 int eth2
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff:ffff::
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
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff:ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 1.1.1.2 vrf v1
    r1 tping 100 5 1.1.1.3 vrf v1
    r1 tping 100 5 1234::2 vrf v1
    r1 tping 100 5 1234::3 vrf v1
    r2 tping 100 5 1.1.1.1 vrf v1
    r2 tping 100 5 1234::1 vrf v1
    r3 tping 100 5 1.1.1.1 vrf v1
    r3 tping 100 5 1234::1 vrf v1
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-static07](../clab/rout-static07/rout-static07.yml) file  
        3. Launch ContainerLab `rout-static07.yml` topology:  

        ```
           containerlab deploy --topo rout-static07.yml  
        ```
        4. Destroy ContainerLab `rout-static07.yml` topology:  

        ```
           containerlab destroy --topo rout-static07.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-static07.tst` file [here](../tst/rout-static07.tst)  
        3. Launch `rout-static07.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-static07 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-static07.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

