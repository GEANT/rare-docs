# Example: relaying dns server

=== "Topology"

    ![Alt text](../d2/serv-dns03/serv-dns03.svg)

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
    server dns dns
     zone test.corp defttl 43200
     rr www.test.corp ip4a 1.1.1.1
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
    proxy-profile p1
     vrf v1
     source ethernet1
     exit
    server dns dns
     resolv test.corp p1 1234::1
     vrf v1
     exit
    client proxy p1
    client name-server 1.1.1.1
    ```

=== "Verification"

    ```
    r2 tping 100 15 1.1.1.1 vrf v1
    r2 tping 100 15 1234::1 vrf v1
    r2 tping 100 15 www.test.corp vrf v1
    r1 tping 100 15 www.test.corp vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [serv-dns03](../clab/serv-dns03/serv-dns03.yml) file  
        3. Launch ContainerLab `serv-dns03.yml` topology:  

        ```
           containerlab deploy --topo serv-dns03.yml  
        ```
        4. Destroy ContainerLab `serv-dns03.yml` topology:  

        ```
           containerlab destroy --topo serv-dns03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `serv-dns03.tst` file [here](../tst/serv-dns03.tst)  
        3. Launch `serv-dns03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester serv-dns03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `serv-dns03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

