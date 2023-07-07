# Example: rip with bfd

=== "Topology"

    ![Alt text](../d2/rout-rip20/rout-rip20.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router rip4 1
     vrf v1
     red conn
     exit
    router rip6 1
     vrf v1
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
     ipv4 bfd 100 100 3
     router rip4 1 ena
     router rip4 1 bfd
     ipv6 addr 1234:1::1 ffff:ffff::
     ipv6 bfd 100 100 3
     router rip6 1 ena
     router rip6 1 bfd
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv4 bfd 100 100 3
     router rip4 1 ena
     router rip4 1 bfd
     router rip4 1 dista 130
     ipv6 addr 1234:2::1 ffff:ffff::
     ipv6 bfd 100 100 3
     router rip6 1 ena
     router rip6 1 bfd
     router rip6 1 dista 130
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router rip4 1
     vrf v1
     red conn
     exit
    router rip6 1
     vrf v1
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
     ipv4 bfd 100 100 3
     router rip4 1 ena
     router rip4 1 bfd
     ipv6 addr 1234:1::2 ffff:ffff::
     ipv6 bfd 100 100 3
     router rip6 1 ena
     router rip6 1 bfd
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv4 bfd 100 100 3
     router rip4 1 ena
     router rip4 1 bfd
     router rip4 1 dista 130
     ipv6 addr 1234:2::2 ffff:ffff::
     ipv6 bfd 100 100 3
     router rip6 1 ena
     router rip6 1 bfd
     router rip6 1 dista 130
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 130 2.2.2.2 vrf v1
    r1 tping 100 130 4321::2 vrf v1
    r2 tping 100 130 2.2.2.1 vrf v1
    r2 tping 100 130 4321::1 vrf v1
    sleep 3000
    r1 tping 100 5 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 5 4321::2 vrf v1 sou lo0
    r2 tping 100 5 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 5 4321::1 vrf v1 sou lo0
    r2 send conf t
    r2 send int eth1
    r2 send shut
    r2 send end
    r1 tping 100 5 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 5 4321::2 vrf v1 sou lo0
    r2 tping 100 5 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 5 4321::1 vrf v1 sou lo0
    r2 output show ipv4 rip 1 sum
    r2 output show ipv6 rip 1 sum
    r2 output show ipv4 rip 1 dat
    r2 output show ipv6 rip 1 dat
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-rip20](../clab/rout-rip20/rout-rip20.yml) file  
        3. Launch ContainerLab `rout-rip20.yml` topology:  

        ```
           containerlab deploy --topo rout-rip20.yml  
        ```
        4. Destroy ContainerLab `rout-rip20.yml` topology:  

        ```
           containerlab destroy --topo rout-rip20.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-rip20.tst` file [here](../tst/rout-rip20.tst)  
        3. Launch `rout-rip20.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-rip20 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-rip20.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

