# Example: radius server

=== "Topology"

    ![Alt text](../d2/serv-radius/serv-radius.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    client proxy p1
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    aaa radius rad
     secret tester
     server 1.1.1.2
     exit
    server telnet tel
     login authentication rad
     vrf v1
     port 666
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    aaa userlist usr
     username c password c
     username c privilege 14
     exit
    server radius rad
     authen usr
     secret tester
     logg
     vrf v1
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 15 1.1.1.1 vrf v1
    r2 send telnet 1.1.1.1 666 vrf v1
    r2 send c
    r2 send c
    r2 tping 100 15 2.2.2.2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [serv-radius](../clab/serv-radius/serv-radius.yml) file  
        3. Launch ContainerLab `serv-radius.yml` topology:  

        ```
           containerlab deploy --topo serv-radius.yml  
        ```
        4. Destroy ContainerLab `serv-radius.yml` topology:  

        ```
           containerlab destroy --topo serv-radius.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `serv-radius.tst` file [here](../tst/serv-radius.tst)  
        3. Launch `serv-radius.tst` test:  

        ```
           java -jar ../../rtr.jar test tester serv-radius path ./ temp ./ wait
        ```
        4. Destroy freeRtr `serv-radius.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

