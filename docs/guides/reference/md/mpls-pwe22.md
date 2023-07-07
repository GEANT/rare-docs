# Example: tunnel interface with mpls

=== "Topology"

    ![Alt text](../d2/mpls-pwe22/mpls-pwe22.svg)

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
    int tun1
     tun vrf v1
     tun sou lo0
     tun dest 2.2.2.2
     tun key 1234
     tun mod pweompls
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     ipv6 addr 3333::1 ffff::
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
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff:ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::1
    int tun1
     tun vrf v1
     tun sou lo0
     tun dest 2.2.2.1
     tun key 1234
     tun mod pweompls
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     ipv6 addr 3333::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 30 2.2.2.2 vrf v1 sou lo0
    r2 tping 100 30 2.2.2.1 vrf v1 sou lo0
    r1 tping 100 30 3.3.3.2 vrf v1
    r1 tping 100 30 3333::2 vrf v1
    r2 tping 100 30 3.3.3.1 vrf v1
    r2 tping 100 30 3333::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-pwe22](../clab/mpls-pwe22/mpls-pwe22.yml) file  
        3. Launch ContainerLab `mpls-pwe22.yml` topology:  

        ```
           containerlab deploy --topo mpls-pwe22.yml  
        ```
        4. Destroy ContainerLab `mpls-pwe22.yml` topology:  

        ```
           containerlab destroy --topo mpls-pwe22.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-pwe22.tst` file [here](../tst/mpls-pwe22.tst)  
        3. Launch `mpls-pwe22.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-pwe22 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-pwe22.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

