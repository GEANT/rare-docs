# Example: interop9: pppoe client

=== "Topology"

    ![Alt text](../d2/intop9-pppoe01/intop9-pppoe01.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int di1
     enc ppp
     ppp ip4cp open
     ppp ip6cp open
     ppp ip4cp local 1.1.1.1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff:ffff:ffff:ffff::
     exit
    int eth1
     p2poe client di1
     exit
    ```

    **r2**

    ```
    hostname r2
    set interfaces ge-0/0/0.0 encapsulation ppp-over-ether
    set interfaces pp0.0 pppoe-options underlying-interface ge-0/0/0.0
    set interfaces pp0.0 pppoe-options server
    set interfaces pp0.0 family inet address 1.1.1.2/24
    set interfaces pp0.0 family inet6 address 1234::2/64
    ```

=== "Verification"

    ```
    r1 tping 100 30 1.1.1.2 vrf v1
    !r1 tping 100 30 1234::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop9-pppoe01](../clab/intop9-pppoe01/intop9-pppoe01.yml) file  
        3. Launch ContainerLab `intop9-pppoe01.yml` topology:  

        ```
           containerlab deploy --topo intop9-pppoe01.yml  
        ```
        4. Destroy ContainerLab `intop9-pppoe01.yml` topology:  

        ```
           containerlab destroy --topo intop9-pppoe01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop9-pppoe01.tst` file [here](../tst/intop9-pppoe01.tst)  
        3. Launch `intop9-pppoe01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop9-pppoe01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop9-pppoe01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

