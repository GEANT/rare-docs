# Example: ipv6 in esp over ipv6

=== "Topology"

    ![Alt text](../d2/crypt-esp104/crypt-esp104.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    crypto ipsec ips
     group 02
     cipher des
     hash md5
     seconds 3600
     bytes 1024000
     key tester
     role static
     isakmp 1
     protected ipv6
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips
     tunnel mode ipsec
     tunnel source ethernet1
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
    crypto ipsec ips
     group 02
     cipher des
     hash md5
     seconds 3600
     bytes 1024000
     key tester
     role static
     isakmp 1
     protected ipv6
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips
     tunnel mode ipsec
     tunnel source ethernet1
     tunnel destination 1234::1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 0 5 2.2.2.2 vrf v1
    r2 tping 0 5 2.2.2.1 vrf v1
    r1 tping 100 5 4321::2 vrf v1
    r2 tping 100 5 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-esp104](../clab/crypt-esp104/crypt-esp104.yml) file  
        3. Launch ContainerLab `crypt-esp104.yml` topology:  

        ```
           containerlab deploy --topo crypt-esp104.yml  
        ```
        4. Destroy ContainerLab `crypt-esp104.yml` topology:  

        ```
           containerlab destroy --topo crypt-esp104.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-esp104.tst` file [here](../tst/crypt-esp104.tst)  
        3. Launch `crypt-esp104.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-esp104 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-esp104.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

