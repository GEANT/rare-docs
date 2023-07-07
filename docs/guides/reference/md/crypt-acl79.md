# Example: ingress alert matching access list

=== "Topology"

    ![Alt text](../d2/crypt-acl79/crypt-acl79.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    access-list test4
     deny all any all any all alrt
     permit all any all any all
     exit
    access-list test6
     deny all any all any all alrt
     permit all any all any all
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
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
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 15 1.1.1.2 vrf v1
    r2 tping 100 15 1.1.1.1 vrf v1
    r1 tping 100 15 1234::2 vrf v1
    r2 tping 100 15 1234::1 vrf v1
    r1 tping 100 15 1.1.1.2 vrf v1 alert 123
    r2 tping 0 15 1.1.1.1 vrf v1 alert 123
    r1 tping 100 15 1234::2 vrf v1 alert 123
    r2 tping 0 15 1234::1 vrf v1 alert 123
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-acl79](../clab/crypt-acl79/crypt-acl79.yml) file  
        3. Launch ContainerLab `crypt-acl79.yml` topology:  

        ```
           containerlab deploy --topo crypt-acl79.yml  
        ```
        4. Destroy ContainerLab `crypt-acl79.yml` topology:  

        ```
           containerlab destroy --topo crypt-acl79.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-acl79.tst` file [here](../tst/crypt-acl79.tst)  
        3. Launch `crypt-acl79.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-acl79 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-acl79.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

