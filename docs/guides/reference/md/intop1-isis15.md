# Example: interop1: isis md5 authentication

=== "Topology"

    ![Alt text](../d2/intop1-isis15/intop1-isis15.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router isis4 1
     vrf v1
     net 48.4444.0000.1111.00
     red conn
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.1111.00
     red conn
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     router isis4 1 ena
     router isis4 1 password tester
     router isis4 1 authen-type md5
     exit
    int eth2
     vrf for v1
     ipv6 addr fe80::1 ffff::
     router isis6 1 ena
     router isis6 1 password tester
     router isis6 1 authen-type md5
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
    ip routing
    ipv6 unicast-routing
    interface loopback0
     ip addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2/128
     exit
    router isis
     net 48.0000.0000.1234.00
     metric-style wide
     redistribute connected
     address-family ipv6
      redistribute connected
     exit
    key chain kc
     key 0
      key-string tester
     exit
    interface gigabit1
     ip address 1.1.1.2 255.255.255.0
     isis network point-to-point
     isis authentication key-chain kc
     isis authentication mode md5
     ip router isis
     no shutdown
     exit
    interface gigabit2
     ipv6 enable
     isis network point-to-point
     isis authentication key-chain kc
     isis authentication mode md5
     ipv6 router isis
     no shutdown
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-isis15](../clab/intop1-isis15/intop1-isis15.yml) file  
        3. Launch ContainerLab `intop1-isis15.yml` topology:  

        ```
           containerlab deploy --topo intop1-isis15.yml  
        ```
        4. Destroy ContainerLab `intop1-isis15.yml` topology:  

        ```
           containerlab destroy --topo intop1-isis15.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-isis15.tst` file [here](../tst/intop1-isis15.tst)  
        3. Launch `intop1-isis15.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-isis15 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-isis15.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

