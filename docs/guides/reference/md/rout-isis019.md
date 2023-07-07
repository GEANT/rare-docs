# Example: isis intra level metric

=== "Topology"

    ![Alt text](../d2/rout-isis019/rout-isis019.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router isis4 1
     vrf v1
     net 11.4444.0000.1111.00
     red conn
     exit
    router isis6 1
     vrf v1
     net 11.6666.0000.1111.00
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.111 255.255.255.255
     ipv6 addr 4321::111 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     router isis4 1 ena
     exit
    int eth1.12
     vrf for v1
     ipv6 addr 1234:1::1 ffff:ffff::
     router isis6 1 ena
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
     net 22.4444.0000.2222.00
     red conn
     exit
    router isis6 1
     vrf v1
     net 22.6666.0000.2222.00
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     router isis4 1 ena
     router isis4 1 metric 100
     exit
    int eth1.12
     vrf for v1
     ipv6 addr 1234:1::2 ffff:ffff::
     router isis6 1 ena
     router isis6 1 metric 100
     exit
    int eth2.11
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     router isis4 1 ena
     exit
    int eth2.12
     vrf for v1
     ipv6 addr 1234:2::1 ffff:ffff::
     router isis6 1 ena
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    router isis4 1
     vrf v1
     net 22.4444.0000.3333.00
     exit
    router isis6 1
     vrf v1
     net 22.6666.0000.3333.00
     exit
    int lo11
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     router isis4 1 ena
     router isis4 1 passive
     exit
    int lo12
     vrf for v1
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis6 1 ena
     router isis6 1 passive
     exit
    int lo21
     vrf for v1
     ipv4 addr 2.2.2.111 255.255.255.255
     router isis4 1 ena
     router isis4 1 passive
     exit
    int lo22
     vrf for v1
     ipv6 addr 4321::111 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router isis6 1 ena
     router isis6 1 passive
     exit
    int lo3
     vrf for v1
     ipv4 addr 2.2.2.222 255.255.255.255
     ipv6 addr 4321::222 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     router isis4 1 ena
     exit
    int eth1.12
     vrf for v1
     ipv6 addr 1234:2::2 ffff:ffff::
     router isis6 1 ena
     exit
    server telnet tel
     vrf v1
     port 666
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1
    r1 tping 100 20 4321::2 vrf v1
    r1 tping 100 20 2.2.2.3 vrf v1
    r1 tping 100 20 4321::3 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r2 tping 100 20 4321::1 vrf v1
    r2 tping 100 20 2.2.2.3 vrf v1
    r2 tping 100 20 4321::3 vrf v1
    r3 tping 100 20 2.2.2.1 vrf v1
    r3 tping 100 20 4321::1 vrf v1
    r3 tping 100 20 2.2.2.2 vrf v1
    r3 tping 100 20 4321::2 vrf v1
    r2 tping 100 40 2.2.2.111 vrf v1
    r2 tping 100 40 4321::111 vrf v1
    r2 tping 0 40 2.2.2.222 vrf v1
    r2 tping 0 40 4321::222 vrf v1
    r2 send telnet 2.2.2.111 666 vrf v1
    r2 tping 100 40 2.2.2.222 vrf v1
    r2 send exit
    r2 read closed
    r2 tping 0 40 2.2.2.222 vrf v1
    r2 send telnet 4321::111 666 vrf v1
    r2 tping 100 40 2.2.2.222 vrf v1
    r2 send exit
    r2 read closed
    r2 tping 0 40 2.2.2.222 vrf v1
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
        2. Fetch [rout-isis019](../clab/rout-isis019/rout-isis019.yml) file  
        3. Launch ContainerLab `rout-isis019.yml` topology:  

        ```
           containerlab deploy --topo rout-isis019.yml  
        ```
        4. Destroy ContainerLab `rout-isis019.yml` topology:  

        ```
           containerlab destroy --topo rout-isis019.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-isis019.tst` file [here](../tst/rout-isis019.tst)  
        3. Launch `rout-isis019.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-isis019 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-isis019.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

