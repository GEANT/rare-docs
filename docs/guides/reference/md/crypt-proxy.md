# Example: transparent proxy

=== "Topology"

    ![Alt text](../d2/crypt-proxy/crypt-proxy.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int ser1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.2
    ipv6 route v1 :: :: 1234::2
    proxy-profile p1
     vrf v1
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int ser1
     transproxy p1
     exit
    int ser2
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
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
    r2 tping 100 10 2.2.2.3 vrf v1
    r1 tping 0 5 3.3.3.3 vrf v1
    r1 send telnet 2.2.2.3 prox p1
    r1 tping 100 5 3.3.3.3 vrf v1
    r1 send exit
    r1 read closed
    r1 tping 0 60 3.3.3.3 vrf v1
    r1 send telnet 4321::3 prox p1
    r1 tping 100 5 3.3.3.3 vrf v1
    r1 send exit
    r1 read closed
    r1 tping 0 60 3.3.3.3 vrf v1
    r2 output show transprox ser1
    output ../binTmp/crypt-proxy.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the session list:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-proxy](../clab/crypt-proxy/crypt-proxy.yml) file  
        3. Launch ContainerLab `crypt-proxy.yml` topology:  

        ```
           containerlab deploy --topo crypt-proxy.yml  
        ```
        4. Destroy ContainerLab `crypt-proxy.yml` topology:  

        ```
           containerlab destroy --topo crypt-proxy.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-proxy.tst` file [here](../tst/crypt-proxy.tst)  
        3. Launch `crypt-proxy.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-proxy path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-proxy.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

