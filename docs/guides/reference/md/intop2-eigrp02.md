# Example: interop2: eigrp prefix withdraw

=== "Topology"

    ![Alt text](../d2/intop2-eigrp02/intop2-eigrp02.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router eigrp4 1
     vrf v1
     router 4.4.4.1
     as 1
     red conn
     exit
    router eigrp6 1
     vrf v1
     router 6.6.6.1
     as 1
     red conn
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr fe80::1 ffff::
     router eigrp4 1 ena
     router eigrp6 1 ena
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    ```

    **r2**

    ```
    hostname r2
    interface loopback0
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2/128
     exit
    interface gigabit0/0/0/0
     ipv4 address 1.1.1.2 255.255.255.0
     ipv6 address 1234::2/64
     no shutdown
     exit
    route-policy all
     set eigrp-metric 1000 1 255 1 1500
     pass
     end-policy
    router eigrp 1
     address-family ipv4
      redistribute connected route-policy all
      interface gigabit0/0/0/0
     address-family ipv6
      redistribute connected route-policy all
      interface gigabit0/0/0/0
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234::2 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r1 send conf t
    r1 send router eigrp4 1
    r1 send no red conn
    r1 send exit
    r1 send router eigrp6 1
    r1 send no red conn
    r1 send end
    r1 tping 0 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 0 60 4321::2 vrf v1 sou lo0
    r1 send conf t
    r1 send router eigrp4 1
    r1 send red conn
    r1 send exit
    r1 send router eigrp6 1
    r1 send red conn
    r1 send end
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop2-eigrp02](../clab/intop2-eigrp02/intop2-eigrp02.yml) file  
        3. Launch ContainerLab `intop2-eigrp02.yml` topology:  

        ```
           containerlab deploy --topo intop2-eigrp02.yml  
        ```
        4. Destroy ContainerLab `intop2-eigrp02.yml` topology:  

        ```
           containerlab destroy --topo intop2-eigrp02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop2-eigrp02.tst` file [here](../tst/intop2-eigrp02.tst)  
        3. Launch `intop2-eigrp02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop2-eigrp02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop2-eigrp02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

