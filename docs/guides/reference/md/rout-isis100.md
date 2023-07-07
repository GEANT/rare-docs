# Example: integrated isis default address suppression

=== "Topology"

    ![Alt text](../d2/rout-isis100/rout-isis100.svg)

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
     both suppress-pref
     both other-suppress-pref
     afi-other enable
     exit
    int lo11
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis4 1 ena
     router isis4 1 other-ena
     router isis4 1 passive
     exit
    int lo21
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis4 1 ena
     router isis4 1 passive
     router isis4 1 other-ena
     exit
    int lo31
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis4 1 ena
     router isis4 1 other-ena
     router isis4 1 passive
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     router isis4 1 ena
     router isis4 1 other-ena
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.2222.00
     red conn
     afi-other enable
     afi-other red conn
     exit
    int lo11
     vrf for v1
     ipv4 addr 2.2.2.111 255.255.255.255
     ipv6 addr 4321::111 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis6 1 ena
     router isis6 1 other-ena
     router isis6 1 passive
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     router isis6 1 ena
     router isis6 1 other-ena
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.111 vrf v1
    r1 tping 100 20 4321::111 vrf v1
    r2 tping 0 20 2.2.2.1 vrf v1
    r2 tping 0 20 4321::1 vrf v1
    r2 tping 0 20 2.2.2.2 vrf v1
    r2 tping 0 20 4321::2 vrf v1
    r2 tping 0 20 2.2.2.3 vrf v1
    r2 tping 0 20 4321::3 vrf v1
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
        2. Fetch [rout-isis100](../clab/rout-isis100/rout-isis100.yml) file  
        3. Launch ContainerLab `rout-isis100.yml` topology:  

        ```
           containerlab deploy --topo rout-isis100.yml  
        ```
        4. Destroy ContainerLab `rout-isis100.yml` topology:  

        ```
           containerlab destroy --topo rout-isis100.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-isis100.tst` file [here](../tst/rout-isis100.tst)  
        3. Launch `rout-isis100.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-isis100 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-isis100.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

