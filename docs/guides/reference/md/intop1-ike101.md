# Example: interop1: ike1 with ipv4

=== "Topology"

    ![Alt text](../d2/intop1-ike101/intop1-ike101.svg)

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
    crypto ipsec ips
     group 01
     cipher des
     hash md5
     seconds 3600
     bytes 67108864
     key tester
     role init
     isakmp 1
     protected ipv4
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips
     tunnel mode ipsec
     tunnel source ethernet1
     tunnel destination 1.1.1.2
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
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
    crypto isakmp policy 10
     encryption des
     hash md5
     authentication pre-share
     group 1
     lifetime 3600
     exit
    crypto isakmp key tester address 1.1.1.1
    crypto ipsec transform-set ts1 esp-des esp-md5-hmac
     mode tunnel
     exit
    crypto ipsec profile pr1
     set security-association lifetime seconds 3600
     set security-association lifetime kilobytes 65536
     set transform-set ts1
     exit
    interface tunnel1
     ip address 2.2.2.2 255.255.255.0
     tunnel source gigabit1
     tunnel destination 1.1.1.1
     tunnel mode ipsec ipv4
     tunnel protection ipsec profile pr1
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 120 2.2.2.2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-ike101](../clab/intop1-ike101/intop1-ike101.yml) file  
        3. Launch ContainerLab `intop1-ike101.yml` topology:  

        ```
           containerlab deploy --topo intop1-ike101.yml  
        ```
        4. Destroy ContainerLab `intop1-ike101.yml` topology:  

        ```
           containerlab destroy --topo intop1-ike101.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-ike101.tst` file [here](../tst/intop1-ike101.tst)  
        3. Launch `intop1-ike101.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-ike101 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-ike101.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

