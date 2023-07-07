# Example: udp forwarder server

=== "Topology"

    ![Alt text](../d2/serv-udpforward/serv-udpforward.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    int tun1
     tun vrf v1
     tun sou eth1
     tun dest 1.1.1.2
     tun key 4321
     tun mod pckoudp
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
     exit
    vrf def v2
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int eth2
     vrf for v2
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    server udpfwd fwd
     port 1234
     target vrf v1
     target address 1.1.1.1
     target port 4321
     vrf v2
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
     ipv4 addr 2.2.2.3 255.255.255.0
     ipv6 addr 4321::3 ffff::
     exit
    int tun1
     tun vrf v1
     tun sou eth1
     tun dest 2.2.2.2
     tun key 1234
     tun mod pckoudp
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     ipv6 addr 3333::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 15 1.1.1.1 vrf v1
    r2 tping 100 15 2.2.2.3 vrf v2
    r3 tping 100 15 3.3.3.1 vrf v1
    r3 tping 100 15 3333::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [serv-udpforward](../clab/serv-udpforward/serv-udpforward.yml) file  
        3. Launch ContainerLab `serv-udpforward.yml` topology:  

        ```
           containerlab deploy --topo serv-udpforward.yml  
        ```
        4. Destroy ContainerLab `serv-udpforward.yml` topology:  

        ```
           containerlab destroy --topo serv-udpforward.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `serv-udpforward.tst` file [here](../tst/serv-udpforward.tst)  
        3. Launch `serv-udpforward.tst` test:  

        ```
           java -jar ../../rtr.jar test tester serv-udpforward path ./ temp ./ wait
        ```
        4. Destroy freeRtr `serv-udpforward.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

