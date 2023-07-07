# Example: source list translation to interface

=== "Topology"

    ![Alt text](../d2/crypt-nat01/crypt-nat01.svg)

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
    ipv4 nat v1 srclist test4 interface ethernet1
    ipv6 nat v1 srclist test6 interface ethernet1
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
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.5
    ipv6 route v1 :: :: 1234:2::1
    ```

=== "Verification"

    ```
    r3 tping 100 5 1.1.1.1 vrf v1
    r3 tping 100 5 1234:1::1 vrf v1
    r2 output show ipv4 nat v1 tran
    r2 output show ipv6 nat v1 tran
    output ../binTmp/crypt-nat.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the translation list:
    here is the ipv6 translation list:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-nat01](../clab/crypt-nat01/crypt-nat01.yml) file  
        3. Launch ContainerLab `crypt-nat01.yml` topology:  

        ```
           containerlab deploy --topo crypt-nat01.yml  
        ```
        4. Destroy ContainerLab `crypt-nat01.yml` topology:  

        ```
           containerlab destroy --topo crypt-nat01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-nat01.tst` file [here](../tst/crypt-nat01.tst)  
        3. Launch `crypt-nat01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-nat01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-nat01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

