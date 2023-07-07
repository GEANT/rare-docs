# Example: ethernet over sreth pwhe

=== "Topology"

    ![Alt text](../d2/mpls-pwhe21/mpls-pwhe21.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     pseudo v1 lo0 sreth 2.2.2.2 1234
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::1
    int pweth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     pseudo v1 lo0 sreth 2.2.2.1 1234
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 10 4321::2 vrf v1 sou lo0
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 10 4321::1 vrf v1 sou lo0
    r1 tping 100 40 3.3.3.2 vrf v1
    r2 tping 100 40 3.3.3.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-pwhe21](../clab/mpls-pwhe21/mpls-pwhe21.yml) file  
        3. Launch ContainerLab `mpls-pwhe21.yml` topology:  

        ```
           containerlab deploy --topo mpls-pwhe21.yml  
        ```
        4. Destroy ContainerLab `mpls-pwhe21.yml` topology:  

        ```
           containerlab destroy --topo mpls-pwhe21.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-pwhe21.tst` file [here](../tst/mpls-pwhe21.tst)  
        3. Launch `mpls-pwhe21.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-pwhe21 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-pwhe21.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

