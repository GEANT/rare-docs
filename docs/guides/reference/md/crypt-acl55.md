# Example: ingress tos matching hierarchical access list

=== "Topology"

    ![Alt text](../d2/crypt-acl55/crypt-acl55.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    access-list test4a
     permit all any all any all tos 110-120
     exit
    access-list test6a
     permit all any all any all tos 110-120
     exit
    access-list test4b
     evaluate deny test4a
     permit all any all any all
     exit
    access-list test6b
     evaluate deny test6a
     permit all any all any all
     exit
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234::1 ffff:ffff::
     ipv4 access-group-in test4b
     ipv6 access-group-in test6b
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
     ipv6 addr 1234::2 ffff:ffff::
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 5 1.1.1.1 vrf v1 tos 90
    r2 tping 100 5 1234::1 vrf v1 tos 90
    r1 tping 100 5 1.1.1.2 vrf v1 tos 90
    r1 tping 100 5 1234::2 vrf v1 tos 90
    r2 tping 0 5 1.1.1.1 vrf v1 tos 115
    r2 tping 0 5 1234::1 vrf v1 tos 115
    r1 tping 0 5 1.1.1.2 vrf v1 tos 115
    r1 tping 0 5 1234::2 vrf v1 tos 115
    r2 tping 100 5 1.1.1.1 vrf v1 tos 130
    r2 tping 100 5 1234::1 vrf v1 tos 130
    r1 tping 100 5 1.1.1.2 vrf v1 tos 130
    r1 tping 100 5 1234::2 vrf v1 tos 130
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-acl55](../clab/crypt-acl55/crypt-acl55.yml) file  
        3. Launch ContainerLab `crypt-acl55.yml` topology:  

        ```
           containerlab deploy --topo crypt-acl55.yml  
        ```
        4. Destroy ContainerLab `crypt-acl55.yml` topology:  

        ```
           containerlab destroy --topo crypt-acl55.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-acl55.tst` file [here](../tst/crypt-acl55.tst)  
        3. Launch `crypt-acl55.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-acl55 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-acl55.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

