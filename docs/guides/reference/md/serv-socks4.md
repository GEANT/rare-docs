# Example: socks4 server

=== "Topology"

    ![Alt text](../d2/serv-socks4/serv-socks4.svg)

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
    proxy-profile p1
     protocol socks4
     vrf v1
     target 1.1.1.2
     port 1080
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
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int eth2
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    server socks socks
     vrf v1
     target vrf v1
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
    int lo0
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.255
     ipv6 addr 3333::3 ffff::
     exit
    server telnet telnet
     vrf v1
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 15 1.1.1.1 vrf v1
    r2 tping 100 15 2.2.2.3 vrf v1
    r2 tping 100 15 1234::1 vrf v1
    r2 tping 100 15 4321::3 vrf v1
    r1 tping 0 5 3.3.3.3 vrf v1
    r1 send telnet 2.2.2.3 prox p1
    r1 tping 100 15 3.3.3.3 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [serv-socks4](../clab/serv-socks4/serv-socks4.yml) file  
        3. Launch ContainerLab `serv-socks4.yml` topology:  

        ```
           containerlab deploy --topo serv-socks4.yml  
        ```
        4. Destroy ContainerLab `serv-socks4.yml` topology:  

        ```
           containerlab destroy --topo serv-socks4.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `serv-socks4.tst` file [here](../tst/serv-socks4.tst)  
        3. Launch `serv-socks4.tst` test:  

        ```
           java -jar ../../rtr.jar test tester serv-socks4 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `serv-socks4.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

