# Example: interface inspection with member ingress drop

=== "Topology"

    ![Alt text](../d2/crypt-insp14/crypt-insp14.svg)

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
     ipv6 addr 1234:1::1 ffff:ffff::
     ipv6 host-static 1234:1::2 0000.0000.2222
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
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
    session ins4
     drop-rx
     exit
    session ins6
     drop-rx
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234:1::2 ffff:ffff::
     ipv6 host-static 1234:1::1 0000.0000.1111
     ipv4 inspect memb ins4
     ipv6 inspect memb ins6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1234:2::2 ffff:ffff::
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.2.3
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::3
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.3 255.255.255.0
     ipv6 addr 1234:2::3 ffff:ffff::
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.2.2
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    ```

=== "Verification"

    ```
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 10 4321::1 vrf v1 sou lo0
    r2 tping 100 10 2.2.2.3 vrf v1 sou lo0
    r2 tping 100 10 4321::3 vrf v1 sou lo0
    r1 tping 0 10 2.2.2.2 vrf v1 sou lo0
    r1 tping 0 10 4321::2 vrf v1 sou lo0
    r1 tping 0 10 2.2.2.3 vrf v1 sou lo0
    r1 tping 0 10 4321::3 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r3 tping 100 10 4321::1 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 10 4321::2 vrf v1 sou lo0
    r2 output show ipv4 insp eth1
    r2 output show ipv6 insp eth1
    r2 output show ipv4 top eth1
    r2 output show ipv6 top eth1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-insp14](../clab/crypt-insp14/crypt-insp14.yml) file  
        3. Launch ContainerLab `crypt-insp14.yml` topology:  

        ```
           containerlab deploy --topo crypt-insp14.yml  
        ```
        4. Destroy ContainerLab `crypt-insp14.yml` topology:  

        ```
           containerlab destroy --topo crypt-insp14.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-insp14.tst` file [here](../tst/crypt-insp14.tst)  
        3. Launch `crypt-insp14.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-insp14 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-insp14.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

