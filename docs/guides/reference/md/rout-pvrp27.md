# Example: pvrp auto mesh tunnel

=== "Topology"

    ![Alt text](../d2/rout-pvrp27/rout-pvrp27.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny 58 any all any all
     permit all any all any all
     exit
    prefix-list all
     sequence 10 permit 0.0.0.0/0 le 32
     sequence 20 permit ::/0 le 128
     exit
    router pvrp4 1
     vrf v1
     router 4.4.4.1
     red conn
     automesh all
     exit
    router pvrp6 1
     vrf v1
     router 6.6.6.1
     red conn
     automesh all
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int ser1
     vrf for v1
     ipv4 addr 9.9.9.1 255.255.255.0
     ipv6 addr 9999::1 ffff::
     router pvrp4 1 ena
     router pvrp6 1 ena
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    access-list test4
     deny 1 any all any all
     permit all any all any all
     exit
    access-list test6
     deny 58 any all any all
     permit all any all any all
     exit
    prefix-list all
     sequence 10 permit 0.0.0.0/0 le 32
     sequence 20 permit ::/0 le 128
     exit
    router pvrp4 1
     vrf v1
     router 4.4.4.2
     red conn
     automesh all
     exit
    router pvrp6 1
     vrf v1
     router 6.6.6.2
     red conn
     automesh all
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int ser1
     vrf for v1
     ipv4 addr 9.9.9.2 255.255.255.0
     ipv6 addr 9999::2 ffff::
     router pvrp4 1 ena
     router pvrp6 1 ena
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 40 9.9.9.2 vrf v1
    r1 tping 100 40 9999::2 vrf v1
    r2 tping 100 40 9.9.9.1 vrf v1
    r2 tping 100 40 9999::1 vrf v1
    r1 tping 0 40 2.2.2.2 vrf v1
    r1 tping 0 40 4321::2 vrf v1
    r2 tping 0 40 2.2.2.1 vrf v1
    r2 tping 0 40 4321::1 vrf v1
    r2 output show ipv4 pvrp 1 sum
    r2 output show ipv6 pvrp 1 sum
    r2 output show ipv4 pvrp 1 rou
    r2 output show ipv6 pvrp 1 rou
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-pvrp27](../clab/rout-pvrp27/rout-pvrp27.yml) file  
        3. Launch ContainerLab `rout-pvrp27.yml` topology:  

        ```
           containerlab deploy --topo rout-pvrp27.yml  
        ```
        4. Destroy ContainerLab `rout-pvrp27.yml` topology:  

        ```
           containerlab destroy --topo rout-pvrp27.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-pvrp27.tst` file [here](../tst/rout-pvrp27.tst)  
        3. Launch `rout-pvrp27.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-pvrp27 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-pvrp27.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

