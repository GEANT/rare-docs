# Example: egress source matching common access list

=== "Topology"

    ![Alt text](../d2/crypt-acl28/crypt-acl28.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    access-list test4
     deny all 2.2.2.102 255.255.255.255 all any all
     deny all 2.2.2.202 255.255.255.255 all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321::102 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all any all
     deny all 4321::202 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all any all
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
     ipv4 access-group-common-out test4
     ipv6 access-group-common-out test6
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
    r1 tping 0 5 2.2.2.201 vrf v1 sou lo1
    r1 tping 0 5 4321::201 vrf v1 sou lo1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-acl28](../clab/crypt-acl28/crypt-acl28.yml) file  
        3. Launch ContainerLab `crypt-acl28.yml` topology:  

        ```
           containerlab deploy --topo crypt-acl28.yml  
        ```
        4. Destroy ContainerLab `crypt-acl28.yml` topology:  

        ```
           containerlab destroy --topo crypt-acl28.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-acl28.tst` file [here](../tst/crypt-acl28.tst)  
        3. Launch `crypt-acl28.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-acl28 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-acl28.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

