# Example: source prefix translation

=== "Topology"

    ![Alt text](../d2/crypt-nat08/crypt-nat08.svg)

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
     ipv6 addr 1234:1::1 ffff:ffff::
     exit
    ipv4 route v1 7.7.7.0 255.255.255.0 1.1.1.2
    ipv6 route v1 7777:: ffff:ffff:: 1234:1::2
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
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     exit
    access-list test4
     permit all 1.1.1.4 255.255.255.252 all 1.1.1.0 255.255.255.252 all
     exit
    access-list test6
     permit all 1234:2:: ffff:ffff:: all 1234:1:: ffff:ffff:: all
     exit
    ipv4 route v1 8.8.8.8 255.255.255.255 1.1.1.6
    ipv6 route v1 8888::8 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::2
    ipv4 nat v1 srcpref 8.8.8.8 7.7.7.7 255.255.255.0
    ipv6 nat v1 srcpref 8888::8 7777::7 ffff:ffff::
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
     ipv4 addr 8.8.8.8 255.255.255.255
     ipv6 addr 8888::8 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.5
    ipv6 route v1 :: :: 1234:2::1
    ```

=== "Verification"

    ```
    r3 tping 100 5 1.1.1.1 vrf v1 sou lo1
    r3 tping 100 5 1234:1::1 vrf v1 sou lo1
    r2 output show ipv4 nat v1 tran
    r2 output show ipv6 nat v1 tran
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-nat08](../clab/crypt-nat08/crypt-nat08.yml) file  
        3. Launch ContainerLab `crypt-nat08.yml` topology:  

        ```
           containerlab deploy --topo crypt-nat08.yml  
        ```
        4. Destroy ContainerLab `crypt-nat08.yml` topology:  

        ```
           containerlab destroy --topo crypt-nat08.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-nat08.tst` file [here](../tst/crypt-nat08.tst)  
        3. Launch `crypt-nat08.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-nat08 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-nat08.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

