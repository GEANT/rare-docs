# Example: multipoint ethernet over vxlan

=== "Topology"

    ![Alt text](../d2/conn-vxlan14/conn-vxlan14.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     ipv6 addr 1234:1::1 ffff:ffff::
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.1.5 255.255.255.252
     ipv6 addr 1234:2::1 ffff:ffff::
     exit
    bridge 1
     mac-learn
     exit
    int eth3
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff:ffff::
     exit
    server vxlan vxl
     bridge 1
     vrf v1
     inst 1234
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     ipv6 addr 1234:1::2 ffff:ffff::
     exit
    bridge 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff:ffff::
     exit
    vpdn vxl
     bridge-gr 1
     proxy p1
     tar 1.1.1.1
     vcid 1234
     prot vxlan
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.6 255.255.255.252
     ipv6 addr 1234:2::2 ffff:ffff::
     exit
    bridge 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.0
     ipv6 addr 4321::3 ffff:ffff::
     exit
    vpdn vxl
     bridge-gr 1
     proxy p1
     tar 1234:2::1
     vcid 1234
     prot vxlan
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.0
     ipv6 addr 4321::4 ffff:ffff::
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 60 2.2.2.1 vrf v1
    r2 tping 100 60 2.2.2.4 vrf v1
    r2 tping 100 60 4321::1 vrf v1
    r2 tping 100 60 4321::4 vrf v1
    r3 tping 100 60 2.2.2.1 vrf v1
    r3 tping 100 60 2.2.2.4 vrf v1
    r3 tping 100 60 4321::1 vrf v1
    r3 tping 100 60 4321::4 vrf v1
    r1 tping 100 60 2.2.2.4 vrf v1
    r1 tping 100 60 2.2.2.3 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1
    r1 tping 100 60 4321::4 vrf v1
    r1 tping 100 60 4321::3 vrf v1
    r1 tping 100 60 4321::2 vrf v1
    r2 tping 0 60 2.2.2.3 vrf v1
    r2 tping 0 60 4321::3 vrf v1
    r3 tping 0 60 2.2.2.2 vrf v1
    r3 tping 0 60 4321::2 vrf v1
    r4 tping 100 60 2.2.2.3 vrf v1
    r4 tping 100 60 2.2.2.2 vrf v1
    r4 tping 100 60 2.2.2.1 vrf v1
    r4 tping 100 60 4321::3 vrf v1
    r4 tping 100 60 4321::2 vrf v1
    r4 tping 100 60 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-vxlan14](../clab/conn-vxlan14/conn-vxlan14.yml) file  
        3. Launch ContainerLab `conn-vxlan14.yml` topology:  

        ```
           containerlab deploy --topo conn-vxlan14.yml  
        ```
        4. Destroy ContainerLab `conn-vxlan14.yml` topology:  

        ```
           containerlab destroy --topo conn-vxlan14.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-vxlan14.tst` file [here](../tst/conn-vxlan14.tst)  
        3. Launch `conn-vxlan14.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-vxlan14 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-vxlan14.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

