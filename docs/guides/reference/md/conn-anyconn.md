# Example: ip over anyconnect

=== "Topology"

    ![Alt text](../d2/conn-anyconn/conn-anyconn.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    int lo0
     vrf for v1
     ipv4 addr 4.4.4.4 255.255.255.255
     ipv6 addr 4444::4 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    aaa userlist usr
     username c password c
     exit
    ipv4 pool p4 2.2.2.1 0.0.0.1 254
    ipv6 pool p6 2222::1 ::1 254
    int di1
     enc raw
     vrf for v1
     ipv4 addr 2.2.2.0 255.255.255.255
     ipv6 addr 2222::0 ffff:ffff:ffff:ffff::
     ipv4 pool p4
     ipv6 pool p6
     exit
    server http h
     host * path ./
     host * anyconn dialer1
     host * authen usr
     vrf v1
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
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int di1
     enc raw
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.0
     ipv6 addr 3333::1 ffff:ffff:ffff:ffff::
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 2.2.2.0
    ipv6 route v1 :: :: 2222::0
    vpdn anyconn
     int di1
     proxy p1
     tar http://1.1.1.1/
     user c
     pass c
     prot anyconn
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 60 2.2.2.0 vrf v1
    r2 tping 100 60 2222::0 vrf v1
    r2 tping 100 5 4.4.4.4 vrf v1
    r2 tping 100 5 4444::4 vrf v1
    r2 output show inter dia1 full
    output ../binTmp/conn-anyconn.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the interface:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-anyconn](../clab/conn-anyconn/conn-anyconn.yml) file  
        3. Launch ContainerLab `conn-anyconn.yml` topology:  

        ```
           containerlab deploy --topo conn-anyconn.yml  
        ```
        4. Destroy ContainerLab `conn-anyconn.yml` topology:  

        ```
           containerlab destroy --topo conn-anyconn.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-anyconn.tst` file [here](../tst/conn-anyconn.tst)  
        3. Launch `conn-anyconn.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-anyconn path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-anyconn.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

