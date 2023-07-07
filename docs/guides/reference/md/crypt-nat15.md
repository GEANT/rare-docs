# Example: ipv6 target port selection

=== "Topology"

    ![Alt text](../d2/crypt-nat15/crypt-nat15.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    vrf def v2
     rd 1:1
     exit
    int lo1
     vrf for v2
     ipv4 addr 3.3.3.3 255.255.255.255
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     exit
    int tun1
     tun sou eth1
     tun dest 1.1.1.2
     tun vrf v1
     tun dom 1234:1::2 10000-19999 1234:2::2 20000-29999
     tun mod aplusp
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.252
     ipv6 addr 4321::1234 ffff:ffff::
     exit
    server telnet tel
     vrf v1
     port 666
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
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.1
    ipv6 route v1 :: :: 1234:1::1
    client tcp-portrange 12000 13000
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.5
    ipv6 route v1 :: :: 1234:2::1
    client tcp-portrange 22000 23000
    ```

=== "Verification"

    ```
    r2 tping 100 5 1.1.1.1 vrf v1
    r2 tping 100 5 1234:1::1 vrf v1
    r3 tping 100 5 1.1.1.5 vrf v1
    r3 tping 100 5 1234:2::1 vrf v1
    r2 send telnet 1234:1::1 666 vrf v1 sou lo1
    r2 tping 100 5 3.3.3.3 vrf v2
    r2 send exit
    r2 read closed
    r3 send telnet 1234:1::1 666 vrf v1 sou lo1
    r3 tping 100 5 3.3.3.3 vrf v2
    r3 send exit
    r3 read closed
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-nat15](../clab/crypt-nat15/crypt-nat15.yml) file  
        3. Launch ContainerLab `crypt-nat15.yml` topology:  

        ```
           containerlab deploy --topo crypt-nat15.yml  
        ```
        4. Destroy ContainerLab `crypt-nat15.yml` topology:  

        ```
           containerlab destroy --topo crypt-nat15.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-nat15.tst` file [here](../tst/crypt-nat15.tst)  
        3. Launch `crypt-nat15.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-nat15 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-nat15.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

