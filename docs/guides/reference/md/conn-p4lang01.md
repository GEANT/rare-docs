# Example: p4lang demultiplexer

=== "Topology"

    ![Alt text](../d2/conn-p4lang01/conn-p4lang01.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     exit
    int eth2
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     exit
    int sdn1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    int sdn2
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
     exit
    server p4lang p4
     interconnect eth1
     export-vrf v1
     export-port sdn1 1
     export-port sdn2 9
     vrf v1
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     exit
    int eth2
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     exit
    hair 1
     exit
    hair 2
     exit
    serv pktmux pm
     cpu eth1
     data hair11 1
     data hair21 9
     control p1 3.3.3.1 9080
     exit
    int hair12
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int hair22
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 3.3.3.2 vrf v1
    r2 tping 100 5 3.3.3.1 vrf v1
    r1 tping 100 5 1.1.1.2 vrf v1
    r2 tping 100 5 1.1.1.1 vrf v1
    r1 tping 100 5 1234::2 vrf v1
    r2 tping 100 5 1234::1 vrf v1
    r1 tping 100 5 2.2.2.2 vrf v1
    r2 tping 100 5 2.2.2.1 vrf v1
    r1 tping 100 5 4321::2 vrf v1
    r2 tping 100 5 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-p4lang01](../clab/conn-p4lang01/conn-p4lang01.yml) file  
        3. Launch ContainerLab `conn-p4lang01.yml` topology:  

        ```
           containerlab deploy --topo conn-p4lang01.yml  
        ```
        4. Destroy ContainerLab `conn-p4lang01.yml` topology:  

        ```
           containerlab destroy --topo conn-p4lang01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-p4lang01.tst` file [here](../tst/conn-p4lang01.tst)  
        3. Launch `conn-p4lang01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-p4lang01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-p4lang01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

