# Example: isis md5 authentication

=== "Topology"

    ![Alt text](../d2/rout-isis103/rout-isis103.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.1111.00
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.1111.00
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     router isis4 1 ena
     router isis4 1 password tester
     router isis4 1 authen-type md5
     exit
    int eth1.12
     vrf for v1
     ipv6 addr 1234::1 ffff::
     router isis6 1 ena
     router isis6 1 password tester
     router isis6 1 authen-type md5
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.2222.00
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.2222.00
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     router isis4 1 ena
     router isis4 1 password tester
     router isis4 1 authen-type md5
     exit
    int eth1.12
     vrf for v1
     ipv6 addr 1234::2 ffff::
     router isis6 1 ena
     router isis6 1 password tester
     router isis6 1 authen-type md5
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r2 tping 100 20 4321::1 vrf v1
    r2 output show ipv4 isis 1 nei
    r2 output show ipv6 isis 1 nei
    r2 output show ipv4 isis 1 dat 2
    r2 output show ipv6 isis 1 dat 2
    r2 output show ipv4 isis 1 tre 2
    r2 output show ipv6 isis 1 tre 2
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-isis103](../clab/rout-isis103/rout-isis103.yml) file  
        3. Launch ContainerLab `rout-isis103.yml` topology:  

        ```
           containerlab deploy --topo rout-isis103.yml  
        ```
        4. Destroy ContainerLab `rout-isis103.yml` topology:  

        ```
           containerlab destroy --topo rout-isis103.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-isis103.tst` file [here](../tst/rout-isis103.tst)  
        3. Launch `rout-isis103.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-isis103 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-isis103.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

