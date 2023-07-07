# Example: interop1: pppoe server

=== "Topology"

    ![Alt text](../d2/intop1-pppoe02/intop1-pppoe02.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int di1
     enc ppp
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr fe80::1234 ffff::
     ppp ip4cp local 2.2.2.1
     ppp ip4cp open
     ppp ip6cp open
     exit
    int eth1
     p2poe server di1
     exit
    ```

    **r2**

    ```
    hostname r2
    ip routing
    ipv6 unicast-routing
    interface dialer1
     encapsulation ppp
     ip address 2.2.2.2 255.255.255.0
     ipv6 address fe80::4321 link-local
     dialer pool 1
     dialer persistent
     exit
    interface gigabit1
     pppoe-client dial-pool-number 1
     no shutdown
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1
    r1 tping 100 60 fe80::4321 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-pppoe02](../clab/intop1-pppoe02/intop1-pppoe02.yml) file  
        3. Launch ContainerLab `intop1-pppoe02.yml` topology:  

        ```
           containerlab deploy --topo intop1-pppoe02.yml  
        ```
        4. Destroy ContainerLab `intop1-pppoe02.yml` topology:  

        ```
           containerlab destroy --topo intop1-pppoe02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-pppoe02.tst` file [here](../tst/intop1-pppoe02.tst)  
        3. Launch `intop1-pppoe02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-pppoe02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-pppoe02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

