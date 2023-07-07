# Example: ike1 with group22

=== "Topology"

    ![Alt text](../d2/crypt-ike123/crypt-ike123.svg)

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
     exit
    crypto ipsec ips
     group 22
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
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    crypto ipsec ips
     group 22
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
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips
     tunnel mode ipsec
     tunnel source ethernet1
     tunnel destination 1.1.1.1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 30 2.2.2.2 vrf v1
    r2 tping 100 30 2.2.2.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-ike123](../clab/crypt-ike123/crypt-ike123.yml) file  
        3. Launch ContainerLab `crypt-ike123.yml` topology:  

        ```
           containerlab deploy --topo crypt-ike123.yml  
        ```
        4. Destroy ContainerLab `crypt-ike123.yml` topology:  

        ```
           containerlab destroy --topo crypt-ike123.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-ike123.tst` file [here](../tst/crypt-ike123.tst)  
        3. Launch `crypt-ike123.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-ike123 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-ike123.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

