# Example: nsh ip

=== "Topology"

    ![Alt text](../d2/mpls-nsh12/mpls-nsh12.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    access-list test4
     sequence 10 permit all 1.1.1.1 255.255.255.255 all any all
     exit
    access-list test6
     sequence 10 permit all 1111::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all any all
     exit
    int lo1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1111::1 ffff:ffff::
     exit
    int eth1
     nsh ena
     exit
    ipv4 pbr v1 sequence 10 test4 v1 nsh 2 255
    ipv6 pbr v1 sequence 10 test6 v1 nsh 2 255
    nsh 2 255 int eth1 0000.1111.2222
    nsh 3 253 route v1
    ```

    **r2**

    ```
    hostname r2
    int eth1
     nsh ena
     exit
    int eth2
     nsh ena
     exit
    nsh 3 254 int eth1 0000.1111.2222
    nsh 2 254 int eth2 0000.1111.2222
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    access-list test4
     sequence 10 permit all 1.1.1.2 255.255.255.255 all any all
     exit
    access-list test6
     sequence 10 permit all 1111::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all any all
     exit
    int lo1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1111::2 ffff:ffff::
     exit
    int eth1
     nsh ena
     exit
    ipv4 pbr v1 sequence 10 test4 v1 nsh 3 255
    ipv6 pbr v1 sequence 10 test6 v1 nsh 3 255
    nsh 3 255 int eth1 0000.1111.2222
    nsh 2 253 route v1
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1111::2 vrf v1
    r3 tping 100 10 1.1.1.1 vrf v1
    r3 tping 100 10 1111::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-nsh12](../clab/mpls-nsh12/mpls-nsh12.yml) file  
        3. Launch ContainerLab `mpls-nsh12.yml` topology:  

        ```
           containerlab deploy --topo mpls-nsh12.yml  
        ```
        4. Destroy ContainerLab `mpls-nsh12.yml` topology:  

        ```
           containerlab destroy --topo mpls-nsh12.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-nsh12.tst` file [here](../tst/mpls-nsh12.tst)  
        3. Launch `mpls-nsh12.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-nsh12 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-nsh12.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

