# Example: te explicit path

=== "Topology"

    ![Alt text](../d2/mpls-te19/mpls-te19.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router pvrp4 1
     vrf v1
     router 4.4.4.1
     red conn
     exit
    router pvrp6 1
     vrf v1
     router 6.6.6.1
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     mpls rsvp4
     mpls rsvp6
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     mpls enable
     mpls rsvp4
     mpls rsvp6
     router pvrp4 1 ena
     router pvrp6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.4.5 255.255.255.0
     ipv6 addr 1237::5 ffff::
     mpls enable
     mpls rsvp4
     mpls rsvp6
     router pvrp4 1 ena
     router pvrp6 1 ena
     exit
    interface tun1
     tunnel vrf v1
     tunnel source loopback1
     tunnel destination 2.2.2.3
     tunnel domain-name 2.2.2.2
     tunnel mode p2pte
     vrf forwarding v1
     ipv4 address 3.3.3.1 255.255.255.252
     exit
    interface tun2
     tunnel vrf v1
     tunnel source loopback1
     tunnel destination 4321::3
     tunnel domain-name 4321::2
     tunnel mode p2pte
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
    router pvrp4 1
     vrf v1
     router 4.4.4.2
     red conn
     exit
    router pvrp6 1
     vrf v1
     router 6.6.6.2
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     mpls rsvp4
     mpls rsvp6
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     mpls enable
     mpls rsvp4
     mpls rsvp6
     router pvrp4 1 ena
     router pvrp4 1 metric-out 100
     router pvrp6 1 ena
     router pvrp6 1 metric-out 100
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1235::2 ffff::
     mpls enable
     mpls rsvp4
     mpls rsvp6
     router pvrp4 1 ena
     router pvrp4 1 metric-out 100
     router pvrp6 1 ena
     router pvrp6 1 metric-out 100
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    router pvrp4 1
     vrf v1
     router 4.4.4.3
     red conn
     exit
    router pvrp6 1
     vrf v1
     router 6.6.6.3
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     mpls rsvp4
     mpls rsvp6
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.3 255.255.255.0
     ipv6 addr 1235::3 ffff::
     mpls enable
     mpls rsvp4
     mpls rsvp6
     router pvrp4 1 ena
     router pvrp6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.3.3 255.255.255.0
     ipv6 addr 1236::3 ffff::
     mpls enable
     mpls rsvp4
     mpls rsvp6
     router pvrp4 1 ena
     router pvrp6 1 ena
     exit
    interface tun1
     tunnel vrf v1
     tunnel source loopback1
     tunnel destination 2.2.2.1
     tunnel domain-name 2.2.2.2
     tunnel mode p2pte
     vrf forwarding v1
     ipv4 address 3.3.3.2 255.255.255.252
     exit
    interface tun2
     tunnel vrf v1
     tunnel source loopback1
     tunnel destination 4321::1
     tunnel domain-name 4321::2
     tunnel mode p2pte
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
    router pvrp4 1
     vrf v1
     router 4.4.4.4
     red conn
     exit
    router pvrp6 1
     vrf v1
     router 6.6.6.4
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     mpls rsvp4
     mpls rsvp6
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.3.4 255.255.255.0
     ipv6 addr 1236::4 ffff::
     no mpls enable
     no mpls rsvp4
     no mpls rsvp6
     router pvrp4 1 ena
     router pvrp6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.4.4 255.255.255.0
     ipv6 addr 1237::4 ffff::
     no mpls enable
     no mpls rsvp4
     no mpls rsvp6
     router pvrp4 1 ena
     router pvrp6 1 ena
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r1 tping 100 20 2.2.2.3 vrf v1 sou lo1
    r1 tping 100 20 2.2.2.4 vrf v1 sou lo1
    r1 tping 100 20 4321::2 vrf v1 sou lo1
    r1 tping 100 20 4321::3 vrf v1 sou lo1
    r1 tping 100 20 4321::4 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.3 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.4 vrf v1 sou lo1
    r2 tping 100 20 4321::1 vrf v1 sou lo1
    r2 tping 100 20 4321::3 vrf v1 sou lo1
    r2 tping 100 20 4321::4 vrf v1 sou lo1
    r3 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r3 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r3 tping 100 20 2.2.2.4 vrf v1 sou lo1
    r3 tping 100 20 4321::1 vrf v1 sou lo1
    r3 tping 100 20 4321::2 vrf v1 sou lo1
    r3 tping 100 20 4321::4 vrf v1 sou lo1
    r1 tping 100 20 3.3.3.2 vrf v1 sou tun1
    r3 tping 100 20 3.3.3.1 vrf v1 sou tun1
    r1 tping 100 20 3333::2 vrf v1 sou tun2
    r3 tping 100 20 3333::1 vrf v1 sou tun2
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-te19](../clab/mpls-te19/mpls-te19.yml) file  
        3. Launch ContainerLab `mpls-te19.yml` topology:  

        ```
           containerlab deploy --topo mpls-te19.yml  
        ```
        4. Destroy ContainerLab `mpls-te19.yml` topology:  

        ```
           containerlab destroy --topo mpls-te19.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-te19.tst` file [here](../tst/mpls-te19.tst)  
        3. Launch `mpls-te19.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-te19 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-te19.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

