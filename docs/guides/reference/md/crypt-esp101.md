# Example: ipv4 in esp over ipv4

=== "Topology"

    ![Alt text](../d2/crypt-esp101/crypt-esp101.svg)

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
     protected ipv4
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips
     tunnel mode ipsec
     tunnel source ethernet1
     tunnel destination 1.1.1.2
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
     protected ipv4
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
     tunnel destination 1.1.1.1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 2.2.2.2 vrf v1
    r2 tping 100 5 2.2.2.1 vrf v1
    r1 tping 0 5 4321::2 vrf v1
    r2 tping 0 5 4321::1 vrf v1
    r1 output show inter tun1 full
    output ../binTmp/crypt-esp.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the interface:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-esp101](../clab/crypt-esp101/crypt-esp101.yml) file  
        3. Launch ContainerLab `crypt-esp101.yml` topology:  

        ```
           containerlab deploy --topo crypt-esp101.yml  
        ```
        4. Destroy ContainerLab `crypt-esp101.yml` topology:  

        ```
           containerlab destroy --topo crypt-esp101.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-esp101.tst` file [here](../tst/crypt-esp101.tst)  
        3. Launch `crypt-esp101.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-esp101 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-esp101.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

