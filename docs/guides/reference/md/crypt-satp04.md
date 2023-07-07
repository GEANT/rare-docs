# Example: satp over loopback

=== "Topology"

    ![Alt text](../d2/crypt-satp04/crypt-satp04.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     exit
    int lo0
     vrf for v1
     ipv4 addr 1.1.1.101 255.255.255.255
     exit
    ipv4 route v1 1.1.1.102 255.255.255.255 1.1.1.2
    crypto ipsec ips
     cipher des
     hash md5
     key tester
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips
     tunnel mode satp
     tunnel source lo0
     tunnel destination 1.1.1.102
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
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     exit
    int lo0
     vrf for v1
     ipv4 addr 1.1.1.102 255.255.255.255
     exit
    ipv4 route v1 1.1.1.101 255.255.255.255 1.1.1.1
    crypto ipsec ips
     cipher des
     hash md5
     key tester
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips
     tunnel mode satp
     tunnel source lo0
     tunnel destination 1.1.1.101
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
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-satp04](../clab/crypt-satp04/crypt-satp04.yml) file  
        3. Launch ContainerLab `crypt-satp04.yml` topology:  

        ```
           containerlab deploy --topo crypt-satp04.yml  
        ```
        4. Destroy ContainerLab `crypt-satp04.yml` topology:  

        ```
           containerlab destroy --topo crypt-satp04.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-satp04.tst` file [here](../tst/crypt-satp04.tst)  
        3. Launch `crypt-satp04.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-satp04 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-satp04.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

