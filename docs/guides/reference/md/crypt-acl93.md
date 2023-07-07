# Example: swipe over ipv6 filtered

=== "Topology"

    ![Alt text](../d2/crypt-acl93/crypt-acl93.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int ser1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    crypto ipsec ips
     cipher des
     hash md5
     key tester
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips
     tunnel mode swipe
     tunnel source ser1
     tunnel destination 1234::2
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
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
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    crypto ipsec ips
     cipher des
     hash md5
     key tester
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips
     tunnel mode swipe
     tunnel source ser1
     tunnel destination 1234::1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 2.2.2.2 vrf v1
    r2 tping 100 5 2.2.2.1 vrf v1
    r1 tping 100 5 4321::2 vrf v1
    r2 tping 100 5 4321::1 vrf v1
    r1 send conf t
    r1 send int ser1
    r1 send mpls srv6-secur
    r1 send end
    r2 send conf t
    r2 send int ser1
    r2 send mpls srv6-secur
    r2 send end
    r1 tping 0 5 2.2.2.2 vrf v1
    r2 tping 0 5 2.2.2.1 vrf v1
    r1 tping 0 5 4321::2 vrf v1
    r2 tping 0 5 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-acl93](../clab/crypt-acl93/crypt-acl93.yml) file  
        3. Launch ContainerLab `crypt-acl93.yml` topology:  

        ```
           containerlab deploy --topo crypt-acl93.yml  
        ```
        4. Destroy ContainerLab `crypt-acl93.yml` topology:  

        ```
           containerlab destroy --topo crypt-acl93.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-acl93.tst` file [here](../tst/crypt-acl93.tst)  
        3. Launch `crypt-acl93.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-acl93 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-acl93.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

