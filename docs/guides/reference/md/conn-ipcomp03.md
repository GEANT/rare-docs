# Example: ipcomp over ipcomp

=== "Topology"

    ![Alt text](../d2/conn-ipcomp03/conn-ipcomp03.svg)

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
     exit
    int tun1
     tunnel vrf v1
     tunnel mode ipcomp
     tunnel source ethernet1
     tunnel destination 1.1.1.2
     vrf for v1
     ipv6 addr 1234::1 ffff::
     exit
    int tun2
     tunnel vrf v1
     tunnel mode ipcomp
     tunnel source tun1
     tunnel destination 1234::2
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
     exit
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
     exit
    int tun1
     tunnel vrf v1
     tunnel mode ipcomp
     tunnel source ethernet1
     tunnel destination 1.1.1.1
     vrf for v1
     ipv6 addr 1234::2 ffff::
     exit
    int tun2
     tunnel vrf v1
     tunnel mode ipcomp
     tunnel source tun1
     tunnel destination 1234::1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 1234::2 vrf v1
    r2 tping 100 5 1234::1 vrf v1
    r1 tping 100 5 2.2.2.2 vrf v1
    r2 tping 100 5 2.2.2.1 vrf v1
    r1 tping 100 5 4321::2 vrf v1
    r2 tping 100 5 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-ipcomp03](../clab/conn-ipcomp03/conn-ipcomp03.yml) file  
        3. Launch ContainerLab `conn-ipcomp03.yml` topology:  

        ```
           containerlab deploy --topo conn-ipcomp03.yml  
        ```
        4. Destroy ContainerLab `conn-ipcomp03.yml` topology:  

        ```
           containerlab destroy --topo conn-ipcomp03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-ipcomp03.tst` file [here](../tst/conn-ipcomp03.tst)  
        3. Launch `conn-ipcomp03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-ipcomp03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-ipcomp03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

