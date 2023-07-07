# Example: remote triggered blackhole access

=== "Topology"

    ![Alt text](../d2/crypt-access05/crypt-access05.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    vrf def v2
     rd 1:2
     rt-both 1:2
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
    int eth4
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    router blackhole4 1
     vrf v2
     exit
    router blackhole6 1
     vrf v2
     exit
    router bgp4 1
     vrf v1
     address vpnuni uni
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.5 remote-as 1
     neigh 1.1.1.5 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red blackhole4 1
     red conn
     exit
    router bgp6 1
     vrf v1
     address vpnuni uni
     local-as 1
     router-id 6.6.6.1
     neigh 1234::5 remote-as 1
     neigh 1234::5 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red blackhole6 1
     red conn
     exit
    server telnet tel
     vrf v1
     access-subnet 2
     access-blackhole4 1
     access-blackhole6 1
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

    **r5**

    ```
    hostname r5
    vrf def v1
     rd 1:1
     exit
    vrf def v2
     rd 1:2
     rt-both 1:2
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.5 255.255.255.255
     ipv6 addr 4321::5 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.0
     ipv6 addr 1234::5 ffff::
     exit
    router blackhole4 1
     vrf v2
     exit
    router blackhole6 1
     vrf v2
     exit
    router bgp4 1
     vrf v1
     address vpnuni uni
     local-as 1
     router-id 4.4.4.5
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red blackhole4 1
     red conn
     exit
    router bgp6 1
     vrf v1
     address vpnuni uni
     local-as 1
     router-id 6.6.6.5
     neigh 1234::1 remote-as 1
     neigh 1234::1 send-comm both
     afi-vrf v2 ena
     afi-vrf v2 red blackhole6 1
     red conn
     exit
    server telnet tel
     vrf v1
     access-blackhole4 1
     access-blackhole6 1
     port 666
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
    r5 tping 100 20 1.1.1.2 vrf v1
    r5 tping 100 20 1234::2 vrf v1
    r5 tping 100 20 1.1.1.3 vrf v1
    r5 tping 100 20 1234::3 vrf v1
    r5 tping 100 20 1.1.1.4 vrf v1
    r5 tping 100 20 1234::4 vrf v1
    r2 tping 100 20 1.1.1.5 vrf v1
    r2 tping 100 20 1234::5 vrf v1
    r3 tping 100 20 1.1.1.5 vrf v1
    r3 tping 100 20 1234::5 vrf v1
    r4 tping 100 20 1.1.1.5 vrf v1
    r4 tping 100 20 1234::5 vrf v1
    r1 tping 100 20 2.2.2.1 vrf v1
    r2 tping 0 20 2.2.2.1 vrf v1
    r3 tping 0 20 2.2.2.1 vrf v1
    r4 tping 0 20 2.2.2.1 vrf v1
    r5 tping 100 20 2.2.2.1 vrf v1
    r1 tping 100 20 2.2.2.5 vrf v1
    r2 tping 0 20 2.2.2.5 vrf v1
    r3 tping 0 20 2.2.2.5 vrf v1
    r4 tping 0 20 2.2.2.5 vrf v1
    r5 tping 100 20 2.2.2.5 vrf v1
    r2 send telnet 1.1.1.5 666 vrf v1
    r2 tping 100 20 2.2.2.5 vrf v1
    r2 send exit
    r2 read closed
    r2 send telnet 1234::5 666 vrf v1
    r2 tping 100 20 2.2.2.5 vrf v1
    r2 send exit
    r2 read closed
    r3 send telnet 1.1.1.5 666 vrf v1
    r3 tping 100 20 2.2.2.5 vrf v1
    r3 send exit
    r3 read closed
    r3 send telnet 1234::5 666 vrf v1
    r3 tping 100 20 2.2.2.5 vrf v1
    r3 send exit
    r3 read closed
    r4 send telnet 1.1.1.5 666 vrf v1
    r4 tping 100 20 2.2.2.5 vrf v1
    r4 send exit
    r4 read closed
    r4 send telnet 1234::5 666 vrf v1
    r4 tping 100 20 2.2.2.5 vrf v1
    r4 send exit
    r4 read closed
    r2 send telnet 1.1.1.1 666 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r3 send telnet 1.1.1.1 666 vrf v1
    r3 tping 100 20 2.2.2.1 vrf v1
    r4 send telnet 1.1.1.1 666 vrf v1
    r4 tping 0 20 2.2.2.1 vrf v1
    r2 send exit
    r2 read closed
    r3 send exit
    r3 read closed
    r2 send telnet 1234::1 666 vrf v1
    r2 tping 100 20 2.2.2.1 vrf v1
    r3 send telnet 1234::1 666 vrf v1
    r3 tping 100 20 2.2.2.1 vrf v1
    r4 send telnet 1234::1 666 vrf v1
    r4 tping 0 20 2.2.2.1 vrf v1
    r2 send exit
    r2 read closed
    r3 send exit
    r3 read closed
    r2 send telnet 1.1.1.5 666 vrf v1
    r2 tping 0 20 2.2.2.5 vrf v1
    r2 send telnet 1234::5 666 vrf v1
    r2 tping 0 20 2.2.2.5 vrf v1
    r3 send telnet 1.1.1.5 666 vrf v1
    r3 tping 0 20 2.2.2.5 vrf v1
    r3 send telnet 1234::5 666 vrf v1
    r3 tping 0 20 2.2.2.5 vrf v1
    r4 send telnet 1.1.1.5 666 vrf v1
    r4 tping 0 20 2.2.2.5 vrf v1
    r4 send telnet 1234::5 666 vrf v1
    r4 tping 0 20 2.2.2.5 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-access05](../clab/crypt-access05/crypt-access05.yml) file  
        3. Launch ContainerLab `crypt-access05.yml` topology:  

        ```
           containerlab deploy --topo crypt-access05.yml  
        ```
        4. Destroy ContainerLab `crypt-access05.yml` topology:  

        ```
           containerlab destroy --topo crypt-access05.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-access05.tst` file [here](../tst/crypt-access05.tst)  
        3. Launch `crypt-access05.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-access05 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-access05.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

