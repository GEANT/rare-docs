# Example: ike2 over ipsec

=== "Topology"

    ![Alt text](../d2/crypt-ike226/crypt-ike226.svg)

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
     group 02
     cipher des
     hash md5
     seconds 3600
     bytes 1024000
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
     exit
    int tun2
     tunnel vrf v1
     tunnel prot ips
     tunnel mode ipsec
     tunnel source tun1
     tunnel destination 2.2.2.2
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
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
     isakmp 2
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
    int tun2
     tunnel vrf v1
     tunnel prot ips
     tunnel mode ipsec
     tunnel source tun1
     tunnel destination 2.2.2.1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 2.2.2.2 vrf v1
    r2 tping 100 10 2.2.2.1 vrf v1
    r1 tping 100 10 3.3.3.2 vrf v1
    r2 tping 100 10 3.3.3.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-ike226](../clab/crypt-ike226/crypt-ike226.yml) file  
        3. Launch ContainerLab `crypt-ike226.yml` topology:  

        ```
           containerlab deploy --topo crypt-ike226.yml  
        ```
        4. Destroy ContainerLab `crypt-ike226.yml` topology:  

        ```
           containerlab destroy --topo crypt-ike226.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-ike226.tst` file [here](../tst/crypt-ike226.tst)  
        3. Launch `crypt-ike226.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-ike226 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-ike226.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

