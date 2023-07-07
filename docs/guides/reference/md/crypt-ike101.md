# Example: ipv4 in ike1 over ipv4

=== "Topology"

    ![Alt text](../d2/crypt-ike101/crypt-ike101.svg)

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
     group 02
     cipher des
     hash md5
     seconds 3600
     bytes 1024000
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
    vrf def v1
     rd 1:1
     exit
    crypto ipsec ips
     group 02
     cipher des
     hash md5
     seconds 3600
     bytes 1024000
     key tester
     role resp
     isakmp 1
     protected ipv4
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips
     tunnel mode ipsec
     tunnel source ethernet1
     tunnel destination 1.1.1.1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 2.2.2.2 vrf v1
    r2 tping 100 10 2.2.2.1 vrf v1
    r1 tping 0 10 4321::2 vrf v1
    r2 tping 0 10 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-ike101](../clab/crypt-ike101/crypt-ike101.yml) file  
        3. Launch ContainerLab `crypt-ike101.yml` topology:  

        ```
           containerlab deploy --topo crypt-ike101.yml  
        ```
        4. Destroy ContainerLab `crypt-ike101.yml` topology:  

        ```
           containerlab destroy --topo crypt-ike101.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-ike101.tst` file [here](../tst/crypt-ike101.tst)  
        3. Launch `crypt-ike101.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-ike101 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-ike101.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

