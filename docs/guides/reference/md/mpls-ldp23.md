# Example: mpls expbundle

=== "Topology"

    ![Alt text](../d2/mpls-ldp23/mpls-ldp23.svg)

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
    int ser1
     enc hdlc
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234:1::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int ser2
     enc hdlc
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1234:2::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int ser3
     enc hdlc
     vrf for v1
     ipv4 addr 1.1.3.1 255.255.255.0
     ipv6 addr 1234:3::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int ser4
     enc hdlc
     vrf for v1
     ipv4 addr 1.1.4.1 255.255.255.0
     ipv6 addr 1234:4::1 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:1::2
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
     exit
    int ser1
     enc hdlc
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234:1::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int ser2
     enc hdlc
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1234:2::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int ser3
     enc hdlc
     vrf for v1
     ipv4 addr 1.1.3.2 255.255.255.0
     ipv6 addr 1234:3::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int ser4
     enc hdlc
     vrf for v1
     ipv4 addr 1.1.4.2 255.255.255.0
     ipv6 addr 1234:4::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    int tun1
     tunnel vrf v1
     tunnel source ser1
     tunnel destination 1.1.1.1
     tunnel domain-name 1:ser1 2:ser2 4:ser3 5:ser4
     tunnel mode expbun
     vrf forwarding v1
     ipv4 addr 1.1.5.2 255.255.255.0
     ipv6 addr 1234:5::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     no shutdown
     no log-link-change
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.5.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234:5::1
    ```

=== "Verification"

    ```
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0 tos 32
    r1 tping 100 10 4321::2 vrf v1 sou lo0 tos 32
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0 tos 32
    r2 tping 100 10 4321::1 vrf v1 sou lo0 tos 32
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0 tos 64
    r1 tping 100 10 4321::2 vrf v1 sou lo0 tos 64
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0 tos 64
    r2 tping 100 10 4321::1 vrf v1 sou lo0 tos 64
    r1 tping 0 10 2.2.2.2 vrf v1 sou lo0 tos 96
    r1 tping 0 10 4321::2 vrf v1 sou lo0 tos 96
    r2 tping 0 10 2.2.2.1 vrf v1 sou lo0 tos 96
    r2 tping 0 10 4321::1 vrf v1 sou lo0 tos 96
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0 tos 128
    r1 tping 100 10 4321::2 vrf v1 sou lo0 tos 128
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0 tos 128
    r2 tping 100 10 4321::1 vrf v1 sou lo0 tos 128
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0 tos 160
    r1 tping 100 10 4321::2 vrf v1 sou lo0 tos 160
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0 tos 160
    r2 tping 100 10 4321::1 vrf v1 sou lo0 tos 160
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-ldp23](../clab/mpls-ldp23/mpls-ldp23.yml) file  
        3. Launch ContainerLab `mpls-ldp23.yml` topology:  

        ```
           containerlab deploy --topo mpls-ldp23.yml  
        ```
        4. Destroy ContainerLab `mpls-ldp23.yml` topology:  

        ```
           containerlab destroy --topo mpls-ldp23.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-ldp23.tst` file [here](../tst/mpls-ldp23.tst)  
        3. Launch `mpls-ldp23.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-ldp23 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-ldp23.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

