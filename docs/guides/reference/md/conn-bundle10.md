# Example: loadbalancing bundle

=== "Topology"

    ![Alt text](../d2/conn-bundle10/conn-bundle10.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    bundle 1
     no ethernet
     loadbalance layer3
     exit
    int ser1
     bundle-gr 1
     exit
    int ser2
     bundle-gr 1
     exit
    int bun1
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
    int ser1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    server telnet tel
     vrf v1
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int ser1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    server telnet tel
     vrf v1
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 1.1.1.2 vrf v1
    r1 tping 100 5 1234::2 vrf v1
    r1 send telnet 1.1.1.2 vrf v1
    r1 tping 100 5 2.2.2.1 vrf v1
    r1 tping 100 5 4321::1 vrf v1
    r1 send exit
    r1 read closed
    r1 send telnet 1234::2 vrf v1
    r1 tping 100 5 2.2.2.1 vrf v1
    r1 tping 100 5 4321::1 vrf v1
    r1 send exit
    r1 read closed
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-bundle10](../clab/conn-bundle10/conn-bundle10.yml) file  
        3. Launch ContainerLab `conn-bundle10.yml` topology:  

        ```
           containerlab deploy --topo conn-bundle10.yml  
        ```
        4. Destroy ContainerLab `conn-bundle10.yml` topology:  

        ```
           containerlab destroy --topo conn-bundle10.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-bundle10.tst` file [here](../tst/conn-bundle10.tst)  
        3. Launch `conn-bundle10.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-bundle10 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-bundle10.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

