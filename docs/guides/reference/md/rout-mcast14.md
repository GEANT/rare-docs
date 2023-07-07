# Example: multicast between pim and pim over bier

=== "Topology"

    ![Alt text](../d2/rout-mcast14/rout-mcast14.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.1
     bier 256 10 1
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.1
     bier 256 10 1
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router lsrp4 1 ena
     router lsrp6 1 ena
     ipv4 pim ena
     ipv6 pim ena
     ipv4 pim join lo1
     ipv6 pim join lo1
     ipv4 pim bier 1
     ipv6 pim bier 1
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.11 255.255.255.255
     ipv6 addr 4321::11 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     router lsrp4 1 ena
     router lsrp6 1 ena
     ipv4 pim ena
     ipv6 pim ena
     ipv4 pim join lo1
     ipv6 pim join lo1
     ipv4 pim bier 1
     ipv6 pim bier 1
     exit
    int eth2
     vrf for v1
     ipv4 addr 4.4.4.2 255.255.255.252
     ipv6 addr 4444::2 ffff:ffff::
     ipv4 pim ena
     ipv6 pim ena
     exit
    router bgp4 1
     vrf v1
     address uni multi
     local-as 1
     router-id 4.4.4.1
     neigh 2.2.2.4 remote-as 1
     neigh 2.2.2.4 update lo1
     red conn
     red stat
     exit
    router bgp6 1
     vrf v1
     address uni multi
     local-as 1
     router-id 6.6.6.1
     neigh 4321::4 remote-as 1
     neigh 4321::4 update lo1
     red conn
     red stat
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.2
     bier 256 10 2
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.2
     bier 256 10 2
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
     mpls ldp4
     mpls ldp6
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1235::2 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.3
     bier 256 10 3
     red conn
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.3
     bier 256 10 3
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
     mpls ldp4
     mpls ldp6
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.3.3 255.255.255.0
     ipv6 addr 1236::3 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     router lsrp4 1 ena
     router lsrp6 1 ena
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    router lsrp4 1
     vrf v1
     router 4.4.4.4
     bier 256 10 4
     exit
    router lsrp6 1
     vrf v1
     router 6.6.6.4
     bier 256 10 4
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     router lsrp4 1 ena
     router lsrp6 1 ena
     ipv4 pim ena
     ipv6 pim ena
     ipv4 pim join lo1
     ipv6 pim join lo1
     ipv4 pim bier 4
     ipv6 pim bier 4
     exit
    int lo2
     vrf for v1
     ipv4 addr 2.2.2.14 255.255.255.255
     ipv6 addr 4321::14 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.3.4 255.255.255.0
     ipv6 addr 1236::4 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     router lsrp4 1 ena
     router lsrp6 1 ena
     ipv4 pim ena
     ipv6 pim ena
     ipv4 pim join lo1
     ipv6 pim join lo1
     ipv4 pim bier 4
     ipv6 pim bier 4
     exit
    int eth2
     vrf for v1
     ipv4 addr 5.5.5.2 255.255.255.252
     ipv6 addr 5555::2 ffff:ffff::
     ipv4 pim ena
     ipv6 pim ena
     exit
    router bgp4 1
     vrf v1
     address uni multi
     local-as 1
     router-id 4.4.4.4
     neigh 2.2.2.1 remote-as 1
     neigh 2.2.2.1 update lo1
     red conn
     red stat
     exit
    router bgp6 1
     vrf v1
     address uni multi
     local-as 1
     router-id 6.6.6.4
     neigh 4321::1 remote-as 1
     neigh 4321::1 update lo1
     red conn
     red stat
     exit
    ```

    **r5**

    ```
    hostname r5
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 4.4.4.1 255.255.255.252
     ipv6 addr 4444::1 ffff:ffff::
     ipv4 pim ena
     ipv6 pim ena
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 4.4.4.2
    ipv6 route v1 :: :: 4444::2
    ```

    **r6**

    ```
    hostname r6
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 5.5.5.1 255.255.255.252
     ipv6 addr 5555::1 ffff:ffff::
     ipv4 pim ena
     ipv6 pim ena
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 5.5.5.2
    ipv6 route v1 :: :: 5555::2
    ipv4 mroute v1 0.0.0.0 0.0.0.0 5.5.5.2
    ipv6 mroute v1 :: :: 5555::2
    ipv4 multi v1 join 232.2.2.2 4.4.4.1
    ipv6 multi v1 join ff06::1 4444::1
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r1 tping 100 20 4321::2 vrf v1 sou lo1
    r1 tping 100 20 2.2.2.3 vrf v1 sou lo1
    r1 tping 100 20 4321::3 vrf v1 sou lo1
    r1 tping 100 20 2.2.2.4 vrf v1 sou lo1
    r1 tping 100 20 4321::4 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r2 tping 100 20 4321::1 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.3 vrf v1 sou lo1
    r2 tping 100 20 4321::3 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.4 vrf v1 sou lo1
    r2 tping 100 20 4321::4 vrf v1 sou lo1
    r3 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r3 tping 100 20 4321::1 vrf v1 sou lo1
    r3 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r3 tping 100 20 4321::2 vrf v1 sou lo1
    r3 tping 100 20 2.2.2.4 vrf v1 sou lo1
    r3 tping 100 20 4321::4 vrf v1 sou lo1
    r4 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r4 tping 100 20 4321::1 vrf v1 sou lo1
    r4 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r4 tping 100 20 4321::2 vrf v1 sou lo1
    r4 tping 100 20 2.2.2.3 vrf v1 sou lo1
    r4 tping 100 20 4321::3 vrf v1 sou lo1
    r1 tping 100 20 2.2.2.14 vrf v1 sou lo2
    r1 tping 100 20 4321::14 vrf v1 sou lo2
    r4 tping 100 20 2.2.2.11 vrf v1 sou lo2
    r4 tping 100 20 4321::11 vrf v1 sou lo2
    r5 tping 100 20 2.2.2.11 vrf v1 sou eth1
    r5 tping 100 20 4321::11 vrf v1 sou eth1
    r5 tping 100 20 2.2.2.14 vrf v1 sou eth1
    r5 tping 100 20 4321::14 vrf v1 sou eth1
    r6 tping 100 20 2.2.2.11 vrf v1 sou eth1
    r6 tping 100 20 4321::11 vrf v1 sou eth1
    r6 tping 100 20 2.2.2.14 vrf v1 sou eth1
    r6 tping 100 20 4321::14 vrf v1 sou eth1
    r5 tping 100 10 232.2.2.2 vrf v1 sou eth1
    r5 tping 100 10 ff06::1 vrf v1 sou eth1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-mcast14](../clab/rout-mcast14/rout-mcast14.yml) file  
        3. Launch ContainerLab `rout-mcast14.yml` topology:  

        ```
           containerlab deploy --topo rout-mcast14.yml  
        ```
        4. Destroy ContainerLab `rout-mcast14.yml` topology:  

        ```
           containerlab destroy --topo rout-mcast14.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-mcast14.tst` file [here](../tst/rout-mcast14.tst)  
        3. Launch `rout-mcast14.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-mcast14 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-mcast14.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

