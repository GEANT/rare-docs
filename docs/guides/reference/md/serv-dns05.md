# Example: secondary dns server

=== "Topology"

    ![Alt text](../d2/serv-dns05/serv-dns05.svg)

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
     rr test.corp soa ns.test.corp admin.test.corp 20100101 600 600 600000 30
     rr ip4a.test.corp ip4a 1.1.1.1
     rr ip6a.test.corp ip6a 1234::1
     rr ip4i.test.corp ip4i eth1
     rr ip6i.test.corp ip6i eth1
     vrf v1
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
    server dns dns
     zone test.corp defttl 43200
     vrf v1
     exit
    proxy-profile p1
     vrf v1
     source ethernet1
     exit
    client proxy p1
    client name-server 1.1.1.2
    ```

=== "Verification"

    ```
    r2 tping 100 15 1.1.1.1 vrf v1
    r2 send conf t
    r2 send server dns dns
    r2 send zone test.corp redownload p1 1.1.1.1
    r2 send exit
    r2 send end
    r2 tping 100 15 ip4a.test.corp vrf v1
    r2 tping 100 15 ip6a.test.corp vrf v1
    r2 tping 100 15 ip4i.test.corp vrf v1
    r2 tping 100 15 ip6i.test.corp vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [serv-dns05](../clab/serv-dns05/serv-dns05.yml) file  
        3. Launch ContainerLab `serv-dns05.yml` topology:  

        ```
           containerlab deploy --topo serv-dns05.yml  
        ```
        4. Destroy ContainerLab `serv-dns05.yml` topology:  

        ```
           containerlab destroy --topo serv-dns05.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `serv-dns05.tst` file [here](../tst/serv-dns05.tst)  
        3. Launch `serv-dns05.tst` test:  

        ```
           java -jar ../../rtr.jar test tester serv-dns05 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `serv-dns05.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

