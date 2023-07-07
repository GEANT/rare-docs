# Example: load balancer server

=== "Topology"

    ![Alt text](../d2/serv-loadbal/serv-loadbal.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    server telnet tel
     vrf v1
     port 6666
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
    server loadbalancer lb
     server 10 1.1.1.1 6666
     port 666
     vrf v1
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
    ```

=== "Verification"

    ```
    r2 tping 100 15 1.1.1.1 vrf v1
    r2 tping 100 15 2.2.2.3 vrf v1
    r3 send telnet 2.2.2.2 666 vrf v1
    r3 tping 100 15 2.2.2.2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [serv-loadbal](../clab/serv-loadbal/serv-loadbal.yml) file  
        3. Launch ContainerLab `serv-loadbal.yml` topology:  

        ```
           containerlab deploy --topo serv-loadbal.yml  
        ```
        4. Destroy ContainerLab `serv-loadbal.yml` topology:  

        ```
           containerlab destroy --topo serv-loadbal.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `serv-loadbal.tst` file [here](../tst/serv-loadbal.tst)  
        3. Launch `serv-loadbal.tst` test:  

        ```
           java -jar ../../rtr.jar test tester serv-loadbal path ./ temp ./ wait
        ```
        4. Destroy freeRtr `serv-loadbal.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

