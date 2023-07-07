# Example: ike1 with 3des

=== "Topology"

    ![Alt text](../d2/crypt-ike107/crypt-ike107.svg)

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
     cipher 3des
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
     group 02
     cipher 3des
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
    r1 tping 100 10 2.2.2.2 vrf v1
    r2 tping 100 10 2.2.2.1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-ike107](../clab/crypt-ike107/crypt-ike107.yml) file  
        3. Launch ContainerLab `crypt-ike107.yml` topology:  

        ```
           containerlab deploy --topo crypt-ike107.yml  
        ```
        4. Destroy ContainerLab `crypt-ike107.yml` topology:  

        ```
           containerlab destroy --topo crypt-ike107.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-ike107.tst` file [here](../tst/crypt-ike107.tst)  
        3. Launch `crypt-ike107.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-ike107 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-ike107.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

