# Example: mpolka over bridge

=== "Topology"

    ![Alt text](../d2/mpls-polka21/mpls-polka21.svg)

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
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff:ffff::
     mpls enable
     mpolka enable 1 65536 10
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    interface tun1
     tunnel vrf v1
     tunnel source loopback0
     tunnel destination 2.2.2.3
     tunnel domain-name 2.2.2.3 2.2.2.3 , 2.2.2.4 2.2.2.4
     tunnel mode mpolka
     vrf forwarding v1
     ipv4 address 3.3.3.1 255.255.255.252
     exit
    interface tun2
     tunnel vrf v1
     tunnel source loopback0
     tunnel destination 4321::3
     tunnel domain-name 4321::3 4321::3 , 4321::4 4321::4
     tunnel mode mpolka
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
    bridge 1
     mac-learn
     exit
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int eth3
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234:1::2 ffff:ffff::
     mpls enable
     mpolka enable 2 65536 10
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
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.0
     ipv6 addr 1234:1::3 ffff:ffff::
     mpls enable
     mpolka enable 3 65536 10
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    interface tun1
     tunnel vrf v1
     tunnel source loopback0
     tunnel destination 2.2.2.1
     tunnel domain-name 2.2.2.1 2.2.2.1
     tunnel mode mpolka
     vrf forwarding v1
     ipv4 address 3.3.3.2 255.255.255.252
     exit
    interface tun2
     tunnel vrf v1
     tunnel source loopback0
     tunnel destination 4321::1
     tunnel domain-name 4321::1 4321::1
     tunnel mode mpolka
     vrf forwarding v1
     ipv6 address 3333::2 ffff::
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.4
     segrout 10 4
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.4
     segrout 10 4
     red conn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.10 255.255.255.0
     ipv6 addr 1234:1::4 ffff:ffff::
     mpls enable
     mpolka enable 4 65536 10
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    interface tun1
     tunnel vrf v1
     tunnel source loopback0
     tunnel destination 2.2.2.1
     tunnel domain-name 2.2.2.1 2.2.2.1
     tunnel mode mpolka
     vrf forwarding v1
     ipv4 address 3.3.3.2 255.255.255.252
     exit
    interface tun2
     tunnel vrf v1
     tunnel source loopback0
     tunnel destination 4321::1
     tunnel domain-name 4321::1 4321::1
     tunnel mode mpolka
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
    r1 tping 100 20 2.2.2.4 vrf v1 sou lo0
    r1 tping 100 20 4321::4 vrf v1 sou lo0
    r2 tping 100 20 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 20 4321::1 vrf v1 sou lo0
    r2 tping 100 20 2.2.2.3 vrf v1 sou lo0
    r2 tping 100 20 4321::3 vrf v1 sou lo0
    r2 tping 100 20 2.2.2.4 vrf v1 sou lo0
    r2 tping 100 20 4321::4 vrf v1 sou lo0
    r3 tping 100 20 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 20 4321::2 vrf v1 sou lo0
    r3 tping 100 20 2.2.2.3 vrf v1 sou lo0
    r3 tping 100 20 4321::3 vrf v1 sou lo0
    r3 tping 100 20 2.2.2.4 vrf v1 sou lo0
    r3 tping 100 20 4321::4 vrf v1 sou lo0
    r4 tping 100 20 2.2.2.1 vrf v1 sou lo0
    r4 tping 100 20 4321::1 vrf v1 sou lo0
    r4 tping 100 20 2.2.2.2 vrf v1 sou lo0
    r4 tping 100 20 4321::2 vrf v1 sou lo0
    r4 tping 100 20 2.2.2.3 vrf v1 sou lo0
    r4 tping 100 20 4321::3 vrf v1 sou lo0
    r1 tping 200 20 3.3.3.2 vrf v1 sou tun1 multi
    r3 tping 100 20 3.3.3.1 vrf v1 sou tun1 multi
    r4 tping 100 20 3.3.3.1 vrf v1 sou tun1 multi
    r1 tping 200 20 3333::2 vrf v1 sou tun2 multi
    r3 tping 100 20 3333::1 vrf v1 sou tun2 multi
    r4 tping 100 20 3333::1 vrf v1 sou tun2 multi
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-polka21](../clab/mpls-polka21/mpls-polka21.yml) file  
        3. Launch ContainerLab `mpls-polka21.yml` topology:  

        ```
           containerlab deploy --topo mpls-polka21.yml  
        ```
        4. Destroy ContainerLab `mpls-polka21.yml` topology:  

        ```
           containerlab destroy --topo mpls-polka21.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-polka21.tst` file [here](../tst/mpls-polka21.tst)  
        3. Launch `mpls-polka21.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-polka21 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-polka21.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

