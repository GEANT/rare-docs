# Example: monitor session sampled

=== "Topology"

    ![Alt text](../d2/conn-eth21/conn-eth21.svg)

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
    int lo1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.255
     ipv6 addr 1234::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
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
     monitor-dir tx
     monitor-samp 5
     monitor-sess eth2
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
    r3 tping 120 5 1.1.1.1 vrf v1 multi
    r3 tping 120 5 1234::1 vrf v1 multi
    r3 tping 100 5 1.1.1.5 vrf v1 multi
    r3 tping 100 5 1234::5 vrf v1 multi
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-eth21](../clab/conn-eth21/conn-eth21.yml) file  
        3. Launch ContainerLab `conn-eth21.yml` topology:  

        ```
           containerlab deploy --topo conn-eth21.yml  
        ```
        4. Destroy ContainerLab `conn-eth21.yml` topology:  

        ```
           containerlab destroy --topo conn-eth21.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-eth21.tst` file [here](../tst/conn-eth21.tst)  
        3. Launch `conn-eth21.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-eth21 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-eth21.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

