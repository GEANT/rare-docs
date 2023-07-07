# Example: interop9: isis text authentication

=== "Topology"

    ![Alt text](../d2/intop9-isis13/intop9-isis13.svg)

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
     exit
    int eth2
     vrf for v1
     ipv6 addr fe80::1 ffff::
     router isis6 1 ena
     router isis6 1 password tester
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
    set interfaces ge-0/0/0.0 family inet address 1.1.1.2/24
    set interfaces ge-0/0/0.0 family iso
    set interfaces ge-0/0/1.0 family inet6
    set interfaces ge-0/0/1.0 family iso
    set interfaces lo0.0 family inet address 2.2.2.2/32
    set interfaces lo0.0 family inet6 address 4321::2/128
    set interfaces lo0.0 family iso address 48.0000.0000.1234.00
    set protocols isis interface ge-0/0/0.0 level 1 hello-authentication-key tester
    set protocols isis interface ge-0/0/0.0 level 2 hello-authentication-key tester
    set protocols isis interface ge-0/0/1.0 level 1 hello-authentication-key tester
    set protocols isis interface ge-0/0/1.0 level 2 hello-authentication-key tester
    set protocols isis interface ge-0/0/0.0 level 1 hello-authentication-type simple
    set protocols isis interface ge-0/0/0.0 level 2 hello-authentication-type simple
    set protocols isis interface ge-0/0/1.0 level 1 hello-authentication-type simple
    set protocols isis interface ge-0/0/1.0 level 2 hello-authentication-type simple
    set protocols isis interface ge-0/0/0.0 point-to-point
    set protocols isis interface ge-0/0/1.0 point-to-point
    set protocols isis interface lo0.0
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
        2. Fetch [intop9-isis13](../clab/intop9-isis13/intop9-isis13.yml) file  
        3. Launch ContainerLab `intop9-isis13.yml` topology:  

        ```
           containerlab deploy --topo intop9-isis13.yml  
        ```
        4. Destroy ContainerLab `intop9-isis13.yml` topology:  

        ```
           containerlab destroy --topo intop9-isis13.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop9-isis13.tst` file [here](../tst/intop9-isis13.tst)  
        3. Launch `intop9-isis13.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop9-isis13 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop9-isis13.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

