# Example: qos ingress exp set

=== "Topology"

    ![Alt text](../d2/qos-set09/qos-set09.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    policy-map p1
     seq 10 act drop
      match exp 4
     seq 20 act trans
     exit
    int lo0
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.255
     ipv6 addr 3333::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     service-policy-in p1
     exit
    ipv4 route v1 3.3.3.2 255.255.255.255 1.1.1.2
    ipv6 route v1 3333::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    policy-map p1
     seq 10 act trans
      match length 300-500
      set exp 4
     seq 20 act trans
      set exp 5
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     service-policy-in p1
     exit
    int eth2
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     service-policy-in p1
     exit
    ipv4 route v1 3.3.3.1 255.255.255.255 1.1.1.1
    ipv6 route v1 3333::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::1
    ipv4 route v1 3.3.3.2 255.255.255.255 2.2.2.2
    ipv6 route v1 3333::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 4321::2
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    policy-map p1
     seq 10 act drop
      match exp 4
     seq 20 act trans
     exit
    int lo0
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.255
     ipv6 addr 3333::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     service-policy-in p1
     exit
    ipv4 route v1 3.3.3.1 255.255.255.255 2.2.2.1
    ipv6 route v1 3333::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 4321::1
    ```

=== "Verification"

    ```
    r1 tping 100 5 3.3.3.2 vrf v1 sou lo0 siz 200
    r3 tping 100 5 3.3.3.1 vrf v1 sou lo0 siz 200
    r1 tping 100 5 3333::2 vrf v1 sou lo0 siz 200
    r3 tping 100 5 3333::1 vrf v1 sou lo0 siz 200
    r1 tping 0 15 3.3.3.2 vrf v1 sou lo0 siz 400
    r3 tping 0 15 3.3.3.1 vrf v1 sou lo0 siz 400
    r1 tping 0 15 3333::2 vrf v1 sou lo0 siz 400
    r3 tping 0 15 3333::1 vrf v1 sou lo0 siz 400
    r1 tping 100 5 3.3.3.2 vrf v1 sou lo0 siz 600
    r3 tping 100 5 3.3.3.1 vrf v1 sou lo0 siz 600
    r1 tping 100 5 3333::2 vrf v1 sou lo0 siz 600
    r3 tping 100 5 3333::1 vrf v1 sou lo0 siz 600
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [qos-set09](../clab/qos-set09/qos-set09.yml) file  
        3. Launch ContainerLab `qos-set09.yml` topology:  

        ```
           containerlab deploy --topo qos-set09.yml  
        ```
        4. Destroy ContainerLab `qos-set09.yml` topology:  

        ```
           containerlab destroy --topo qos-set09.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `qos-set09.tst` file [here](../tst/qos-set09.tst)  
        3. Launch `qos-set09.tst` test:  

        ```
           java -jar ../../rtr.jar test tester qos-set09 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `qos-set09.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

