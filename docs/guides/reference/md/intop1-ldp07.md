# Example: interop1: ethernet over mpls cw

=== "Topology"

    ![Alt text](../d2/intop1-ldp07/intop1-ldp07.svg)

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
    proxy-profile p1
     vrf v1
     source lo0
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
    bridge 1
     mac-learn
     exit
    int bvi1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     ipv6 addr 3333::1 ffff::
     exit
    vpdn eompls
     bridge-gr 1
     proxy p1
     target 2.2.2.2
     mtu 1500
     vcid 1234
     pwtype eth
     control
     protocol pweompls
     exit
    ```

    **r2**

    ```
    hostname r2
    ip routing
    ipv6 unicast-routing
    mpls ldp explicit-null
    interface loopback0
     ip addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2/128
     exit
    interface gigabit1
     ip address 1.1.1.2 255.255.255.0
     ipv6 address 1234::2/64
     mpls ip
     no shutdown
     exit
    interface gigabit2
     xconnect 2.2.2.1 1234 encapsulation mpls
     no shutdown
     exit
    ip route 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route 4321::1/128 1234::1
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     ipv6 addr 3333::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 3.3.3.2 vrf v1
    r1 tping 100 60 3333::2 vrf v1
    r3 tping 100 60 3.3.3.1 vrf v1
    r3 tping 100 60 3333::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-ldp07](../clab/intop1-ldp07/intop1-ldp07.yml) file  
        3. Launch ContainerLab `intop1-ldp07.yml` topology:  

        ```
           containerlab deploy --topo intop1-ldp07.yml  
        ```
        4. Destroy ContainerLab `intop1-ldp07.yml` topology:  

        ```
           containerlab destroy --topo intop1-ldp07.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-ldp07.tst` file [here](../tst/intop1-ldp07.tst)  
        3. Launch `intop1-ldp07.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-ldp07 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-ldp07.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

