# Example: mpls over multicast ethertype

=== "Topology"

    ![Alt text](../d2/mpls-bier17/mpls-bier17.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
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
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     no ipv4 unreachables
     no ipv6 unreachables
     mpls enable
     mpls ethert multi
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
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
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     no ipv4 unreachables
     no ipv6 unreachables
     mpls enable
     mpls ethert multi
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::1
    ```

=== "Verification"

    ```
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 10 4321::2 vrf v1 sou lo0
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 10 4321::1 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-bier17](../clab/mpls-bier17/mpls-bier17.yml) file  
        3. Launch ContainerLab `mpls-bier17.yml` topology:  

        ```
           containerlab deploy --topo mpls-bier17.yml  
        ```
        4. Destroy ContainerLab `mpls-bier17.yml` topology:  

        ```
           containerlab destroy --topo mpls-bier17.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-bier17.tst` file [here](../tst/mpls-bier17.tst)  
        3. Launch `mpls-bier17.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-bier17 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-bier17.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

