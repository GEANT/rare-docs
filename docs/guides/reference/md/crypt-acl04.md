# Example: egress destination matching access list

=== "Topology"

    ![Alt text](../d2/crypt-acl04/crypt-acl04.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    access-list test4
     deny all any all 2.2.2.102 255.255.255.255 all
     deny all any all 2.2.2.202 255.255.255.255 all
     permit all any all any all
     exit
    access-list test6
     deny all any all 4321::102 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     deny all any all 4321::202 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     permit all any all any all
     exit
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.101 255.255.255.255
     ipv6 addr 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.102 255.255.255.255
     ipv6 addr 4321::102 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234::1 ffff:ffff::
     ipv4 access-group-out test4
     ipv6 access-group-out test6
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.2
    ipv6 route v1 :: :: 1234::2
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.201 255.255.255.255
     ipv6 addr 4321::201 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.202 255.255.255.255
     ipv6 addr 4321::202 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234::2 ffff:ffff::
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.1
    ipv6 route v1 :: :: 1234::1
    ```

=== "Verification"

    ```
    r1 tping 100 5 2.2.2.201 vrf v1 sou lo0
    r1 tping 100 5 4321::201 vrf v1 sou lo0
    r1 tping 0 5 2.2.2.202 vrf v1 sou lo0
    r1 tping 0 5 4321::202 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-acl04](../clab/crypt-acl04/crypt-acl04.yml) file  
        3. Launch ContainerLab `crypt-acl04.yml` topology:  

        ```
           containerlab deploy --topo crypt-acl04.yml  
        ```
        4. Destroy ContainerLab `crypt-acl04.yml` topology:  

        ```
           containerlab destroy --topo crypt-acl04.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-acl04.tst` file [here](../tst/crypt-acl04.tst)  
        3. Launch `crypt-acl04.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-acl04 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-acl04.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

