# Example: ppp over forti

=== "Topology"

    ![Alt text](../d2/conn-forti/conn-forti.svg)

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
    aaa userlist usr
     username c password c
     exit
    int di1
     enc ppp
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 2222::1 ffff:ffff:ffff:ffff::
     exit
    server http h
     host * path ./
     host * forti dialer1
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
     enc ppp
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 2222::2 ffff:ffff:ffff:ffff::
     exit
    vpdn forti
     int di1
     proxy p1
     tar http://1.1.1.1/
     user c
     pass c
     prot forti
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 60 2.2.2.1 vrf v1
    r2 tping 100 60 2222::1 vrf v1
    r2 output show inter dia1 full
    output ../binTmp/conn-forti.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the interface:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-forti](../clab/conn-forti/conn-forti.yml) file  
        3. Launch ContainerLab `conn-forti.yml` topology:  

        ```
           containerlab deploy --topo conn-forti.yml  
        ```
        4. Destroy ContainerLab `conn-forti.yml` topology:  

        ```
           containerlab destroy --topo conn-forti.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-forti.tst` file [here](../tst/conn-forti.tst)  
        3. Launch `conn-forti.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-forti path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-forti.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

