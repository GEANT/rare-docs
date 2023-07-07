# Example: dynamic tunnel destination

=== "Topology"

    ![Alt text](../d2/serv-dyndest/serv-dyndest.svg)

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
    int tun1
     tunnel vrf v1
     tunnel mode gre
     tunnel source ethernet1
     tunnel destination 1.1.1.2
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
     exit
    server dns dns
     zone test.corp defttl 43200
     rr www.test.corp ip4a 1.1.1.1
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
    int tun1
     tunnel vrf v1
     tunnel mode gre
     tunnel source ethernet1
     tunnel destination 1.1.1.123
     tunnel domain-name www.test.corp
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
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
    r2 tping 100 15 www.test.corp vrf v1
    r2 tping 0 5 2.2.2.1
    r2 send clear tunnel-domain
    r2 tping 100 15 2.2.2.1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [serv-dyndest](../clab/serv-dyndest/serv-dyndest.yml) file  
        3. Launch ContainerLab `serv-dyndest.yml` topology:  

        ```
           containerlab deploy --topo serv-dyndest.yml  
        ```
        4. Destroy ContainerLab `serv-dyndest.yml` topology:  

        ```
           containerlab destroy --topo serv-dyndest.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `serv-dyndest.tst` file [here](../tst/serv-dyndest.tst)  
        3. Launch `serv-dyndest.tst` test:  

        ```
           java -jar ../../rtr.jar test tester serv-dyndest path ./ temp ./ wait
        ```
        4. Destroy freeRtr `serv-dyndest.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

