# Example: egress length matching access list

=== "Topology"

    ![Alt text](../d2/crypt-acl18/crypt-acl18.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    access-list test4
     deny all any all any all len 100-200
     permit all any all any all
     exit
    access-list test6
     deny all any all any all len 100-200
     permit all any all any all
     exit
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234::1 ffff:ffff::
     ipv4 access-group-out test4
     ipv6 access-group-out test6
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
    r2 tping 100 5 1.1.1.1 vrf v1 siz 50
    r2 tping 100 5 1234::1 vrf v1 siz 50
    r1 tping 100 5 1.1.1.2 vrf v1 siz 50
    r1 tping 100 5 1234::2 vrf v1 siz 50
    r2 tping 0 5 1.1.1.1 vrf v1 siz 110
    r2 tping 0 5 1234::1 vrf v1 siz 110
    r1 tping 0 5 1.1.1.2 vrf v1 siz 110
    r1 tping 0 5 1234::2 vrf v1 siz 110
    r2 tping 100 5 1.1.1.1 vrf v1 siz 250
    r2 tping 100 5 1234::1 vrf v1 siz 250
    r1 tping 100 5 1.1.1.2 vrf v1 siz 250
    r1 tping 100 5 1234::2 vrf v1 siz 250
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-acl18](../clab/crypt-acl18/crypt-acl18.yml) file  
        3. Launch ContainerLab `crypt-acl18.yml` topology:  

        ```
           containerlab deploy --topo crypt-acl18.yml  
        ```
        4. Destroy ContainerLab `crypt-acl18.yml` topology:  

        ```
           containerlab destroy --topo crypt-acl18.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-acl18.tst` file [here](../tst/crypt-acl18.tst)  
        3. Launch `crypt-acl18.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-acl18 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-acl18.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

