# Example: bgp change in validity with soft-reconfig

=== "Topology"

    ![Alt text](../d2/rout-bgp785/rout-bgp785.svg)

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
     ipv6 addr 1234:1::1 ffff:ffff::
     exit
    router bgp4 1
     vrf v1
     address uni
     local-as 1
     router-id 4.4.4.1
     neigh 1.1.1.2 remote-as 1
     neigh 1.1.1.2 soft-reconfig
     neigh 1.1.1.2 send-comm both
     neigh 1.1.1.2 route-reflect
     neigh 1.1.1.3 remote-as 1
     neigh 1.1.1.3 soft-reconfig
     neigh 1.1.1.3 send-comm both
     neigh 1.1.1.3 route-reflect
     neigh 1.1.1.4 remote-as 1
     neigh 1.1.1.4 soft-reconfig
     neigh 1.1.1.4 send-comm both
     neigh 1.1.1.4 route-reflect
     red conn
     exit
    router bgp6 1
     vrf v1
     address uni
     local-as 1
     router-id 6.6.6.1
     neigh 1234:1::2 remote-as 1
     neigh 1234:1::2 soft-reconfig
     neigh 1234:1::2 send-comm both
     neigh 1234:1::2 route-reflect
     neigh 1234:1::3 remote-as 1
     neigh 1234:1::3 soft-reconfig
     neigh 1234:1::3 send-comm both
     neigh 1234:1::3 route-reflect
     neigh 1234:1::4 remote-as 1
     neigh 1234:1::4 soft-reconfig
     neigh 1234:1::4 send-comm both
     neigh 1234:1::4 route-reflect
     red conn
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    bridge 1
     mac-learn
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234:1::2 ffff:ffff::
     exit
    route-map rm1
     sequence 10 act deny
     sequence 10 match validity 3
     sequence 20 act perm
     exit
    router rpki4 1 vrf v1
     exit
    router bgp4 1
     vrf v1
     rpki rpki4 1
     address uni
     local-as 1
     router-id 4.4.4.2
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 soft-reconfig
     neigh 1.1.1.1 send-comm both
     neigh 1.1.1.1 rpki-in acc
     neigh 1.1.1.1 route-map-in rm1
     red conn
     exit
    router bgp6 1
     vrf v1
     rpki rpki4 1
     address uni
     local-as 1
     router-id 6.6.6.2
     neigh 1234:1::1 remote-as 1
     neigh 1234:1::1 soft-reconfig
     neigh 1234:1::1 send-comm both
     neigh 1234:1::1 rpki-in acc
     neigh 1234:1::1 route-map-in rm1
     red conn
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
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.255
     ipv6 addr 4321::3 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
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
     ipv6 addr 1234:1::3 ffff:ffff::
     exit
    route-map rm1
     set validity 1
     exit
    router rpki4 1 vrf v1
     exit
    router bgp4 1
     vrf v1
     rpki rpki4 1
     address uni
     local-as 1
     router-id 4.4.4.3
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 soft-reconfig
     neigh 1.1.1.1 send-comm both
     neigh 1.1.1.1 rpki-out rew
     neigh 1.1.1.1 route-map-out rm1
     red conn
     exit
    router bgp6 1
     vrf v1
     rpki rpki4 1
     address uni
     local-as 1
     router-id 6.6.6.3
     neigh 1234:1::1 remote-as 1
     neigh 1234:1::1 soft-reconfig
     neigh 1234:1::1 send-comm both
     neigh 1234:1::1 rpki-out rew
     neigh 1234:1::1 route-map-out rm1
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
     ipv6 addr 1234:1::4 ffff:ffff::
     exit
    route-map rm1
     sequence 10 act deny
     sequence 10 match validity 2
     sequence 20 act perm
     exit
    router rpki4 1 vrf v1
     exit
    router bgp4 1
     vrf v1
     rpki rpki4 1
     address uni
     local-as 1
     router-id 4.4.4.4
     neigh 1.1.1.1 remote-as 1
     neigh 1.1.1.1 soft-reconfig
     neigh 1.1.1.1 send-comm both
     neigh 1.1.1.1 rpki-in acc
     neigh 1.1.1.1 route-map-in rm1
     red conn
     exit
    router bgp6 1
     vrf v1
     rpki rpki4 1
     address uni
     local-as 1
     router-id 6.6.6.4
     neigh 1234:1::1 remote-as 1
     neigh 1234:1::1 soft-reconfig
     neigh 1234:1::1 send-comm both
     neigh 1234:1::1 rpki-in acc
     neigh 1234:1::1 route-map-in rm1
     red conn
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 2.2.2.2 vrf v1
    r1 tping 100 60 4321::2 vrf v1
    r1 tping 100 60 2.2.2.3 vrf v1
    r1 tping 100 60 4321::3 vrf v1
    r1 tping 100 60 2.2.2.4 vrf v1
    r1 tping 100 60 4321::4 vrf v1
    r2 tping 100 60 2.2.2.1 vrf v1
    r2 tping 100 60 4321::1 vrf v1
    r2 tping 100 60 2.2.2.3 vrf v1
    r2 tping 100 60 4321::3 vrf v1
    r2 tping 100 60 2.2.2.4 vrf v1
    r2 tping 100 60 4321::4 vrf v1
    r3 tping 100 60 2.2.2.1 vrf v1
    r3 tping 100 60 4321::1 vrf v1
    r3 tping 100 60 2.2.2.2 vrf v1
    r3 tping 100 60 4321::2 vrf v1
    r3 tping 100 60 2.2.2.4 vrf v1
    r3 tping 100 60 4321::4 vrf v1
    r4 tping 100 60 2.2.2.1 vrf v1
    r4 tping 100 60 4321::1 vrf v1
    r4 tping 100 60 2.2.2.2 vrf v1
    r4 tping 100 60 4321::2 vrf v1
    r4 tping 100 60 2.2.2.3 vrf v1
    r4 tping 100 60 4321::3 vrf v1
    r3 send conf t
    r3 send route-map rm1
    r3 send set validity 2
    r3 send end
    r3 send clear ipv4 route v1
    r3 send clear ipv6 route v1
    r1 tping 100 60 2.2.2.2 vrf v1
    r1 tping 100 60 4321::2 vrf v1
    r1 tping 100 60 2.2.2.3 vrf v1
    r1 tping 100 60 4321::3 vrf v1
    r1 tping 100 60 2.2.2.4 vrf v1
    r1 tping 100 60 4321::4 vrf v1
    r2 tping 100 60 2.2.2.1 vrf v1
    r2 tping 100 60 4321::1 vrf v1
    r2 tping 100 60 2.2.2.3 vrf v1
    r2 tping 100 60 4321::3 vrf v1
    r2 tping 100 60 2.2.2.4 vrf v1
    r2 tping 100 60 4321::4 vrf v1
    r3 tping 100 60 2.2.2.1 vrf v1
    r3 tping 100 60 4321::1 vrf v1
    r3 tping 100 60 2.2.2.2 vrf v1
    r3 tping 100 60 4321::2 vrf v1
    r3 tping 100 60 2.2.2.4 vrf v1
    r3 tping 100 60 4321::4 vrf v1
    r4 tping 100 60 2.2.2.1 vrf v1
    r4 tping 100 60 4321::1 vrf v1
    r4 tping 100 60 2.2.2.2 vrf v1
    r4 tping 100 60 4321::2 vrf v1
    r4 tping 0 60 2.2.2.3 vrf v1
    r4 tping 0 60 4321::3 vrf v1
    r3 send conf t
    r3 send route-map rm1
    r3 send set validity 3
    r3 send end
    r3 send clear ipv4 route v1
    r3 send clear ipv6 route v1
    r1 tping 100 60 2.2.2.2 vrf v1
    r1 tping 100 60 4321::2 vrf v1
    r1 tping 100 60 2.2.2.3 vrf v1
    r1 tping 100 60 4321::3 vrf v1
    r1 tping 100 60 2.2.2.4 vrf v1
    r1 tping 100 60 4321::4 vrf v1
    r2 tping 100 60 2.2.2.1 vrf v1
    r2 tping 100 60 4321::1 vrf v1
    r2 tping 0 60 2.2.2.3 vrf v1
    r2 tping 0 60 4321::3 vrf v1
    r2 tping 100 60 2.2.2.4 vrf v1
    r2 tping 100 60 4321::4 vrf v1
    r3 tping 100 60 2.2.2.1 vrf v1
    r3 tping 100 60 4321::1 vrf v1
    r3 tping 100 60 2.2.2.2 vrf v1
    r3 tping 100 60 4321::2 vrf v1
    r3 tping 100 60 2.2.2.4 vrf v1
    r3 tping 100 60 4321::4 vrf v1
    r4 tping 100 60 2.2.2.1 vrf v1
    r4 tping 100 60 4321::1 vrf v1
    r4 tping 100 60 2.2.2.2 vrf v1
    r4 tping 100 60 4321::2 vrf v1
    r4 tping 100 60 2.2.2.3 vrf v1
    r4 tping 100 60 4321::3 vrf v1
    r3 send conf t
    r3 send route-map rm1
    r3 send set validity 1
    r3 send end
    r3 send clear ipv4 route v1
    r3 send clear ipv6 route v1
    r1 tping 100 60 2.2.2.2 vrf v1
    r1 tping 100 60 4321::2 vrf v1
    r1 tping 100 60 2.2.2.3 vrf v1
    r1 tping 100 60 4321::3 vrf v1
    r1 tping 100 60 2.2.2.4 vrf v1
    r1 tping 100 60 4321::4 vrf v1
    r2 tping 100 60 2.2.2.1 vrf v1
    r2 tping 100 60 4321::1 vrf v1
    r2 tping 100 60 2.2.2.3 vrf v1
    r2 tping 100 60 4321::3 vrf v1
    r2 tping 100 60 2.2.2.4 vrf v1
    r2 tping 100 60 4321::4 vrf v1
    r3 tping 100 60 2.2.2.1 vrf v1
    r3 tping 100 60 4321::1 vrf v1
    r3 tping 100 60 2.2.2.2 vrf v1
    r3 tping 100 60 4321::2 vrf v1
    r3 tping 100 60 2.2.2.4 vrf v1
    r3 tping 100 60 4321::4 vrf v1
    r4 tping 100 60 2.2.2.1 vrf v1
    r4 tping 100 60 4321::1 vrf v1
    r4 tping 100 60 2.2.2.2 vrf v1
    r4 tping 100 60 4321::2 vrf v1
    r4 tping 100 60 2.2.2.3 vrf v1
    r4 tping 100 60 4321::3 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp785](../clab/rout-bgp785/rout-bgp785.yml) file  
        3. Launch ContainerLab `rout-bgp785.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp785.yml  
        ```
        4. Destroy ContainerLab `rout-bgp785.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp785.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp785.tst` file [here](../tst/rout-bgp785.tst)  
        3. Launch `rout-bgp785.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp785 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp785.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

