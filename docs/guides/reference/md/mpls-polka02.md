# Example: polka over ethernet vlan

=== "Topology"

    ![Alt text](../d2/mpls-polka02/mpls-polka02.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.1
     segrout 10 1
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.1
     segrout 10 1
     red conn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff:ffff::
     mpls enable
     polka enable 1 65536 10
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    interface tun1
     tunnel vrf v1
     tunnel source loopback0
     tunnel destination 2.2.2.3
     tunnel domain-name 2.2.2.2
     tunnel mode polka
     vrf forwarding v1
     ipv4 address 3.3.3.1 255.255.255.252
     exit
    interface tun2
     tunnel vrf v1
     tunnel source loopback0
     tunnel destination 4321::3
     tunnel domain-name 4321::2
     tunnel mode polka
     vrf forwarding v1
     ipv6 address 3333::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.2
     segrout 10 2
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.2
     segrout 10 2
     red conn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.11
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234:1::2 ffff:ffff::
     mpls enable
     polka enable 2 65536 10
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int eth2.22
     vrf for v1
     ipv4 addr 1.1.2.5 255.255.255.0
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls enable
     polka enable 2 65536 10
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.3
     segrout 10 3
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.3
     segrout 10 3
     red conn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1.22
     vrf for v1
     ipv4 addr 1.1.2.6 255.255.255.0
     ipv6 addr 1234:2::3 ffff:ffff::
     mpls enable
     polka enable 3 65536 10
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    interface tun1
     tunnel vrf v1
     tunnel source loopback0
     tunnel destination 2.2.2.1
     tunnel domain-name 2.2.2.2
     tunnel mode polka
     vrf forwarding v1
     ipv4 address 3.3.3.2 255.255.255.252
     exit
    interface tun2
     tunnel vrf v1
     tunnel source loopback0
     tunnel destination 4321::1
     tunnel domain-name 4321::2
     tunnel mode polka
     vrf forwarding v1
     ipv6 address 3333::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 20 4321::2 vrf v1 sou lo0
    r1 tping 100 20 2.2.2.3 vrf v1 sou lo0
    r1 tping 100 20 4321::3 vrf v1 sou lo0
    r2 tping 100 20 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 20 4321::1 vrf v1 sou lo0
    r2 tping 100 20 2.2.2.3 vrf v1 sou lo0
    r2 tping 100 20 4321::3 vrf v1 sou lo0
    r3 tping 100 20 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 20 4321::2 vrf v1 sou lo0
    r3 tping 100 20 2.2.2.3 vrf v1 sou lo0
    r3 tping 100 20 4321::3 vrf v1 sou lo0
    r1 tping 100 20 3.3.3.2 vrf v1 sou tun1
    r3 tping 100 20 3.3.3.1 vrf v1 sou tun1
    r1 tping 100 20 3333::2 vrf v1 sou tun2
    r3 tping 100 20 3333::1 vrf v1 sou tun2
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-polka02](../clab/mpls-polka02/mpls-polka02.yml) file  
        3. Launch ContainerLab `mpls-polka02.yml` topology:  

        ```
           containerlab deploy --topo mpls-polka02.yml  
        ```
        4. Destroy ContainerLab `mpls-polka02.yml` topology:  

        ```
           containerlab destroy --topo mpls-polka02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-polka02.tst` file [here](../tst/mpls-polka02.tst)  
        3. Launch `mpls-polka02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-polka02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-polka02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

