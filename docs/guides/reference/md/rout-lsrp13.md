# Example: lsrp ssh encryption

=== "Topology"

    ![Alt text](../d2/rout-lsrp13/rout-lsrp13.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    crypto rsakey rsa generate 2048
    crypto dsakey dsa generate 1024
    crypto ecdsakey ecdsa generate 256
    crypto certificate dsa generate dsa dsa
    crypto certificate rsa generate rsa rsa
    crypto certificate ecdsa generate ecdsa ecdsa
    vrf def v1
     rd 1:1
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.1
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.1
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     router lsrp4 1 ena
     router lsrp4 1 encryption ssh rsa dsa ecdsa rsa dsa ecdsa
     ipv6 addr 1234:1::1 ffff:ffff::
     router lsrp6 1 ena
     router lsrp6 1 encryption ssh rsa dsa ecdsa rsa dsa ecdsa
     exit
    ```

    **r2**

    ```
    hostname r2
    crypto rsakey rsa generate 2048
    crypto dsakey dsa generate 1024
    crypto ecdsakey ecdsa generate 256
    crypto certificate dsa generate dsa dsa
    crypto certificate rsa generate rsa rsa
    crypto certificate ecdsa generate ecdsa ecdsa
    vrf def v1
     rd 1:1
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.2
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.2
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     router lsrp4 1 ena
     router lsrp4 1 encryption ssh rsa dsa ecdsa rsa dsa ecdsa
     ipv6 addr 1234:1::2 ffff:ffff::
     router lsrp6 1 ena
     router lsrp6 1 encryption ssh rsa dsa ecdsa rsa dsa ecdsa
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 40 2.2.2.2 vrf v1
    r1 tping 100 40 4321::2 vrf v1
    r2 tping 100 40 2.2.2.1 vrf v1
    r2 tping 100 40 4321::1 vrf v1
    r2 output show ipv4 lsrp 1 nei
    r2 output show ipv6 lsrp 1 nei
    r2 output show ipv4 lsrp 1 dat
    r2 output show ipv6 lsrp 1 dat
    r2 output show ipv4 lsrp 1 tre
    r2 output show ipv6 lsrp 1 tre
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-lsrp13](../clab/rout-lsrp13/rout-lsrp13.yml) file  
        3. Launch ContainerLab `rout-lsrp13.yml` topology:  

        ```
           containerlab deploy --topo rout-lsrp13.yml  
        ```
        4. Destroy ContainerLab `rout-lsrp13.yml` topology:  

        ```
           containerlab destroy --topo rout-lsrp13.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-lsrp13.tst` file [here](../tst/rout-lsrp13.tst)  
        3. Launch `rout-lsrp13.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-lsrp13 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-lsrp13.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

