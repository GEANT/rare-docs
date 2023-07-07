# Example: egress bridged access list

=== "Topology"

    ![Alt text](../d2/crypt-acl08/crypt-acl08.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    access-list test4
     deny all 1.1.1.2 255.255.255.255 all 1.1.1.3 255.255.255.255 all
     permit all any all any all
     exit
    access-list test6
     deny all 1234::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all 1234::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
     permit all any all any all
     exit
    bridge 1
     exit
    vrf def v1
     rd 1:1
     exit
    int eth1
     bridge-gr 1
     bridge-fi ipv4out test4
     bridge-fi ipv6out test6
     exit
    int eth2
     bridge-gr 1
     bridge-fi ipv4out test4
     bridge-fi ipv6out test6
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff:ffff::
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
     ipv6 addr 1234::2 ffff:ffff::
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff:ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 1.1.1.2 vrf v1
    r1 tping 100 5 1234::2 vrf v1
    r1 tping 100 5 1.1.1.3 vrf v1
    r1 tping 100 5 1234::3 vrf v1
    r2 tping 100 5 1.1.1.1 vrf v1
    r2 tping 100 5 1234::1 vrf v1
    r2 tping 0 5 1.1.1.3 vrf v1
    r2 tping 0 5 1234::3 vrf v1
    r3 tping 100 5 1.1.1.1 vrf v1
    r3 tping 100 5 1234::1 vrf v1
    r3 tping 0 5 1.1.1.2 vrf v1
    r3 tping 0 5 1234::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-acl08](../clab/crypt-acl08/crypt-acl08.yml) file  
        3. Launch ContainerLab `crypt-acl08.yml` topology:  

        ```
           containerlab deploy --topo crypt-acl08.yml  
        ```
        4. Destroy ContainerLab `crypt-acl08.yml` topology:  

        ```
           containerlab destroy --topo crypt-acl08.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-acl08.tst` file [here](../tst/crypt-acl08.tst)  
        3. Launch `crypt-acl08.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-acl08 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-acl08.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

