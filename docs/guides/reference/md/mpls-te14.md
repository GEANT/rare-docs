# Example: p2mp te tail+mid

=== "Topology"

    ![Alt text](../d2/mpls-te14/mpls-te14.svg)

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
     mpls rsvp4
     mpls rsvp6
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.11.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff:ffff::
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.11.2
    ipv6 route v1 :: :: 1234:1::2
    interface tunnel1
     tunnel source loopback0
     tunnel destination 9.9.9.9
     tunnel domain-name 2.2.2.2 2.2.2.3 2.2.2.4
     tunnel vrf v1
     tunnel mode p2mpte
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     exit
    interface tunnel2
     tunnel source loopback0
     tunnel destination 9999::9
     tunnel domain-name 4321::2 4321::3 4321::4
     tunnel vrf v1
     tunnel mode p2mpte
     vrf for v1
     ipv6 addr 3333::1 ffff:ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     mpls rsvp4
     mpls rsvp6
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.12.1 255.255.255.0
     ipv6 addr 1234:2::1 ffff:ffff::
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.12.2
    ipv6 route v1 :: :: 1234:2::2
    int lo1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.255
     ipv6 addr 3333::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     mpls rsvp4
     mpls rsvp6
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.13.1 255.255.255.0
     ipv6 addr 1234:3::1 ffff:ffff::
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.13.2
    ipv6 route v1 :: :: 1234:3::2
    int lo1
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.255
     ipv6 addr 3333::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
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
     mpls rsvp4
     mpls rsvp6
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.11.2 255.255.255.0
     ipv6 addr 1234:1::2 ffff:ffff::
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.11.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::1
    int eth2
     vrf for v1
     ipv4 addr 1.1.12.2 255.255.255.0
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.12.1
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:2::1
    int eth3
     vrf for v1
     ipv4 addr 1.1.13.2 255.255.255.0
     ipv6 addr 1234:3::2 ffff:ffff::
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.13.1
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:3::1
    int lo1
     vrf for v1
     ipv4 addr 3.3.3.4 255.255.255.255
     ipv6 addr 3333::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    ```

=== "Verification"

    ```
    r4 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r4 tping 100 10 4321::1 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r4 tping 100 10 4321::2 vrf v1 sou lo0
    r4 tping 100 10 2.2.2.3 vrf v1 sou lo0
    r4 tping 100 10 4321::3 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.4 vrf v1 sou lo0
    r1 tping 100 10 4321::4 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 10 4321::2 vrf v1 sou lo0
    r1 tping 100 10 2.2.2.3 vrf v1 sou lo0
    r1 tping 100 10 4321::3 vrf v1 sou lo0
    r2 tping 100 10 2.2.2.4 vrf v1 sou lo0
    r2 tping 100 10 4321::4 vrf v1 sou lo0
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 10 4321::1 vrf v1 sou lo0
    r2 tping 100 10 2.2.2.3 vrf v1 sou lo0
    r2 tping 100 10 4321::3 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.4 vrf v1 sou lo0
    r3 tping 100 10 4321::4 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r3 tping 100 10 4321::1 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 10 4321::2 vrf v1 sou lo0
    r1 tping 100 10 3.3.3.1 vrf v1 sou lo0 multi
    r1 tping 100 10 3.3.3.2 vrf v1 sou lo0 multi
    r1 tping 100 10 3.3.3.3 vrf v1 sou lo0 multi
    r1 tping 300 10 3.3.3.4 vrf v1 sou lo0 multi
    r1 tping 100 10 3333::1 vrf v1 sou lo0 multi
    r1 tping 100 10 3333::2 vrf v1 sou lo0 multi
    r1 tping 100 10 3333::3 vrf v1 sou lo0 multi
    r1 tping 300 10 3333::4 vrf v1 sou lo0 multi
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-te14](../clab/mpls-te14/mpls-te14.yml) file  
        3. Launch ContainerLab `mpls-te14.yml` topology:  

        ```
           containerlab deploy --topo mpls-te14.yml  
        ```
        4. Destroy ContainerLab `mpls-te14.yml` topology:  

        ```
           containerlab destroy --topo mpls-te14.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-te14.tst` file [here](../tst/mpls-te14.tst)  
        3. Launch `mpls-te14.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-te14 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-te14.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

