# Example: ppp over packet over udp pwhe

=== "Topology"

    ![Alt text](../d2/mpls-pwhe01/mpls-pwhe01.svg)

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
    int virt1
     enc ppp
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     pseudo v1 lo0 pckoudp 2.2.2.2 1234
     exit
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
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::1
    int virt1
     enc ppp
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     pseudo v1 lo0 pckoudp 2.2.2.1 1234
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 10 4321::2 vrf v1 sou lo0
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 10 4321::1 vrf v1 sou lo0
    r1 tping 100 40 3.3.3.2 vrf v1
    r2 tping 100 40 3.3.3.1 vrf v1
    r1 output show inter virt1 full
    output ../binTmp/mpls-virtppp.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the interface:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-pwhe01](../clab/mpls-pwhe01/mpls-pwhe01.yml) file  
        3. Launch ContainerLab `mpls-pwhe01.yml` topology:  

        ```
           containerlab deploy --topo mpls-pwhe01.yml  
        ```
        4. Destroy ContainerLab `mpls-pwhe01.yml` topology:  

        ```
           containerlab destroy --topo mpls-pwhe01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-pwhe01.tst` file [here](../tst/mpls-pwhe01.tst)  
        3. Launch `mpls-pwhe01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-pwhe01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-pwhe01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

