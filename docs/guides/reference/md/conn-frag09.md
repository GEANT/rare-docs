# Example: mpls ttl exceed

=== "Topology"

    ![Alt text](../d2/conn-frag09/conn-frag09.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
    ipv4 route v1 2.2.2.4 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    int lo0
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
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1235::1 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::1
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1235::2
    ipv4 route v1 2.2.2.4 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1235::2
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny all 4321:: ffff:: all 4321:: ffff:: all
     permit all any all any all
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1235::2 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.3.1 255.255.255.0
     ipv6 addr 1236::1 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.2.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1235::1
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.2.1
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1235::1
    ipv4 route v1 2.2.2.4 255.255.255.255 1.1.3.2
    ipv6 route v1 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1236::2
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.3.2 255.255.255.0
     ipv6 addr 1236::2 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.3.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1236::1
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.3.1
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1236::1
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.3.1
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1236::1
    ```

=== "Verification"

    ```
    r2 tping 0 10 1.1.1.1 vrf v1
    r2 tping 0 10 1.1.2.2 vrf v1
    r3 tping 0 10 1.1.2.1 vrf v1
    r3 tping 0 10 1.1.3.2 vrf v1
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0 ttl 3
    r1 tping 100 10 4321::2 vrf v1 sou lo0 ttl 3
    r1 tping 100 10 2.2.2.3 vrf v1 sou lo0 ttl 3
    r1 tping 100 10 4321::3 vrf v1 sou lo0 ttl 3
    r1 tping 100 10 2.2.2.4 vrf v1 sou lo0 ttl 3
    r1 tping 100 10 4321::4 vrf v1 sou lo0 ttl 3
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0 ttl 3
    r2 tping 100 10 4321::1 vrf v1 sou lo0 ttl 3
    r2 tping 100 10 2.2.2.3 vrf v1 sou lo0 ttl 3
    r2 tping 100 10 4321::3 vrf v1 sou lo0 ttl 3
    r2 tping 100 10 2.2.2.4 vrf v1 sou lo0 ttl 3
    r2 tping 100 10 4321::4 vrf v1 sou lo0 ttl 3
    r3 tping 100 10 2.2.2.1 vrf v1 sou lo0 ttl 3
    r3 tping 100 10 4321::1 vrf v1 sou lo0 ttl 3
    r3 tping 100 10 2.2.2.2 vrf v1 sou lo0 ttl 3
    r3 tping 100 10 4321::2 vrf v1 sou lo0 ttl 3
    r3 tping 100 10 2.2.2.4 vrf v1 sou lo0 ttl 3
    r3 tping 100 10 4321::4 vrf v1 sou lo0 ttl 3
    r4 tping 100 10 2.2.2.1 vrf v1 sou lo0 ttl 3
    r4 tping 100 10 4321::1 vrf v1 sou lo0 ttl 3
    r4 tping 100 10 2.2.2.2 vrf v1 sou lo0 ttl 3
    r4 tping 100 10 4321::2 vrf v1 sou lo0 ttl 3
    r4 tping 100 10 2.2.2.3 vrf v1 sou lo0 ttl 3
    r4 tping 100 10 4321::3 vrf v1 sou lo0 ttl 3
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0 ttl 2 error
    r1 tping 100 10 4321::2 vrf v1 sou lo0 ttl 2 error
    r1 tping 100 10 2.2.2.3 vrf v1 sou lo0 ttl 2 error
    r1 tping 100 10 4321::3 vrf v1 sou lo0 ttl 2 error
    r1 tping -100 10 2.2.2.4 vrf v1 sou lo0 ttl 2 error
    r1 tping -100 10 4321::4 vrf v1 sou lo0 ttl 2 error
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0 ttl 2 error
    r2 tping 100 10 4321::1 vrf v1 sou lo0 ttl 2 error
    r2 tping 100 10 2.2.2.3 vrf v1 sou lo0 ttl 2 error
    r2 tping 100 10 4321::3 vrf v1 sou lo0 ttl 2 error
    r2 tping 100 10 2.2.2.4 vrf v1 sou lo0 ttl 2 error
    r2 tping 100 10 4321::4 vrf v1 sou lo0 ttl 2 error
    r3 tping 100 10 2.2.2.1 vrf v1 sou lo0 ttl 2 error
    r3 tping 100 10 4321::1 vrf v1 sou lo0 ttl 2 error
    r3 tping 100 10 2.2.2.2 vrf v1 sou lo0 ttl 2 error
    r3 tping 100 10 4321::2 vrf v1 sou lo0 ttl 2 error
    r3 tping 100 10 2.2.2.4 vrf v1 sou lo0 ttl 2 error
    r3 tping 100 10 4321::4 vrf v1 sou lo0 ttl 2 error
    r4 tping -100 10 2.2.2.1 vrf v1 sou lo0 ttl 2 error
    r4 tping -100 10 4321::1 vrf v1 sou lo0 ttl 2 error
    r4 tping 100 10 2.2.2.2 vrf v1 sou lo0 ttl 2 error
    r4 tping 100 10 4321::2 vrf v1 sou lo0 ttl 2 error
    r4 tping 100 10 2.2.2.3 vrf v1 sou lo0 ttl 2 error
    r4 tping 100 10 4321::3 vrf v1 sou lo0 ttl 2 error
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0 ttl 1 error
    r1 tping 100 10 4321::2 vrf v1 sou lo0 ttl 1 error
    r1 tping -100 10 2.2.2.3 vrf v1 sou lo0 ttl 1 error
    r1 tping -100 10 4321::3 vrf v1 sou lo0 ttl 1 error
    r1 tping -100 10 2.2.2.4 vrf v1 sou lo0 ttl 1 error
    r1 tping -100 10 4321::4 vrf v1 sou lo0 ttl 1 error
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0 ttl 1 error
    r2 tping 100 10 4321::1 vrf v1 sou lo0 ttl 1 error
    r2 tping 100 10 2.2.2.3 vrf v1 sou lo0 ttl 1 error
    r2 tping 100 10 4321::3 vrf v1 sou lo0 ttl 1 error
    r2 tping -100 10 2.2.2.4 vrf v1 sou lo0 ttl 1 error
    r2 tping -100 10 4321::4 vrf v1 sou lo0 ttl 1 error
    r3 tping -100 10 2.2.2.1 vrf v1 sou lo0 ttl 1 error
    r3 tping -100 10 4321::1 vrf v1 sou lo0 ttl 1 error
    r3 tping 100 10 2.2.2.2 vrf v1 sou lo0 ttl 1 error
    r3 tping 100 10 4321::2 vrf v1 sou lo0 ttl 1 error
    r3 tping 100 10 2.2.2.4 vrf v1 sou lo0 ttl 1 error
    r3 tping 100 10 4321::4 vrf v1 sou lo0 ttl 1 error
    r4 tping -100 10 2.2.2.1 vrf v1 sou lo0 ttl 1 error
    r4 tping -100 10 4321::1 vrf v1 sou lo0 ttl 1 error
    r4 tping -100 10 2.2.2.2 vrf v1 sou lo0 ttl 1 error
    r4 tping -100 10 4321::2 vrf v1 sou lo0 ttl 1 error
    r4 tping 100 10 2.2.2.3 vrf v1 sou lo0 ttl 1 error
    r4 tping 100 10 4321::3 vrf v1 sou lo0 ttl 1 error
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-frag09](../clab/conn-frag09/conn-frag09.yml) file  
        3. Launch ContainerLab `conn-frag09.yml` topology:  

        ```
           containerlab deploy --topo conn-frag09.yml  
        ```
        4. Destroy ContainerLab `conn-frag09.yml` topology:  

        ```
           containerlab destroy --topo conn-frag09.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-frag09.tst` file [here](../tst/conn-frag09.tst)  
        3. Launch `conn-frag09.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-frag09 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-frag09.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

