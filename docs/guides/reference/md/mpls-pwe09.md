# Example: ethernet over mpls

=== "Topology"

    ![Alt text](../d2/mpls-pwe09/mpls-pwe09.svg)

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
    r1 output show mpls forw
    r1 output show ipv4 ldp v1 sum
    r1 output show ipv6 ldp v1 sum
    r1 output show bridge 1
    r1 output show inter bvi1 full
    r1 output show ipv4 arp bvi1
    r1 output show ipv6 neigh bvi1
    output ../binTmp/mpls-pwe.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the lib:
    here is the ipv4 neighbor:
    here is the ipv6 neighbor:
    here is the ipv4 bridge:
    here is the interface:
    here is the arp:
    here are the neighbors:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-pwe09](../clab/mpls-pwe09/mpls-pwe09.yml) file  
        3. Launch ContainerLab `mpls-pwe09.yml` topology:  

        ```
           containerlab deploy --topo mpls-pwe09.yml  
        ```
        4. Destroy ContainerLab `mpls-pwe09.yml` topology:  

        ```
           containerlab destroy --topo mpls-pwe09.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-pwe09.tst` file [here](../tst/mpls-pwe09.tst)  
        3. Launch `mpls-pwe09.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-pwe09 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-pwe09.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

