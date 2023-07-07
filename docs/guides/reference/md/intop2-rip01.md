# Example: interop2: rip

=== "Topology"

    ![Alt text](../d2/intop2-rip01/intop2-rip01.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    router rip4 1
     vrf v1
     red conn
     exit
    router rip6 1
     vrf v1
     red conn
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr fe80::1 ffff::
     router rip4 1 ena
     router rip6 1 ena
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
    interface gigabit0/0/0/0
     ipv4 address 1.1.1.2 255.255.255.0
     ipv6 address fe80::2 link-local
     no shutdown
     exit
    interface loopback0
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2/128
     exit
    route-policy a
     set rip-metric 5
     pass
    router rip
     redistribute connected route-policy a
     interface gigabit0/0/0/0
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 120 2.2.2.2 vrf v1 sou lo0
    !r1 tping 100 120 4321::2 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop2-rip01](../clab/intop2-rip01/intop2-rip01.yml) file  
        3. Launch ContainerLab `intop2-rip01.yml` topology:  

        ```
           containerlab deploy --topo intop2-rip01.yml  
        ```
        4. Destroy ContainerLab `intop2-rip01.yml` topology:  

        ```
           containerlab destroy --topo intop2-rip01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop2-rip01.tst` file [here](../tst/intop2-rip01.tst)  
        3. Launch `intop2-rip01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop2-rip01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop2-rip01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

