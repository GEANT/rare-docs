# Example: nat64 translation

=== "Topology"

    ![Alt text](../d2/crypt-nat10/crypt-nat10.svg)

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
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
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
     ipv6 addr 1234::1 ffff:ffff::
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.1
    ipv6 route v1 :: :: 1234::2
    access-list nat
     deny all fe80:: ffff:: all any all
     deny all any all fe80:: ffff:: all
     deny all any all ff00:: ff00:: all
     deny all 6464:: ffff:ffff:ffff:ffff:: all 6464:: ffff:ffff:ffff:ffff:: all
     perm all any all 6464:: ffff:ffff:ffff:ffff:: all
     exit
    int tun1
     tun key 96
     tun vrf v1
     tun sou eth2
     tun des 6464::a01:4042
     tun mod 6to4
     vrf forwarding v1
     ipv4 addr 10.1.64.65 255.255.255.252
     ipv6 addr 6464::a01:4042 ffff:ffff:ffff:ffff:ffff:ffff::
     exit
    ipv6 nat v1 srclist nat int tun1
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv6 addr 1234::2 ffff:ffff::
     exit
    int lo1
     vrf for v1
     ipv6 addr 8888::8 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    ipv6 route v1 :: :: 1234::1
    ```

=== "Verification"

    ```
    r1 tping 100 5 1.1.1.2 vrf v1
    r3 tping 100 5 1234::1 vrf v1
    r3 tping 100 5 6464::0202:0202 vrf v1 sou lo1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-nat10](../clab/crypt-nat10/crypt-nat10.yml) file  
        3. Launch ContainerLab `crypt-nat10.yml` topology:  

        ```
           containerlab deploy --topo crypt-nat10.yml  
        ```
        4. Destroy ContainerLab `crypt-nat10.yml` topology:  

        ```
           containerlab destroy --topo crypt-nat10.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-nat10.tst` file [here](../tst/crypt-nat10.tst)  
        3. Launch `crypt-nat10.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-nat10 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-nat10.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

