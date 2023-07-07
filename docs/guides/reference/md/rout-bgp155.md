# Example: bgp auto mesh tunnel

=== "Topology"

    ![Alt text](../d2/rout-bgp155/rout-bgp155.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
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
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 1
     router-id 4.4.4.1
     neigh 9.9.9.2 remote-as 2
     red conn
     automesh all
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 1
     router-id 6.6.6.1
     neigh 9999::2 remote-as 2
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
    router bgp4 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 2
     router-id 4.4.4.2
     neigh 9.9.9.1 remote-as 1
     red conn
     automesh all
     exit
    router bgp6 1
     vrf v1
     no safe-ebgp
     address uni
     local-as 2
     router-id 6.6.6.2
     neigh 9999::1 remote-as 1
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
     ipv4 access-group-in test4
     ipv6 access-group-in test6
     mpls enable
     mpls rsvp4
     mpls rsvp6
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 9.9.9.2 vrf v1
    r1 tping 100 60 9999::2 vrf v1
    r2 tping 100 60 9.9.9.1 vrf v1
    r2 tping 100 60 9999::1 vrf v1
    r1 tping 0 60 2.2.2.2 vrf v1
    r1 tping 0 60 4321::2 vrf v1
    r2 tping 0 60 2.2.2.1 vrf v1
    r2 tping 0 60 4321::1 vrf v1
    r1 output show ipv4 bgp 1 sum
    r1 output show ipv6 bgp 1 sum
    r1 output show ipv4 rsvp v1 sum
    r1 output show ipv6 rsvp v1 sum
    r1 output show ipv4 route v1
    r1 output show ipv6 route v1
    output ../binTmp/rout-bgp-te.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here are the ipv4 neighbors:
    here are the ipv6 neighbors:
    here is the ipv4 database:
    here is the ipv6 database:
    here are the ipv4 routes:
    here are the ipv6 routes:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-bgp155](../clab/rout-bgp155/rout-bgp155.yml) file  
        3. Launch ContainerLab `rout-bgp155.yml` topology:  

        ```
           containerlab deploy --topo rout-bgp155.yml  
        ```
        4. Destroy ContainerLab `rout-bgp155.yml` topology:  

        ```
           containerlab destroy --topo rout-bgp155.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-bgp155.tst` file [here](../tst/rout-bgp155.tst)  
        3. Launch `rout-bgp155.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-bgp155 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-bgp155.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

