# Example: pvrp ssh encryption

=== "Topology"

    ![Alt text](../d2/rout-pvrp21/rout-pvrp21.svg)

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
    router pvrp4 1
     vrf v1
     router 4.4.4.1
     red conn
     exit
    router pvrp6 1
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
     router pvrp4 1 ena
     router pvrp4 1 encryption ssh rsa dsa ecdsa rsa dsa ecdsa
     ipv6 addr 1234:1::1 ffff:ffff::
     router pvrp6 1 ena
     router pvrp6 1 encryption ssh rsa dsa ecdsa rsa dsa ecdsa
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
    router pvrp4 1
     vrf v1
     router 4.4.4.2
     red conn
     exit
    router pvrp6 1
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
     router pvrp4 1 ena
     router pvrp4 1 encryption ssh rsa dsa ecdsa rsa dsa ecdsa
     ipv6 addr 1234:1::2 ffff:ffff::
     router pvrp6 1 ena
     router pvrp6 1 encryption ssh rsa dsa ecdsa rsa dsa ecdsa
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 40 2.2.2.2 vrf v1
    r1 tping 100 40 4321::2 vrf v1
    r2 tping 100 40 2.2.2.1 vrf v1
    r2 tping 100 40 4321::1 vrf v1
    r2 output show ipv4 pvrp 1 sum
    r2 output show ipv6 pvrp 1 sum
    r2 output show ipv4 pvrp 1 rou
    r2 output show ipv6 pvrp 1 rou
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-pvrp21](../clab/rout-pvrp21/rout-pvrp21.yml) file  
        3. Launch ContainerLab `rout-pvrp21.yml` topology:  

        ```
           containerlab deploy --topo rout-pvrp21.yml  
        ```
        4. Destroy ContainerLab `rout-pvrp21.yml` topology:  

        ```
           containerlab destroy --topo rout-pvrp21.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-pvrp21.tst` file [here](../tst/rout-pvrp21.tst)  
        3. Launch `rout-pvrp21.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-pvrp21 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-pvrp21.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

