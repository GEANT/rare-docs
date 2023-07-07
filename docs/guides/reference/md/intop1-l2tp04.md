# Example: interop1: ethernet tunneling with l2tp3

=== "Topology"

    ![Alt text](../d2/intop1-l2tp04/intop1-l2tp04.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     exit
    bridge 1
     mac-learn
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff:ffff::
     exit
    server l2tp3 l2tp
     bridge 1
     vrf v1
     exit
    ```

    **r2**

    ```
    hostname r2
    ip routing
    ipv6 unicast-routing
    interface gigabit1
     ip address 1.1.1.2 255.255.255.0
     no shutdown
     exit
    vpdn enable
    l2tp-class l2tpc
     exit
    pseudowire-class l2tp
     encapsulation l2tpv3
     protocol l2tpv3ietf l2tpc
     ip local interface gigabit1
     exit
    interface gigabit2
     xconnect 1.1.1.1 1234 pw-class l2tp
     no shutdown
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1
    r1 tping 100 60 4321::2 vrf v1
    r3 tping 100 60 2.2.2.1 vrf v1
    r3 tping 100 60 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-l2tp04](../clab/intop1-l2tp04/intop1-l2tp04.yml) file  
        3. Launch ContainerLab `intop1-l2tp04.yml` topology:  

        ```
           containerlab deploy --topo intop1-l2tp04.yml  
        ```
        4. Destroy ContainerLab `intop1-l2tp04.yml` topology:  

        ```
           containerlab destroy --topo intop1-l2tp04.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-l2tp04.tst` file [here](../tst/intop1-l2tp04.tst)  
        3. Launch `intop1-l2tp04.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-l2tp04 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-l2tp04.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

