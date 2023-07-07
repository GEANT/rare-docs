# Example: sr te with pcep

=== "Topology"

    ![Alt text](../d2/mpls-sr13/mpls-sr13.svg)

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
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     mpls enable
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    interface tun1
     tunnel vrf v1
     tunnel source loopback1
     tunnel destination 2.2.2.3
     tunnel domain-name 1.1.1.2 v1 eth1
     tunnel mode pcesr
     vrf forwarding v1
     ipv4 address 3.3.3.1 255.255.255.252
     exit
    interface tun2
     tunnel vrf v1
     tunnel source loopback1
     tunnel destination 4321::3
     tunnel domain-name 1.1.1.2 v1 eth1
     tunnel mode pcesr
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
    serv pcep p
     export-vrf v1
     vrf v1
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
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     mpls enable
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1235::2 ffff::
     mpls enable
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
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.3 255.255.255.0
     ipv6 addr 1235::3 ffff::
     mpls enable
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    interface tun1
     tunnel vrf v1
     tunnel source loopback1
     tunnel destination 2.2.2.1
     tunnel domain-name 1.1.1.2 v1 eth1
     tunnel mode pcesr
     vrf forwarding v1
     ipv4 address 3.3.3.2 255.255.255.252
     exit
    interface tun2
     tunnel vrf v1
     tunnel source loopback1
     tunnel destination 4321::1
     tunnel domain-name 1.1.1.2 v1 eth1
     tunnel mode pcesr
     vrf forwarding v1
     ipv6 address 3333::2 ffff::
     exit
    ```

=== "Verification"

    ```
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
    r1 tping 100 20 3.3.3.2 vrf v1 sou tun1
    r3 tping 100 20 3.3.3.1 vrf v1 sou tun1
    r1 tping 100 20 3333::2 vrf v1 sou tun2
    r3 tping 100 20 3333::1 vrf v1 sou tun2
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-sr13](../clab/mpls-sr13/mpls-sr13.yml) file  
        3. Launch ContainerLab `mpls-sr13.yml` topology:  

        ```
           containerlab deploy --topo mpls-sr13.yml  
        ```
        4. Destroy ContainerLab `mpls-sr13.yml` topology:  

        ```
           containerlab destroy --topo mpls-sr13.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-sr13.tst` file [here](../tst/mpls-sr13.tst)  
        3. Launch `mpls-sr13.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-sr13 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-sr13.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

