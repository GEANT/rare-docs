# Example: bridge mac enforcement

=== "Topology"

    ![Alt text](../d2/conn-frag15/conn-frag15.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    bridge 1
     exit
    int eth1
     enforce-mac
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
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
     ipv4 host-static 1.1.1.3 0000.0000.4321
     ipv6 host-static 1234::3 0000.0000.4321
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.3
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::3
    ```

=== "Verification"

    ```
    r1 tping 100 5 1.1.1.2 vrf v1
    r2 tping 100 5 1.1.1.1 vrf v1
    r1 tping 100 5 1234::2 vrf v1
    r2 tping 100 5 1234::1 vrf v1
    r2 tping 100 5 2.2.2.1 vrf v1
    r2 tping 100 5 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-frag15](../clab/conn-frag15/conn-frag15.yml) file  
        3. Launch ContainerLab `conn-frag15.yml` topology:  

        ```
           containerlab deploy --topo conn-frag15.yml  
        ```
        4. Destroy ContainerLab `conn-frag15.yml` topology:  

        ```
           containerlab destroy --topo conn-frag15.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-frag15.tst` file [here](../tst/conn-frag15.tst)  
        3. Launch `conn-frag15.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-frag15 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-frag15.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

