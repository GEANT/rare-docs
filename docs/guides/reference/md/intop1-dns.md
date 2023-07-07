# Example: interop1: dns

=== "Topology"

    ![Alt text](../d2/intop1-dns/intop1-dns.svg)

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
     rr ip4.test.corp ip4a 2.2.2.2
     rr ip6.test.corp ip6a 1234::1
     vrf v1
     exit
    int lo1
     vrf for v1
     ipv4 addr 4.4.4.4 255.255.255.255
     exit
    server tel tel
     vrf v1
     security protocol tel
     exit
    ```

    **r2**

    ```
    hostname r2
    ip routing
    ipv6 unicast-routing
    interface gigabit1
     ip address 1.1.1.2 255.255.255.0
     ipv6 address 1234::2/64
     no shutdown
     exit
    interface gigabit2
     ip address 2.2.2.1 255.255.255.0
     ipv6 address 4321::1/64
     no shutdown
     exit
    ip name-server 1.1.1.1
    ip domain lookup
    line vty 0 4
     transport input all
     transport output all
     no motd-banner
     no exec-banner
     no vacant-message
     no login
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
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    int lo1
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.255
     exit
    server tel tel
     vrf v1
     security protocol tel
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234::2 vrf v1
    r3 tping 100 10 2.2.2.1 vrf v1
    r3 tping 100 10 4321::1 vrf v1
    r1 send telnet 1.1.1.2 vrf v1 telnet
    sleep 3000
    r1 char 13
    r1 read vxe#
    r1 send telnet ip4.test.corp /ipv4
    sleep 3000
    r1 tping 100 10 3.3.3.3 vrf v1
    r3 send telnet 2.2.2.1 vrf v1 telnet
    sleep 3000
    r3 char 13
    r3 read vxe#
    r3 send telnet ip6.test.corp /ipv6
    sleep 3000
    r3 tping 100 10 4.4.4.4 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-dns](../clab/intop1-dns/intop1-dns.yml) file  
        3. Launch ContainerLab `intop1-dns.yml` topology:  

        ```
           containerlab deploy --topo intop1-dns.yml  
        ```
        4. Destroy ContainerLab `intop1-dns.yml` topology:  

        ```
           containerlab destroy --topo intop1-dns.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-dns.tst` file [here](../tst/intop1-dns.tst)  
        3. Launch `intop1-dns.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-dns path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-dns.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

