# Example: proxy remote arp/nd

=== "Topology"

    ![Alt text](../d2/conn-eth13/conn-eth13.svg)

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
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.0
     ipv6 addr 1234::5 ffff::
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
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffc
     ipv4 proxy-remote
     ipv6 proxy-remote
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234::6 ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffc
     ipv4 proxy-remote
     ipv6 proxy-remote
     exit
    ```

=== "Verification"

    ```
    r3 tping 100 5 1.1.1.2 vrf v1
    r3 tping 100 5 1234::2 vrf v1
    r3 tping 100 5 1.1.1.6 vrf v1
    r3 tping 100 5 1234::6 vrf v1
    r3 tping 100 5 1.1.1.1 vrf v1
    r3 tping 100 5 1234::1 vrf v1
    r3 tping 100 5 1.1.1.5 vrf v1
    r3 tping 100 5 1234::5 vrf v1
    r1 tping 100 5 1.1.1.2 vrf v1
    r1 tping 100 5 1234::2 vrf v1
    r1 tping 100 5 1.1.1.6 vrf v1
    r1 tping 100 5 1234::6 vrf v1
    r1 tping 100 5 1.1.1.1 vrf v1
    r1 tping 100 5 1234::1 vrf v1
    r1 tping 100 5 1.1.1.5 vrf v1
    r1 tping 100 5 1234::5 vrf v1
    r2 tping 100 5 1.1.1.2 vrf v1
    r2 tping 100 5 1234::2 vrf v1
    r2 tping 100 5 1.1.1.6 vrf v1
    r2 tping 100 5 1234::6 vrf v1
    r2 tping 100 5 1.1.1.1 vrf v1
    r2 tping 100 5 1234::1 vrf v1
    r2 tping 100 5 1.1.1.5 vrf v1
    r2 tping 100 5 1234::5 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-eth13](../clab/conn-eth13/conn-eth13.yml) file  
        3. Launch ContainerLab `conn-eth13.yml` topology:  

        ```
           containerlab deploy --topo conn-eth13.yml  
        ```
        4. Destroy ContainerLab `conn-eth13.yml` topology:  

        ```
           containerlab destroy --topo conn-eth13.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-eth13.tst` file [here](../tst/conn-eth13.tst)  
        3. Launch `conn-eth13.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-eth13 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-eth13.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

