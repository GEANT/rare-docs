# Example: isis over ppp

=== "Topology"

    ![Alt text](../d2/rout-isis005/rout-isis005.svg)

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
    int ser1
     enc ppp
     ppp ip4cp close
     ppp ip6cp close
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     router isis4 1 ena
     router isis4 1 raw-encapsulation
     exit
    int ser2
     enc ppp
     ppp ip4cp close
     ppp ip6cp close
     vrf for v1
     ipv6 addr 1234::1 ffff::
     router isis6 1 ena
     router isis6 1 raw-encapsulation
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
    int ser1
     enc ppp
     ppp ip4cp close
     ppp ip6cp close
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     router isis4 1 ena
     router isis4 1 raw-encapsulation
     exit
    int ser2
     enc ppp
     ppp ip4cp close
     ppp ip6cp close
     vrf for v1
     ipv6 addr 1234::2 ffff::
     router isis6 1 ena
     router isis6 1 raw-encapsulation
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
        2. Fetch [rout-isis005](../clab/rout-isis005/rout-isis005.yml) file  
        3. Launch ContainerLab `rout-isis005.yml` topology:  

        ```
           containerlab deploy --topo rout-isis005.yml  
        ```
        4. Destroy ContainerLab `rout-isis005.yml` topology:  

        ```
           containerlab destroy --topo rout-isis005.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-isis005.tst` file [here](../tst/rout-isis005.tst)  
        3. Launch `rout-isis005.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-isis005 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-isis005.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

