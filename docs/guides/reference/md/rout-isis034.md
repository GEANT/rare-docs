# Example: isis broadcast subnet with narrow metric

=== "Topology"

    ![Alt text](../d2/rout-isis034/rout-isis034.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    bridge 1
     exit
    bridge 2
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.1111.00
     no metric-wide
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.1111.00
     no metric-wide
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     bridge-gr 1
     exit
    int eth1.12
     bridge-gr 2
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     router isis4 1 ena
     router isis4 1 net broad
     exit
    int bvi2
     vrf for v1
     ipv6 addr 1234::1 ffff::
     router isis6 1 ena
     router isis6 1 net broad
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    bridge 1
     mac-learn
     exit
    bridge 2
     mac-learn
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.2222.00
     no metric-wide
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.2222.00
     no metric-wide
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     bridge-gr 1
     exit
    int eth1.12
     bridge-gr 2
     exit
    int eth2.11
     bridge-gr 1
     exit
    int eth2.12
     bridge-gr 2
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     router isis4 1 ena
     router isis4 1 net broad
     exit
    int bvi2
     vrf for v1
     ipv6 addr 1234::2 ffff::
     router isis6 1 ena
     router isis6 1 net broad
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    bridge 1
     exit
    bridge 2
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.3333.00
     no metric-wide
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.3333.00
     no metric-wide
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     bridge-gr 1
     exit
    int eth1.12
     bridge-gr 2
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     router isis4 1 ena
     router isis4 1 net broad
     exit
    int bvi2
     vrf for v1
     ipv6 addr 1234::3 ffff::
     router isis6 1 ena
     router isis6 1 net broad
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r1 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r1 tping 100 20 2.2.2.3 vrf v1 sou lo1
    r1 tping 100 20 4321::2 vrf v1 sou lo1
    r1 tping 100 20 4321::3 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.3 vrf v1 sou lo1
    r2 tping 100 20 4321::1 vrf v1 sou lo1
    r2 tping 100 20 4321::3 vrf v1 sou lo1
    r3 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r3 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r3 tping 100 20 4321::1 vrf v1 sou lo1
    r3 tping 100 20 4321::2 vrf v1 sou lo1
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
        2. Fetch [rout-isis034](../clab/rout-isis034/rout-isis034.yml) file  
        3. Launch ContainerLab `rout-isis034.yml` topology:  

        ```
           containerlab deploy --topo rout-isis034.yml  
        ```
        4. Destroy ContainerLab `rout-isis034.yml` topology:  

        ```
           containerlab destroy --topo rout-isis034.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-isis034.tst` file [here](../tst/rout-isis034.tst)  
        3. Launch `rout-isis034.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-isis034 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-isis034.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

