# Example: sdwan over ipv4

=== "Topology"

    ![Alt text](../d2/serv-sdwan01/serv-sdwan01.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    aaa userlist usr
     username u password p
     username u privilege 14
     exit
    crypto rsakey rsa generate 2048
    crypto dsakey dsa generate 1024
    crypto ecdsakey ecdsa generate 256
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 1.1.1.99 255.255.255.255
     ipv6 addr 1234::99 ffff:ffff::
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
    int eth3
     vrf for v1
     ipv4 addr 1.1.1.9 255.255.255.252
     ipv6 addr 1234:3::1 ffff:ffff::
     exit
    ipv4 pool p4 2.2.2.2 0.0.0.1 3
    ipv6 pool p6 2222::2 ::1 3
    server sdwan v9
     security authentication usr
     security rsakey rsa
     security dsakey dsa
     security ecdsakey ecdsa
     pool4 p4
     pool6 p6
     vrf v1
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
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.1
    ipv6 route v1 :: :: 1234:1::1
    proxy-profile p1
     vrf v1
     source eth1
     exit
    int di1
     vrf for v1
     ipv4 addr dyn dyn
     ipv6 addr dyn dyn
     exit
    vpdn sdw
     int di1
     target 1.1.1.99
     proxy p1
     pref ipv4
     user u
     pass p
     proto sdwan
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
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.5
    ipv6 route v1 :: :: 1234:2::1
    proxy-profile p1
     vrf v1
     source eth1
     exit
    int di1
     vrf for v1
     ipv4 addr dyn dyn
     ipv6 addr dyn dyn
     exit
    vpdn sdw
     int di1
     target 1.1.1.99
     proxy p1
     pref ipv4
     user u
     pass p
     proto sdwan
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.10 255.255.255.252
     ipv6 addr 1234:3::2 ffff:ffff::
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.9
    ipv6 route v1 :: :: 1234:3::1
    proxy-profile p1
     vrf v1
     source eth1
     exit
    int di1
     vrf for v1
     ipv4 addr dyn dyn
     ipv6 addr dyn dyn
     exit
    vpdn sdw
     int di1
     target 1.1.1.99
     proxy p1
     pref ipv4
     user u
     pass p
     calling 1701
     proto sdwan
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 1.1.1.2 vrf v1
    r1 tping 100 60 1.1.1.6 vrf v1
    r1 tping 100 60 1.1.1.10 vrf v1
    r1 tping 100 60 1234:1::2 vrf v1
    r1 tping 100 60 1234:2::2 vrf v1
    r1 tping 100 60 1234:3::2 vrf v1
    r2 tping 100 60 2.2.2.2 vrf v1
    r2 tping 100 60 2.2.2.3 vrf v1
    r2 tping 100 60 2.2.2.4 vrf v1
    r3 tping 100 60 2.2.2.2 vrf v1
    r3 tping 100 60 2.2.2.3 vrf v1
    r3 tping 100 60 2.2.2.4 vrf v1
    r4 tping 100 60 2.2.2.2 vrf v1
    r4 tping 100 60 2.2.2.3 vrf v1
    r4 tping 100 60 2.2.2.4 vrf v1
    r2 tping 100 60 2222::2 vrf v1
    r2 tping 100 60 2222::3 vrf v1
    r2 tping 100 60 2222::4 vrf v1
    r3 tping 100 60 2222::2 vrf v1
    r3 tping 100 60 2222::3 vrf v1
    r3 tping 100 60 2222::4 vrf v1
    r4 tping 100 60 2222::2 vrf v1
    r4 tping 100 60 2222::3 vrf v1
    r4 tping 100 60 2222::4 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [serv-sdwan01](../clab/serv-sdwan01/serv-sdwan01.yml) file  
        3. Launch ContainerLab `serv-sdwan01.yml` topology:  

        ```
           containerlab deploy --topo serv-sdwan01.yml  
        ```
        4. Destroy ContainerLab `serv-sdwan01.yml` topology:  

        ```
           containerlab destroy --topo serv-sdwan01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `serv-sdwan01.tst` file [here](../tst/serv-sdwan01.tst)  
        3. Launch `serv-sdwan01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester serv-sdwan01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `serv-sdwan01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

