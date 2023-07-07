# Example: ingress fragment matching access list

=== "Topology"

    ![Alt text](../d2/crypt-acl78/crypt-acl78.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    access-list test4
     deny all any all any all frag
     permit all any all any all
     exit
    access-list test6
     deny all any all any all frag
     permit all any all any all
     exit
    int eth1
     mtu 1500
     enforce-mtu both
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     ipv4 reassembly 16
     ipv4 fragmentation 1400
     ipv6 reassembly 16
     ipv6 fragmentation 1400
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int eth1
     mtu 1500
     enforce-mtu both
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     ipv4 reassembly 16
     ipv4 fragmentation 1400
     ipv6 reassembly 16
     ipv6 fragmentation 1400
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 15 1.1.1.2 vrf v1 siz 222
    r2 tping 100 15 1.1.1.1 vrf v1 siz 222
    r1 tping 100 15 1234::2 vrf v1 siz 222
    r2 tping 100 15 1234::1 vrf v1 siz 222
    r1 tping 0 15 1.1.1.2 vrf v1 siz 2222
    r2 tping 0 15 1.1.1.1 vrf v1 siz 2222
    r1 tping 0 15 1234::2 vrf v1 siz 2222
    r2 tping 0 15 1234::1 vrf v1 siz 2222
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-acl78](../clab/crypt-acl78/crypt-acl78.yml) file  
        3. Launch ContainerLab `crypt-acl78.yml` topology:  

        ```
           containerlab deploy --topo crypt-acl78.yml  
        ```
        4. Destroy ContainerLab `crypt-acl78.yml` topology:  

        ```
           containerlab destroy --topo crypt-acl78.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-acl78.tst` file [here](../tst/crypt-acl78.tst)  
        3. Launch `crypt-acl78.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-acl78 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-acl78.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

