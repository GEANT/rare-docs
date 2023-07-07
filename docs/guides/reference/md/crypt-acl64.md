# Example: ingress mpls access list

=== "Topology"

    ![Alt text](../d2/crypt-acl64/crypt-acl64.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    access-list test
     deny all any all 2.2.2.102 255.255.255.255 all
     deny all any all 2.2.2.202 255.255.255.255 all
     deny all any all 4321::102 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     deny all any all 4321::202 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     permit all any all any all
     exit
    vrf def v1
     rd 1:1
     label-mode per-prefix
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
     mpls enable
     mpls ldp4
     mpls ldp6
     mpls label-secu
     mpls access-group-in test
     exit
    ipv4 route v1 2.2.2.201 255.255.255.255 1.1.1.2
    ipv4 route v1 2.2.2.202 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::201 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
    ipv6 route v1 4321::202 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
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
     mpls enable
     mpls ldp4
     mpls ldp6
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     no ipv4 unreachables
     no ipv6 unreachables
     exit
    ipv4 route v1 2.2.2.101 255.255.255.255 1.1.1.1
    ipv4 route v1 2.2.2.102 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::1
    ipv6 route v1 4321::102 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::1
    ```

=== "Verification"

    ```
    r1 tping 100 10 2.2.2.201 vrf v1 sou lo0
    r1 tping 100 10 4321::201 vrf v1 sou lo0
    r1 tping 0 10 2.2.2.201 vrf v1 sou lo1
    r1 tping 0 10 4321::201 vrf v1 sou lo1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-acl64](../clab/crypt-acl64/crypt-acl64.yml) file  
        3. Launch ContainerLab `crypt-acl64.yml` topology:  

        ```
           containerlab deploy --topo crypt-acl64.yml  
        ```
        4. Destroy ContainerLab `crypt-acl64.yml` topology:  

        ```
           containerlab destroy --topo crypt-acl64.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-acl64.tst` file [here](../tst/crypt-acl64.tst)  
        3. Launch `crypt-acl64.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-acl64 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-acl64.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

