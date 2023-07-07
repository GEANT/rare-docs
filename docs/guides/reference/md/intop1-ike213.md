# Example: interop1: ike2 with group15

=== "Topology"

    ![Alt text](../d2/intop1-ike213/intop1-ike213.svg)

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
     group 15
     cipher des
     hash md5
     seconds 3600
     bytes 67108864
     key tester
     role init
     isakmp 2
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
    crypto ikev2 proposal pr1
     encryption des
     integrity md5
     group 15
     exit
    crypto ikev2 policy pl1
     proposal pr1
     exit
    crypto ikev2 keyring kr1
     peer p1
      address 1.1.1.1
      pre-shared-key tester
     exit
    crypto ikev2 profile pr1
     match identity remote address 1.1.1.1 255.255.255.255
     authentication local pre-share
     authentication remote pre-share
     lifetime 3600
     keyring local kr1
     exit
    crypto ipsec transform-set ts1 esp-des esp-md5-hmac
     mode tunnel
     exit
    crypto ipsec profile pr1
     set security-association lifetime seconds 3600
     set security-association lifetime kilobytes 65536
     set transform-set ts1
     set ikev2-profile pr1
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
        2. Fetch [intop1-ike213](../clab/intop1-ike213/intop1-ike213.yml) file  
        3. Launch ContainerLab `intop1-ike213.yml` topology:  

        ```
           containerlab deploy --topo intop1-ike213.yml  
        ```
        4. Destroy ContainerLab `intop1-ike213.yml` topology:  

        ```
           containerlab destroy --topo intop1-ike213.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-ike213.tst` file [here](../tst/intop1-ike213.tst)  
        3. Launch `intop1-ike213.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-ike213 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-ike213.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

