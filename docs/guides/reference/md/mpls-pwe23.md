# Example: ethernet over mpls with cw

=== "Topology"

    ![Alt text](../d2/mpls-pwe23/mpls-pwe23.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    proxy-profile p1
     vrf v1
     source lo0
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.2 255.255.255.255 1.1.1.2
    ipv6 route v1 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::2
    bridge 1
     mac-learn
     exit
    int bvi1
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     exit
    vpdn eompls
     bridge-gr 1
     proxy p1
     target 2.2.2.2
     mtu 1500
     vcid 1234
     control
     pwtype eth
     protocol pweompls
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    proxy-profile p1
     vrf v1
     source lo0
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     mpls enable
     mpls ldp4
     mpls ldp6
     exit
    ipv4 route v1 2.2.2.1 255.255.255.255 1.1.1.1
    ipv6 route v1 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff 1234::1
    bridge 1
     mac-learn
     exit
    int bvi1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     exit
    vpdn eompls
     bridge-gr 1
     proxy p1
     target 2.2.2.1
     mtu 1500
     vcid 1234
     control
     pwtype eth
     protocol pweompls
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 10 4321::2 vrf v1 sou lo0
    r2 tping 100 10 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 10 4321::1 vrf v1 sou lo0
    r1 tping 100 40 3.3.3.2 vrf v1
    r2 tping 100 40 3.3.3.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-pwe23](../clab/mpls-pwe23/mpls-pwe23.yml) file  
        3. Launch ContainerLab `mpls-pwe23.yml` topology:  

        ```
           containerlab deploy --topo mpls-pwe23.yml  
        ```
        4. Destroy ContainerLab `mpls-pwe23.yml` topology:  

        ```
           containerlab destroy --topo mpls-pwe23.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-pwe23.tst` file [here](../tst/mpls-pwe23.tst)  
        3. Launch `mpls-pwe23.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-pwe23 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-pwe23.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

