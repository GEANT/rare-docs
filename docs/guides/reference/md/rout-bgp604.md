# Example: bgp routepolicy filtering with unknown attribute

=== "Topology"

    ![Alt text](../d2/rout-bgp604/rout-bgp604.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    bridge 1
     mac-learn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int eth3
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 1
     neigh 1.1.1.2 route-reflect
     neigh 1.1.1.2 unknowns-in all
     neigh 1.1.1.2 unknowns-out all
     neigh 1.1.1.3 remote-as 1
     neigh 1.1.1.3 route-reflect
     neigh 1.1.1.3 unknowns-in all
     neigh 1.1.1.3 unknowns-out all
     neigh 1.1.1.4 remote-as 1
     neigh 1.1.1.4 route-reflect
     neigh 1.1.1.4 unknowns-in all
     neigh 1.1.1.4 unknowns-out all
     red conn
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.1
     neigh 1234::2 remote-as 1
     neigh 1234::2 route-reflect
     neigh 1234::2 unknowns-in all
     neigh 1234::2 unknowns-out all
     neigh 1234::3 remote-as 1
     neigh 1234::3 route-reflect
     neigh 1234::3 unknowns-in all
     neigh 1234::3 unknowns-out all
     neigh 1234::4 remote-as 1
     neigh 1234::4 route-reflect
     neigh 1234::4 unknowns-in all
     neigh 1234::4 unknowns-out all
     red conn
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
     ipv6 addr 1234::2 ffff:ffff::
     exit
    route-map all
     action permit
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv6 addr 1234::3 ffff:ffff::
     exit
    route-policy rm1
     if unknown 2
      drop
     else
      pass
     enif
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.3
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 route-policy-in rm1
     neigh 1.1.1.1 unknowns-in all
     neigh 1.1.1.1 unknowns-out all
     red conn
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.3
     neigh 1234::1 remote-as 1
     neigh 1234::1 route-policy-in rm1
     neigh 1234::1 unknowns-in all
     neigh 1234::1 unknowns-out all
     red conn
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.4 255.255.255.255
     ipv6 addr 4321::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.4 255.255.255.0
     ipv6 addr 1234::4 ffff:ffff::
     exit
    route-map all
     action permit
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 60 1.1.1.1 vrf v1
    r2 send pack bgpattr v1 eth1 1.1.1.1 1 2.2.2.2/32 all 255 4 3 2 1 2 3 4 , 0 1 2 3 2 1
    r2 read wait
    r4 tping 100 60 1234::1 vrf v1
    r4 send pack bgpattr v1 eth1 1234::1 1 4321::4/128 all 255 4 3 2 1 2 3 4 , 0 1 2 3 2 1
    r4 read wait
    r1 tping 100 60 2.2.2.3 vrf v1
    r1 tping 100 60 4321::3 vrf v1
    r1 tping 100 60 2.2.2.2 vrf v1
    r1 tping 0 60 4321::2 vrf v1
    r1 tping 0 60 2.2.2.4 vrf v1
    r1 tping 100 60 4321::4 vrf v1
    r3 tping 100 60 2.2.2.1 vrf v1
    r3 tping 100 60 4321::1 vrf v1
    r3 tping 0 60 2.2.2.2 vrf v1
    r3 tping 0 60 4321::2 vrf v1
    r3 tping 0 60 2.2.2.4 vrf v1
    r3 tping 0 60 4321::4 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp604](../clab/rout-bgp604/rout-bgp604.yml) file  
        3. Launch ContainerLab `rout-bgp604.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp604.yml  
        ```
        4. Destroy ContainerLab `rout-bgp604.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp604.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp604.tst` file [here](../tst/rout-bgp604.tst)  
        3. Launch `rout-bgp604.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp604 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp604.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

