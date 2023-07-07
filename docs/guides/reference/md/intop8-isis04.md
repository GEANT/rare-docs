# Example: interop8: isis narrow metric

=== "Topology"

    ![Alt text](../d2/intop8-isis04/intop8-isis04.svg)

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
     no metric-wide
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.1111.00
     no metric-wide
     red conn
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     router isis4 1 ena
     exit
    int eth2
     vrf for v1
     ipv6 addr fe80::1 ffff::
     router isis6 1 ena
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    ```

    **r2**

    ```
    hostname r2
    ip forwarding
    ipv6 forwarding
    interface lo
     ip addr 2.2.2.2/32
     ipv6 addr 4321::2/128
     exit
    router isis 1
     net 48.0000.0000.1234.00
     metric-style narrow
     redistribute ipv4 connected level-2
     redistribute ipv6 connected level-2
     exit
    interface ens3
     ip address 1.1.1.2/24
     ip router isis 1
     isis network point-to-point
     no shutdown
     exit
    interface ens4
     ipv6 router isis 1
     isis network point-to-point
     no shutdown
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop8-isis04](../clab/intop8-isis04/intop8-isis04.yml) file  
        3. Launch ContainerLab `intop8-isis04.yml` topology:  

        ```
           containerlab deploy --topo intop8-isis04.yml  
        ```
        4. Destroy ContainerLab `intop8-isis04.yml` topology:  

        ```
           containerlab destroy --topo intop8-isis04.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop8-isis04.tst` file [here](../tst/intop8-isis04.tst)  
        3. Launch `intop8-isis04.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop8-isis04 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop8-isis04.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

