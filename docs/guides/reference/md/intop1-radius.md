# Example: interop1: radius

=== "Topology"

    ![Alt text](../d2/intop1-radius/intop1-radius.svg)

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
     username usr password pwd
     exit
    server radius rad
     authen usr
     secret tester
     vrf v1
     exit
    ```

    **r2**

    ```
    hostname r2
    ip routing
    ipv6 unicast-routing
    interface gigabit1
     ip address 1.1.1.2 255.255.255.0
     ipv6 address 1234::2/64
     no shutdown
     exit
    interface gigabit2
     ip address 2.2.2.1 255.255.255.0
     ipv6 address 4321::1/64
     no shutdown
     exit
    aaa new-model
    aaa authentication login default group radius
    radius server radius
     address ipv4 1.1.1.1 auth-port 1812 acct-port 1813
     key tester
     exit
    line vty 0 4
     transport input all
     transport output all
     no motd-banner
     no exec-banner
     no vacant-message
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    int lo1
     vrf for v1
     ipv4 addr 3.3.3.3 255.255.255.255
     exit
    server tel tel
     vrf v1
     security protocol tel
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1234::2 vrf v1
    r3 tping 100 10 2.2.2.1 vrf v1
    r3 tping 100 10 4321::1 vrf v1
    r1 send telnet 1.1.1.2 vrf v1 telnet
    sleep 1000
    r1 send usr
    sleep 1000
    r1 send pwd
    sleep 3000
    r1 char 13
    r1 read vxe#
    r1 send telnet 2.2.2.2
    sleep 3000
    r1 tping 100 10 3.3.3.3 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-radius](../clab/intop1-radius/intop1-radius.yml) file  
        3. Launch ContainerLab `intop1-radius.yml` topology:  

        ```
           containerlab deploy --topo intop1-radius.yml  
        ```
        4. Destroy ContainerLab `intop1-radius.yml` topology:  

        ```
           containerlab destroy --topo intop1-radius.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-radius.tst` file [here](../tst/intop1-radius.tst)  
        3. Launch `intop1-radius.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-radius path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-radius.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

