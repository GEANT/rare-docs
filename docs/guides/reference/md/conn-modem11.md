# Example: modem through tcp peer

=== "Topology"

    ![Alt text](../d2/conn-modem11/conn-modem11.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    server modem sm
     vrf v1
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 2345::1 ffff::
     exit
    dial-peer 1
     match-calling .*
     match-called .*
     vrf v1
     myname 99
     target 1.1.1.1
     direction out
     exit
    dial-peer 2
     match-calling .*
     match-called .*
     vrf v1
     myname 77
     target 1.1.2.2
     port-local 0
     protocol sip-conn
     direction in
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
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 2345::2 ffff::
     exit
    dial-peer 1
     match-calling .*
     match-called .*
     vrf v1
     myname 99
     target 1.1.2.1
     port-local 5060
     port-remote 0
     protocol sip-list
     direction out
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 5 1.1.2.2 vrf v1
    r2 tping 100 5 1.1.1.1 vrf v1
    r3 tping 100 5 1.1.2.1 vrf v1
    r1 tping 100 5 1.1.1.2 vrf v1
    r3 send pack modem 11 22
    r3 tping 100 5 2.2.2.2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-modem11](../clab/conn-modem11/conn-modem11.yml) file  
        3. Launch ContainerLab `conn-modem11.yml` topology:  

        ```
           containerlab deploy --topo conn-modem11.yml  
        ```
        4. Destroy ContainerLab `conn-modem11.yml` topology:  

        ```
           containerlab destroy --topo conn-modem11.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-modem11.tst` file [here](../tst/conn-modem11.tst)  
        3. Launch `conn-modem11.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-modem11 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-modem11.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

