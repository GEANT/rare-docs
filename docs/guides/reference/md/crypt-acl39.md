# Example: ingress source port matching hybrid access list

=== "Topology"

    ![Alt text](../d2/crypt-acl39/crypt-acl39.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    object-group port test
     123
     exit
    access-list test4
     deny all any obj test any all
     permit all any all any all
     exit
    access-list test6
     deny all any obj test any all
     permit all any all any all
     exit
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234::1 ffff:ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    int tun1
     tun vrf v1
     tun sou eth1
     tun dest 1.1.1.2
     tun key 123
     tun mod pckoudp
     vrf for v1
     ipv4 addr 2.2.1.1 255.255.255.0
     exit
    int tun2
     tun vrf v1
     tun sou eth1
     tun dest 1234::2
     tun key 123
     tun mod pckoudp
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     exit
    int tun3
     tun vrf v1
     tun sou eth1
     tun dest 1.1.1.2
     tun key 321
     tun mod pckoudp
     vrf for v1
     ipv4 addr 2.2.3.1 255.255.255.0
     exit
    int tun4
     tun vrf v1
     tun sou eth1
     tun dest 1234::2
     tun key 321
     tun mod pckoudp
     vrf for v1
     ipv4 addr 2.2.4.1 255.255.255.0
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
    int tun1
     tun vrf v1
     tun sou eth1
     tun dest 1.1.1.1
     tun key 123
     tun mod pckoudp
     vrf for v1
     ipv4 addr 2.2.1.2 255.255.255.0
     exit
    int tun2
     tun vrf v1
     tun sou eth1
     tun dest 1234::1
     tun key 123
     tun mod pckoudp
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     exit
    int tun3
     tun vrf v1
     tun sou eth1
     tun dest 1.1.1.1
     tun key 321
     tun mod pckoudp
     vrf for v1
     ipv4 addr 2.2.3.2 255.255.255.0
     exit
    int tun4
     tun vrf v1
     tun sou eth1
     tun dest 1234::1
     tun key 321
     tun mod pckoudp
     vrf for v1
     ipv4 addr 2.2.4.2 255.255.255.0
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 1.1.1.2 vrf v1
    r1 tping 100 5 1234::2 vrf v1
    r1 tping 0 5 2.2.1.2 vrf v1
    r1 tping 0 5 2.2.2.2 vrf v1
    r1 tping 100 5 2.2.3.2 vrf v1
    r1 tping 100 5 2.2.4.2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-acl39](../clab/crypt-acl39/crypt-acl39.yml) file  
        3. Launch ContainerLab `crypt-acl39.yml` topology:  

        ```
           containerlab deploy --topo crypt-acl39.yml  
        ```
        4. Destroy ContainerLab `crypt-acl39.yml` topology:  

        ```
           containerlab destroy --topo crypt-acl39.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-acl39.tst` file [here](../tst/crypt-acl39.tst)  
        3. Launch `crypt-acl39.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-acl39 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-acl39.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

