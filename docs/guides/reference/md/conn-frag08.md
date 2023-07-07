# Example: ip ttl exceed

=== "Topology"

    ![Alt text](../d2/conn-frag08/conn-frag08.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
    ipv4 route v1 2.2.2.4 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1235::1 ffff::
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::1
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1235::2
    ipv4 route v1 2.2.2.4 255.255.255.255 1.1.2.2
    ipv6 route v1 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1235::2
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1235::2 ffff::
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.3.1 255.255.255.0
     ipv6 addr 1236::1 ffff::
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.2.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1235::1
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.2.1
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1235::1
    ipv4 route v1 2.2.2.4 255.255.255.255 1.1.3.2
    ipv6 route v1 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1236::2
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.3.2 255.255.255.0
     ipv6 addr 1236::2 ffff::
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.3.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1236::1
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.3.1
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1236::1
    ipv4 route v1 2.2.2.3 255.255.255.255 1.1.3.1
    ipv6 route v1 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1236::1
    ```

=== "Verification"

    ```
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0 ttl 3
    r1 tping 100 10 4321::2 vrf v1 sou lo0 ttl 3
    r1 tping 100 10 2.2.2.3 vrf v1 sou lo0 ttl 3
    r1 tping 100 10 4321::3 vrf v1 sou lo0 ttl 3
    r1 tping 100 10 2.2.2.4 vrf v1 sou lo0 ttl 3
    r1 tping 100 10 4321::4 vrf v1 sou lo0 ttl 3
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0 ttl 3
    r2 tping 100 10 4321::1 vrf v1 sou lo0 ttl 3
    r2 tping 100 10 2.2.2.3 vrf v1 sou lo0 ttl 3
    r2 tping 100 10 4321::3 vrf v1 sou lo0 ttl 3
    r2 tping 100 10 2.2.2.4 vrf v1 sou lo0 ttl 3
    r2 tping 100 10 4321::4 vrf v1 sou lo0 ttl 3
    r3 tping 100 10 2.2.2.1 vrf v1 sou lo0 ttl 3
    r3 tping 100 10 4321::1 vrf v1 sou lo0 ttl 3
    r3 tping 100 10 2.2.2.2 vrf v1 sou lo0 ttl 3
    r3 tping 100 10 4321::2 vrf v1 sou lo0 ttl 3
    r3 tping 100 10 2.2.2.4 vrf v1 sou lo0 ttl 3
    r3 tping 100 10 4321::4 vrf v1 sou lo0 ttl 3
    r4 tping 100 10 2.2.2.1 vrf v1 sou lo0 ttl 3
    r4 tping 100 10 4321::1 vrf v1 sou lo0 ttl 3
    r4 tping 100 10 2.2.2.2 vrf v1 sou lo0 ttl 3
    r4 tping 100 10 4321::2 vrf v1 sou lo0 ttl 3
    r4 tping 100 10 2.2.2.3 vrf v1 sou lo0 ttl 3
    r4 tping 100 10 4321::3 vrf v1 sou lo0 ttl 3
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0 ttl 2 error
    r1 tping 100 10 4321::2 vrf v1 sou lo0 ttl 2 error
    r1 tping 100 10 2.2.2.3 vrf v1 sou lo0 ttl 2 error
    r1 tping 100 10 4321::3 vrf v1 sou lo0 ttl 2 error
    r1 tping -100 10 2.2.2.4 vrf v1 sou lo0 ttl 2 error
    r1 tping -100 10 4321::4 vrf v1 sou lo0 ttl 2 error
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0 ttl 2 error
    r2 tping 100 10 4321::1 vrf v1 sou lo0 ttl 2 error
    r2 tping 100 10 2.2.2.3 vrf v1 sou lo0 ttl 2 error
    r2 tping 100 10 4321::3 vrf v1 sou lo0 ttl 2 error
    r2 tping 100 10 2.2.2.4 vrf v1 sou lo0 ttl 2 error
    r2 tping 100 10 4321::4 vrf v1 sou lo0 ttl 2 error
    r3 tping 100 10 2.2.2.1 vrf v1 sou lo0 ttl 2 error
    r3 tping 100 10 4321::1 vrf v1 sou lo0 ttl 2 error
    r3 tping 100 10 2.2.2.2 vrf v1 sou lo0 ttl 2 error
    r3 tping 100 10 4321::2 vrf v1 sou lo0 ttl 2 error
    r3 tping 100 10 2.2.2.4 vrf v1 sou lo0 ttl 2 error
    r3 tping 100 10 4321::4 vrf v1 sou lo0 ttl 2 error
    r4 tping -100 10 2.2.2.1 vrf v1 sou lo0 ttl 2 error
    r4 tping -100 10 4321::1 vrf v1 sou lo0 ttl 2 error
    r4 tping 100 10 2.2.2.2 vrf v1 sou lo0 ttl 2 error
    r4 tping 100 10 4321::2 vrf v1 sou lo0 ttl 2 error
    r4 tping 100 10 2.2.2.3 vrf v1 sou lo0 ttl 2 error
    r4 tping 100 10 4321::3 vrf v1 sou lo0 ttl 2 error
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0 ttl 1 error
    r1 tping 100 10 4321::2 vrf v1 sou lo0 ttl 1 error
    r1 tping -100 10 2.2.2.3 vrf v1 sou lo0 ttl 1 error
    r1 tping -100 10 4321::3 vrf v1 sou lo0 ttl 1 error
    r1 tping -100 10 2.2.2.4 vrf v1 sou lo0 ttl 1 error
    r1 tping -100 10 4321::4 vrf v1 sou lo0 ttl 1 error
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0 ttl 1 error
    r2 tping 100 10 4321::1 vrf v1 sou lo0 ttl 1 error
    r2 tping 100 10 2.2.2.3 vrf v1 sou lo0 ttl 1 error
    r2 tping 100 10 4321::3 vrf v1 sou lo0 ttl 1 error
    r2 tping -100 10 2.2.2.4 vrf v1 sou lo0 ttl 1 error
    r2 tping -100 10 4321::4 vrf v1 sou lo0 ttl 1 error
    r3 tping -100 10 2.2.2.1 vrf v1 sou lo0 ttl 1 error
    r3 tping -100 10 4321::1 vrf v1 sou lo0 ttl 1 error
    r3 tping 100 10 2.2.2.2 vrf v1 sou lo0 ttl 1 error
    r3 tping 100 10 4321::2 vrf v1 sou lo0 ttl 1 error
    r3 tping 100 10 2.2.2.4 vrf v1 sou lo0 ttl 1 error
    r3 tping 100 10 4321::4 vrf v1 sou lo0 ttl 1 error
    r4 tping -100 10 2.2.2.1 vrf v1 sou lo0 ttl 1 error
    r4 tping -100 10 4321::1 vrf v1 sou lo0 ttl 1 error
    r4 tping -100 10 2.2.2.2 vrf v1 sou lo0 ttl 1 error
    r4 tping -100 10 4321::2 vrf v1 sou lo0 ttl 1 error
    r4 tping 100 10 2.2.2.3 vrf v1 sou lo0 ttl 1 error
    r4 tping 100 10 4321::3 vrf v1 sou lo0 ttl 1 error
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-frag08](../clab/conn-frag08/conn-frag08.yml) file  
        3. Launch ContainerLab `conn-frag08.yml` topology:  

        ```
           containerlab deploy --topo conn-frag08.yml  
        ```
        4. Destroy ContainerLab `conn-frag08.yml` topology:  

        ```
           containerlab destroy --topo conn-frag08.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-frag08.tst` file [here](../tst/conn-frag08.tst)  
        3. Launch `conn-frag08.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-frag08 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-frag08.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

