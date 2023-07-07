# Example: reflexive access list

=== "Topology"

    ![Alt text](../d2/crypt-acl63/crypt-acl63.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    access-list dyn4i
     hidden
     exit
    access-list dyn4o
     hidden
     exit
    access-list dyn6i
     hidden
     exit
    access-list dyn6o
     hidden
     exit
    access-list test4i
     seq 10 evaluate permit dyn4i
     seq 20 deny all any all any all
     exit
    access-list test6i
     seq 1 permit 58 fe80:: ffff:: all any all
     seq 2 permit 58 any all fe80:: ffff:: all
     seq 10 evaluate permit dyn6i
     seq 20 deny all any all any all
     exit
    access-list test4o
     seq 10 evaluate permit dyn4o
     seq 20 permit all any all any all
     seq 20 reflect dyn4o dyn4i 30000
     exit
    access-list test6o
     seq 10 evaluate permit dyn6o
     seq 20 permit all any all any all
     seq 20 reflect dyn6o dyn6i 30000
     exit
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234::1 ffff:ffff::
     ipv4 access-group-in test4i
     ipv6 access-group-in test6i
     ipv4 access-group-out test4o
     ipv6 access-group-out test6o
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
    r1 tping 100 5 1.1.1.1 vrf v1
    r1 tping 100 5 1234::1 vrf v1
    r1 tping 100 5 1.1.1.2 vrf v1
    r1 tping 100 5 1234::2 vrf v1
    r2 tping 100 5 1.1.1.2 vrf v1
    r2 tping 100 5 1234::2 vrf v1
    r2 tping 0 5 1.1.1.1 vrf v1
    r2 tping 0 5 1234::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-acl63](../clab/crypt-acl63/crypt-acl63.yml) file  
        3. Launch ContainerLab `crypt-acl63.yml` topology:  

        ```
           containerlab deploy --topo crypt-acl63.yml  
        ```
        4. Destroy ContainerLab `crypt-acl63.yml` topology:  

        ```
           containerlab destroy --topo crypt-acl63.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-acl63.tst` file [here](../tst/crypt-acl63.tst)  
        3. Launch `crypt-acl63.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-acl63 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-acl63.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

