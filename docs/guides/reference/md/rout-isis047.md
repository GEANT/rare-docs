# Example: isis auto mesh tunnel

=== "Topology"

    ![Alt text](../d2/rout-isis047/rout-isis047.svg)

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
    router isis4 1
     vrf v1
     net 48.4444.0000.1111.00
     red conn
     automesh all
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.1111.00
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
     router isis4 1 ena
     ipv4 access-group-in test4
     mpls enable
     mpls rsvp4
     exit
    int ser2
     vrf for v1
     ipv6 addr 9999::1 ffff::
     router isis6 1 ena
     ipv6 access-group-in test6
     mpls enable
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
    router isis4 1
     vrf v1
     net 48.4444.0000.2222.00
     red conn
     automesh all
     exit
    router isis6 1
     vrf v1
     net 48.6666.0000.2222.00
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
     router isis4 1 ena
     ipv4 access-group-in test4
     mpls enable
     mpls rsvp4
     exit
    int ser2
     vrf for v1
     ipv6 addr 9999::2 ffff::
     router isis6 1 ena
     ipv6 access-group-in test6
     mpls enable
     mpls rsvp6
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 9.9.9.2 vrf v1
    r1 tping 100 20 9999::2 vrf v1
    r2 tping 100 20 9.9.9.1 vrf v1
    r2 tping 100 20 9999::1 vrf v1
    r1 tping 0 20 2.2.2.2 vrf v1
    r1 tping 0 20 4321::2 vrf v1
    r2 tping 0 20 2.2.2.1 vrf v1
    r2 tping 0 20 4321::1 vrf v1
    r2 output show ipv4 isis 1 nei
    r2 output show ipv6 isis 1 nei
    r2 output show ipv4 isis 1 dat 2
    r2 output show ipv6 isis 1 dat 2
    r2 output show ipv4 isis 1 tre 2
    r2 output show ipv6 isis 1 tre 2
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-isis047](../clab/rout-isis047/rout-isis047.yml) file  
        3. Launch ContainerLab `rout-isis047.yml` topology:  

        ```
           containerlab deploy --topo rout-isis047.yml  
        ```
        4. Destroy ContainerLab `rout-isis047.yml` topology:  

        ```
           containerlab destroy --topo rout-isis047.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-isis047.tst` file [here](../tst/rout-isis047.tst)  
        3. Launch `rout-isis047.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-isis047 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-isis047.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

