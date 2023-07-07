# Example: ocar over srv6 over confed bgp

=== "Topology"

    ![Alt text](../d2/rout-bgp732/rout-bgp732.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    int tun1
     vrf for v1
     ipv6 addr 4321:1:: ffff:ffff::
     tun sour eth1
     tun dest 4321:1::
     tun vrf v1
     tun mod srv6
     exit
    ipv6 route v1 4321:2:: ffff:ffff:: 1234::2
    router bgp4 1
     vrf v1
     no safe-ebgp
     address ocar
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.3 remote-as 3
     neigh 1.1.1.3 segrou
     afi-other ena
     afi-other red conn
     afi-other srv6 tun1
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address ocar
     local-as 1
     router-id 6.6.6.1
     neigh 1234::3 remote-as 3
     neigh 1234::3 segrou
     afi-other ena
     afi-other red conn
     afi-other srv6 tun1
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int tun1
     vrf for v1
     ipv6 addr 4321:2:: ffff:ffff::
     tun sour eth1
     tun dest 4321:2::
     tun vrf v1
     tun mod srv6
     exit
    ipv6 route v1 4321:1:: ffff:ffff:: 1234::1
    router bgp4 1
     vrf v1
     no safe-ebgp
     address ocar
     local-as 2
     router-id 4.4.4.2
     neigh 1.1.1.3 remote-as 3
     neigh 1.1.1.3 segrou
     afi-other ena
     afi-other red conn
     afi-other srv6 tun1
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address ocar
     local-as 2
     router-id 6.6.6.2
     neigh 1234::3 remote-as 3
     neigh 1234::3 segrou
     afi-other ena
     afi-other red conn
     afi-other srv6 tun1
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    bridge 1
     mac-learn
     exit
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     no safe-ebgp
     address ocar
     local-as 3
     router-id 4.4.4.3
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 segrou
     neigh 1.1.1.1 confed
     neigh 1.1.1.2 remote-as 2
     neigh 1.1.1.2 segrou
     neigh 1.1.1.2 confed
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address ocar
     local-as 3
     router-id 4.4.4.3
     neigh 1234::1 remote-as 1
     neigh 1234::1 segrou
     neigh 1234::1 confed
     neigh 1234::2 remote-as 2
     neigh 1234::2 segrou
     neigh 1234::2 confed
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1 sou lo0
    r1 tping 100 60 4321::2 vrf v1 sou lo0
    r2 tping 100 60 2.2.2.1 vrf v1 sou lo0
    r2 tping 100 60 4321::1 vrf v1 sou lo0
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp732](../clab/rout-bgp732/rout-bgp732.yml) file  
        3. Launch ContainerLab `rout-bgp732.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp732.yml  
        ```
        4. Destroy ContainerLab `rout-bgp732.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp732.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp732.tst` file [here](../tst/rout-bgp732.tst)  
        3. Launch `rout-bgp732.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp732 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp732.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

