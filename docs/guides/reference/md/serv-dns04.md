# Example: dns64 server

=== "Topology"

    ![Alt text](../d2/serv-dns04/serv-dns04.svg)

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
     ipv6 addr 1234::1111:1111 ffff::
     exit
    server dns dns
     zone test.corp defttl 43200
     rr www.test.corp ip4a 17.17.17.17
     vrf v1
     exit
    proxy-profile p1
     vrf v1
     source ethernet1
     exit
    client proxy p1
    client name-server 1234::2
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
    server dns dns
     recursion 6to4prefix 1234::
     recursion enable
     vrf v1
     exit
    proxy-profile p1
     vrf v1
     source ethernet1
     exit
    client proxy p1
    client name-server 1.1.1.1
    ```

=== "Verification"

    ```
    r2 tping 100 15 1.1.1.1 vrf v1
    r2 tping 100 15 1234::1111:1111 vrf v1
    r1 tping 100 15 www.test.corp vrf v1 ipv6
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [serv-dns04](../clab/serv-dns04/serv-dns04.yml) file  
        3. Launch ContainerLab `serv-dns04.yml` topology:  

        ```
           containerlab deploy --topo serv-dns04.yml  
        ```
        4. Destroy ContainerLab `serv-dns04.yml` topology:  

        ```
           containerlab destroy --topo serv-dns04.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `serv-dns04.tst` file [here](../tst/serv-dns04.tst)  
        3. Launch `serv-dns04.tst` test:  

        ```
           java -jar ../../rtr.jar test tester serv-dns04 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `serv-dns04.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

