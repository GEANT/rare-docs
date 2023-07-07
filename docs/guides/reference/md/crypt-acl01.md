# Example: ingress protocol matching access list

=== "Topology"

    ![Alt text](../d2/crypt-acl01/crypt-acl01.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny 58 any all any all
     permit all any all any all
     exit
    vrf def v1
     rd 1:1
     exit
    int ser1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234::1 ffff:ffff::
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
    int ser1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234::2 ffff:ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 1.1.1.1 vrf v1
    r1 tping 100 5 1234::1 vrf v1
    r1 tping 0 5 1.1.1.2 vrf v1
    r1 tping 0 5 1234::2 vrf v1
    r2 tping -100 5 1.1.1.1 vrf v1 error
    r2 tping -100 5 1234::1 vrf v1 error
    r1 output show access-list test4
    r1 output show access-list test6
    output ../binTmp/crypt-acl.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the ipv4 acl:
    here is the ipv6 acl:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-acl01](../clab/crypt-acl01/crypt-acl01.yml) file  
        3. Launch ContainerLab `crypt-acl01.yml` topology:  

        ```
           containerlab deploy --topo crypt-acl01.yml  
        ```
        4. Destroy ContainerLab `crypt-acl01.yml` topology:  

        ```
           containerlab destroy --topo crypt-acl01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-acl01.tst` file [here](../tst/crypt-acl01.tst)  
        3. Launch `crypt-acl01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-acl01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-acl01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

