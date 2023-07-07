# Example: egress sgt matching access list

=== "Topology"

    ![Alt text](../d2/crypt-acl77/crypt-acl77.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     sgt ena
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234::1 ffff:ffff::
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
    access-list test4
     deny all any all any all sgt 123
     permit all any all any all
     exit
    access-list test6
     deny all any all any all sgt 123
     permit all any all any all
     exit
    int eth1
     vrf for v1
     sgt ena
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234::2 ffff:ffff::
     ipv4 access-group-out test4
     ipv6 access-group-out test6
     exit
    int eth2
     vrf for v1
     sgt ass 123
     ipv4 addr 2.2.2.1 255.255.255.252
     ipv6 addr 4321::1 ffff:ffff::
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth2
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.252
     ipv6 addr 4321::2 ffff:ffff::
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 2.2.2.1
    ipv6 route v1 :: :: 4321::1
    ```

=== "Verification"

    ```
    r2 tping 100 5 1.1.1.1 vrf v1 ttl 90
    r2 tping 100 5 1234::1 vrf v1 ttl 90
    r2 tping 100 5 2.2.2.2 vrf v1 ttl 90
    r2 tping 100 5 4321::2 vrf v1 ttl 90
    r1 tping 100 5 2.2.2.1 vrf v1 ttl 90
    r1 tping 100 5 4321::1 vrf v1 ttl 90
    r1 tping 0 5 2.2.2.2 vrf v1 ttl 90
    r1 tping 0 5 4321::2 vrf v1 ttl 90
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-acl77](../clab/crypt-acl77/crypt-acl77.yml) file  
        3. Launch ContainerLab `crypt-acl77.yml` topology:  

        ```
           containerlab deploy --topo crypt-acl77.yml  
        ```
        4. Destroy ContainerLab `crypt-acl77.yml` topology:  

        ```
           containerlab destroy --topo crypt-acl77.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-acl77.tst` file [here](../tst/crypt-acl77.tst)  
        3. Launch `crypt-acl77.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-acl77 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-acl77.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

