# Example: interop9: bgp authentication

=== "Topology"

    ![Alt text](../d2/intop9-bgp12/intop9-bgp12.svg)

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
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 1
     neigh 1.1.1.2 password tester
     red conn
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.1
     neigh 1234::2 remote-as 1
     neigh 1234::2 password tester
     red conn
     exit
    ```

    **r2**

    ```
    hostname r2
    set interfaces ge-0/0/0.0 family inet address 1.1.1.2/24
    set interfaces ge-0/0/0.0 family inet6 address 1234::2/64
    set interfaces lo0.0 family inet address 2.2.2.2/32
    set interfaces lo0.0 family inet6 address 4321::2/128
    set routing-options autonomous-system 1
    set policy-options policy-statement ps1 from protocol direct
    set policy-options policy-statement ps1 then accept
    set protocols bgp export ps1
    set protocols bgp group peers type internal
    set protocols bgp group peers peer-as 1
    set protocols bgp group peers authentication-key tester
    set protocols bgp group peers neighbor 1.1.1.1
    set protocols bgp group peers neighbor 1234::1
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234::2 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop9-bgp12](../clab/intop9-bgp12/intop9-bgp12.yml) file  
        3. Launch ContainerLab `intop9-bgp12.yml` topology:  

        ```
           containerlab deploy --topo intop9-bgp12.yml  
        ```
        4. Destroy ContainerLab `intop9-bgp12.yml` topology:  

        ```
           containerlab destroy --topo intop9-bgp12.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop9-bgp12.tst` file [here](../tst/intop9-bgp12.tst)  
        3. Launch `intop9-bgp12.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop9-bgp12 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop9-bgp12.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

