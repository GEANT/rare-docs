# Example: p4lang: bridging over backplane

=== "Topology"

    ![Alt text](../d2/p4lang-rout212/p4lang-rout212.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    vrf def v9
     rd 1:1
     exit
    int lo9
     vrf for v9
     ipv4 addr 10.10.10.227 255.255.255.255
     exit
    int eth1
     vrf for v9
     ipv4 addr 10.11.12.254 255.255.255.0
     exit
    int eth2
     exit
    server dhcp4 eth1
     pool 10.11.12.1 10.11.12.99
     gateway 10.11.12.254
     netmask 255.255.255.0
     dns-server 10.10.10.227
     domain-name p4l
     static 0000.0000.2222 10.11.12.111
     interface eth1
     vrf v9
     exit
    int eth3
     vrf for v9
     ipv4 addr 10.12.13.254 255.255.255.0
     exit
    int eth4
     exit
    server dhcp4 eth3
     pool 10.12.13.1 10.12.13.99
     gateway 10.12.13.254
     netmask 255.255.255.0
     dns-server 10.10.10.227
     domain-name p4l
     static 0000.0000.3333 10.12.13.111
     interface eth3
     vrf v9
     exit
    int eth5
     vrf for v9
     ipv4 addr 10.13.14.254 255.255.255.0
     exit
    int eth6
     exit
    server dhcp4 eth5
     pool 10.13.14.1 10.13.14.99
     gateway 10.13.14.254
     netmask 255.255.255.0
     dns-server 10.10.10.227
     domain-name p4l
     static 0000.0000.4444 10.13.14.111
     interface eth5
     vrf v9
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.101 255.255.255.255
     ipv6 addr 4321::101 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    bundle 1
     exit
    bundle 2
     exit
    bundle 3
     exit
    bundle 4
     exit
    bridge 1
     mac-learn
     exit
    int sdn11
     no autostat
     bridge-gr 1
     exit
    int sdn12
     no autostat
     bridge-gr 1
     exit
    int bun1
     vrf for v1
     mpls ena
     exit
    int sdn13
     no autostat
     bundle-gr 1
     exit
    int sdn14
     no autostat
     bundle-gr 1
     exit
    int sdn21
     no autostat
     bridge-gr 1
     exit
    int sdn22
     no autostat
     bridge-gr 1
     exit
    int bun2
     vrf for v1
     mpls ena
     exit
    int sdn23
     no autostat
     bundle-gr 2
     exit
    int sdn24
     no autostat
     bundle-gr 2
     exit
    int bun3
     vrf for v1
     mpls ena
     exit
    int sdn31
     no autostat
     bundle-gr 3
     exit
    int sdn32
     no autostat
     bundle-gr 3
     exit
    int bun4
     vrf for v1
     mpls ena
     exit
    int sdn33
     no autostat
     bundle-gr 4
     exit
    int sdn34
     no autostat
     bundle-gr 4
     exit
    server p4lang p4
     dataplanes 4
     forwarder 1 interconnect eth2
     forwarder 1 export-vrf v1
     forwarder 1 export-br 1
     forwarder 1 export-port sdn11 1 10
     forwarder 1 export-port sdn12 2 10
     forwarder 1 export-port sdn13 3 10
     forwarder 1 export-port sdn14 4 10
     forwarder 1 export-port bun1 dynamic
     forwarder 1 backplane bun1 1
     forwarder 1 remote 10.11.12.111
     forwarder 2 interconnect eth4
     forwarder 2 export-vrf v1
     forwarder 2 export-br 1
     forwarder 2 export-port sdn21 1 10
     forwarder 2 export-port sdn22 2 10
     forwarder 2 export-port sdn23 3 10
     forwarder 2 export-port sdn24 4 10
     forwarder 2 export-port bun2 dynamic
     forwarder 2 backplane bun2 1
     forwarder 2 remote 10.12.13.111
     forwarder 3 interconnect eth6
     forwarder 3 export-vrf v1
     forwarder 3 export-port sdn31 1 10
     forwarder 3 export-port sdn32 2 10
     forwarder 3 export-port sdn33 3 10
     forwarder 3 export-port sdn34 4 10
     forwarder 3 export-port bun3 dynamic
     forwarder 3 export-port bun4 dynamic
     forwarder 3 backplane bun3 1
     forwarder 3 backplane bun4 1
     forwarder 3 remote 10.13.14.111
     vrf v9
     exit
    ```

    **r2**

    ```
    hostname r2
    ```

    **r3**

    ```
    hostname r3
    ```

    **r4**

    ```
    hostname r4
    ```

    **r5**

    ```
    hostname r5
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.103 255.255.255.255
     ipv6 addr 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    bridge 1
     mac-learn
     block-unicast
     exit
    int eth1
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff:ffff::
     exit
    ipv4 route v1 2.2.2.104 255.255.255.255 1.1.1.4
    ipv4 route v1 2.2.2.105 255.255.255.255 1.1.1.5
    ipv4 route v1 2.2.2.106 255.255.255.255 1.1.1.6
    ipv6 route v1 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::4
    ipv6 route v1 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::5
    ipv6 route v1 4321::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::6
    ```

    **r6**

    ```
    hostname r6
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.104 255.255.255.255
     ipv6 addr 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.4 255.255.255.0
     ipv6 addr 1234::4 ffff:ffff::
     exit
    ipv4 route v1 2.2.2.103 255.255.255.255 1.1.1.3
    ipv4 route v1 2.2.2.105 255.255.255.255 1.1.1.5
    ipv4 route v1 2.2.2.106 255.255.255.255 1.1.1.6
    ipv6 route v1 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::3
    ipv6 route v1 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::5
    ipv6 route v1 4321::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::6
    ```

    **r7**

    ```
    hostname r7
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.105 255.255.255.255
     ipv6 addr 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.0
     ipv6 addr 1234::5 ffff:ffff::
     exit
    ipv4 route v1 2.2.2.103 255.255.255.255 1.1.1.3
    ipv4 route v1 2.2.2.104 255.255.255.255 1.1.1.4
    ipv4 route v1 2.2.2.106 255.255.255.255 1.1.1.6
    ipv6 route v1 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::3
    ipv6 route v1 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::4
    ipv6 route v1 4321::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::6
    ```

    **r8**

    ```
    hostname r8
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.106 255.255.255.255
     ipv6 addr 4321::106 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.0
     ipv6 addr 1234::6 ffff:ffff::
     exit
    ipv4 route v1 2.2.2.103 255.255.255.255 1.1.1.3
    ipv4 route v1 2.2.2.104 255.255.255.255 1.1.1.4
    ipv4 route v1 2.2.2.105 255.255.255.255 1.1.1.5
    ipv6 route v1 4321::103 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::3
    ipv6 route v1 4321::104 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::4
    ipv6 route v1 4321::105 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::5
    ```

=== "Verification"

    ```
    r5 tping 100 10 1.1.1.3 vrf v1
    r5 tping 100 10 1234::3 vrf v1
    r5 tping 100 10 1.1.1.4 vrf v1
    r5 tping 100 10 1234::4 vrf v1
    r5 tping 100 10 1.1.1.5 vrf v1
    r5 tping 100 10 1234::5 vrf v1
    r5 tping 100 10 1.1.1.6 vrf v1
    r5 tping 100 10 1234::6 vrf v1
    r6 tping 100 10 1.1.1.3 vrf v1
    r6 tping 100 10 1234::3 vrf v1
    r6 tping 100 10 1.1.1.4 vrf v1
    r6 tping 100 10 1234::4 vrf v1
    r6 tping 100 10 1.1.1.5 vrf v1
    r6 tping 100 10 1234::5 vrf v1
    r6 tping 100 10 1.1.1.6 vrf v1
    r6 tping 100 10 1234::6 vrf v1
    r7 tping 100 10 1.1.1.3 vrf v1
    r7 tping 100 10 1234::3 vrf v1
    r7 tping 100 10 1.1.1.4 vrf v1
    r7 tping 100 10 1234::4 vrf v1
    r7 tping 100 10 1.1.1.5 vrf v1
    r7 tping 100 10 1234::5 vrf v1
    r7 tping 100 10 1.1.1.6 vrf v1
    r7 tping 100 10 1234::6 vrf v1
    r8 tping 100 10 1.1.1.3 vrf v1
    r8 tping 100 10 1234::3 vrf v1
    r8 tping 100 10 1.1.1.4 vrf v1
    r8 tping 100 10 1234::4 vrf v1
    r8 tping 100 10 1.1.1.5 vrf v1
    r8 tping 100 10 1234::5 vrf v1
    r8 tping 100 10 1.1.1.6 vrf v1
    r8 tping 100 10 1234::6 vrf v1
    r5 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r5 tping 100 10 4321::103 vrf v1 sou lo0
    r5 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r5 tping 100 10 4321::104 vrf v1 sou lo0
    r5 tping 100 10 2.2.2.105 vrf v1 sou lo0
    r5 tping 100 10 4321::105 vrf v1 sou lo0
    r5 tping 100 10 2.2.2.106 vrf v1 sou lo0
    r5 tping 100 10 4321::106 vrf v1 sou lo0
    r6 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r6 tping 100 10 4321::103 vrf v1 sou lo0
    r6 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r6 tping 100 10 4321::104 vrf v1 sou lo0
    r6 tping 100 10 2.2.2.105 vrf v1 sou lo0
    r6 tping 100 10 4321::105 vrf v1 sou lo0
    r6 tping 100 10 2.2.2.106 vrf v1 sou lo0
    r6 tping 100 10 4321::106 vrf v1 sou lo0
    r7 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r7 tping 100 10 4321::103 vrf v1 sou lo0
    r7 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r7 tping 100 10 4321::104 vrf v1 sou lo0
    r7 tping 100 10 2.2.2.105 vrf v1 sou lo0
    r7 tping 100 10 4321::105 vrf v1 sou lo0
    r7 tping 100 10 2.2.2.106 vrf v1 sou lo0
    r7 tping 100 10 4321::106 vrf v1 sou lo0
    r8 tping 100 10 2.2.2.103 vrf v1 sou lo0
    r8 tping 100 10 4321::103 vrf v1 sou lo0
    r8 tping 100 10 2.2.2.104 vrf v1 sou lo0
    r8 tping 100 10 4321::104 vrf v1 sou lo0
    r8 tping 100 10 2.2.2.105 vrf v1 sou lo0
    r8 tping 100 10 4321::105 vrf v1 sou lo0
    r8 tping 100 10 2.2.2.106 vrf v1 sou lo0
    r8 tping 100 10 4321::106 vrf v1 sou lo0
    r1 dping sdn . r8 2.2.2.105 vrf v1 sou lo0
    r1 dping sdn . r8 4321::105 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [p4lang-rout212](../clab/p4lang-rout212/p4lang-rout212.yml) file  
        3. Launch ContainerLab `p4lang-rout212.yml` topology:  

        ```
           containerlab deploy --topo p4lang-rout212.yml  
        ```
        4. Destroy ContainerLab `p4lang-rout212.yml` topology:  

        ```
           containerlab destroy --topo p4lang-rout212.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `p4lang-rout212.tst` file [here](../tst/p4lang-rout212.tst)  
        3. Launch `p4lang-rout212.tst` test:  

        ```
           java -jar ../../rtr.jar test tester p4lang-rout212 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `p4lang-rout212.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

