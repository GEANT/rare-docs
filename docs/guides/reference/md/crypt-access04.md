# Example: access subnet

=== "Topology"

    ![Alt text](../d2/crypt-access04/crypt-access04.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    bridge 1
     mac-learn
     exit
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int eth3
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    ipv4 route v1 2.2.2.4 255.255.255.255 1.1.1.4
    ipv6 route v1 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::4
    server telnet tel
     vrf v1
     access-subnet 2
     port 666
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
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff::
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.4 255.255.255.0
     ipv6 addr 1234::4 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 1.1.1.2 vrf v1
    r1 tping 100 20 1234::2 vrf v1
    r1 tping 100 20 1.1.1.3 vrf v1
    r1 tping 100 20 1234::3 vrf v1
    r1 tping 100 20 1.1.1.4 vrf v1
    r1 tping 100 20 1234::4 vrf v1
    r2 tping 100 20 1.1.1.1 vrf v1
    r2 tping 100 20 1234::1 vrf v1
    r3 tping 100 20 1.1.1.1 vrf v1
    r3 tping 100 20 1234::1 vrf v1
    r4 tping 100 20 1.1.1.1 vrf v1
    r4 tping 100 20 1234::1 vrf v1
    r1 tping 100 20 2.2.2.1 vrf v1
    r2 tping 0 20 2.2.2.1 vrf v1
    r3 tping 0 20 2.2.2.1 vrf v1
    r4 tping 0 20 2.2.2.1 vrf v1
    r2 send telnet 1.1.1.1 666 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r3 send telnet 1.1.1.1 666 vrf v1
    r3 tping 100 20 2.2.2.1 vrf v1
    r4 send telnet 1.1.1.1 666 vrf v1
    r4 tping 0 20 2.2.2.1 vrf v1
    r4 send telnet 1.1.1.1 666 vrf v1 sou lo1
    r4 tping 100 20 2.2.2.1 vrf v1
    r2 send exit
    r2 read closed
    r3 send exit
    r3 read closed
    r4 send exit
    r4 read closed
    r2 send telnet 1234::1 666 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r3 send telnet 1234::1 666 vrf v1
    r3 tping 100 20 2.2.2.1 vrf v1
    r4 send telnet 1234::1 666 vrf v1
    r4 tping 0 20 2.2.2.1 vrf v1
    r4 send telnet 1234::1 666 vrf v1 sou lo1
    r4 tping 100 20 2.2.2.1 vrf v1
    r2 send exit
    r2 read closed
    r3 send exit
    r3 read closed
    r4 send exit
    r4 read closed
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-access04](../clab/crypt-access04/crypt-access04.yml) file  
        3. Launch ContainerLab `crypt-access04.yml` topology:  

        ```
           containerlab deploy --topo crypt-access04.yml  
        ```
        4. Destroy ContainerLab `crypt-access04.yml` topology:  

        ```
           containerlab destroy --topo crypt-access04.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-access04.tst` file [here](../tst/crypt-access04.tst)  
        3. Launch `crypt-access04.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-access04 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-access04.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

