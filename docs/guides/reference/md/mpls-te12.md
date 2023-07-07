# Example: ldp and te

=== "Topology"

    ![Alt text](../d2/mpls-te12/mpls-te12.svg)

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
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     mpls rsvp4
     mpls rsvp6
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
    int tun1
     tun sou lo0
     tun dest 2.2.2.2
     tun vrf v1
     tun key 1234
     tun mod pweompls
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.252
     ipv6 addr 3333::1 ffff::
     exit
    int tun2
     tun sou lo0
     tun dest 4321::2
     tun vrf v1
     tun key 4321
     tun mod pweompls
     vrf for v1
     ipv4 addr 4.4.4.1 255.255.255.252
     ipv6 addr 4444::1 ffff::
     exit
    int tun3
     tun sou lo0
     tun dest 2.2.2.2
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 5.5.5.1 255.255.255.252
     exit
    int tun4
     tun sou lo0
     tun dest 4321::2
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv6 addr 5555::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     mpls rsvp4
     mpls rsvp6
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 2345::1 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     mpls rsvp4
     mpls rsvp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::1
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2345::2
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
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     mpls rsvp4
     mpls rsvp6
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 2345::2 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     mpls rsvp4
     mpls rsvp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.2.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 2345::1
    int tun1
     tun sou lo0
     tun dest 2.2.2.1
     tun vrf v1
     tun key 1234
     tun mod pweompls
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.252
     ipv6 addr 3333::2 ffff::
     exit
    int tun2
     tun sou lo0
     tun dest 4321::1
     tun vrf v1
     tun key 4321
     tun mod pweompls
     vrf for v1
     ipv4 addr 4.4.4.2 255.255.255.252
     ipv6 addr 4444::2 ffff::
     exit
    int tun3
     tun sou lo0
     tun dest 2.2.2.1
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv4 addr 5.5.5.2 255.255.255.252
     exit
    int tun4
     tun sou lo0
     tun dest 4321::1
     tun vrf v1
     tun mod p2pte
     vrf for v1
     ipv6 addr 5555::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234::2 vrf v1
    r3 tping 100 10 1.1.2.1 vrf v1
    r3 tping 100 10 2345::1 vrf v1
    r2 tping 100 10 1.1.1.1 vrf v1
    r2 tping 100 10 1234::1 vrf v1
    r2 tping 100 10 1.1.2.2 vrf v1
    r2 tping 100 10 2345::2 vrf v1
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r3 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r1 tping 100 10 4321::2 vrf v1 sou lo0
    r3 tping 100 10 4321::1 vrf v1 sou lo0
    r1 tping 100 10 3.3.3.2 vrf v1
    r3 tping 100 10 3.3.3.1 vrf v1
    r1 tping 100 10 3333::2 vrf v1
    r3 tping 100 10 3333::1 vrf v1
    r1 tping 100 10 4.4.4.2 vrf v1
    r3 tping 100 10 4.4.4.1 vrf v1
    r1 tping 100 10 4444::2 vrf v1
    r3 tping 100 10 4444::1 vrf v1
    r1 tping 100 10 5.5.5.2 vrf v1
    r3 tping 100 10 5.5.5.1 vrf v1
    r1 tping 100 10 5555::2 vrf v1
    r3 tping 100 10 5555::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-te12](../clab/mpls-te12/mpls-te12.yml) file  
        3. Launch ContainerLab `mpls-te12.yml` topology:  

        ```
           containerlab deploy --topo mpls-te12.yml  
        ```
        4. Destroy ContainerLab `mpls-te12.yml` topology:  

        ```
           containerlab destroy --topo mpls-te12.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-te12.tst` file [here](../tst/mpls-te12.tst)  
        3. Launch `mpls-te12.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-te12 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-te12.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

