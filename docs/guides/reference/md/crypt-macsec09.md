# Example: macsec over tunnel

=== "Topology"

    ![Alt text](../d2/crypt-macsec09/crypt-macsec09.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    crypto ipsec ips
     group 02
     cipher aes256cbc
     hash sha1
     key tester
     exit
    int eth1
     vrf for v1
     ipv4 addr 9.9.9.1 255.255.255.252
     ipv6 addr 9999::1 ffff::
     exit
    int tun1
     tunnel vrf v1
     tunnel mode gre
     tunnel source ethernet1
     tunnel destination 9999::2
     vrf for v1
     macsec ips
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
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
     cipher aes256cbc
     hash sha1
     key tester
     exit
    int eth1
     vrf for v1
     ipv4 addr 9.9.9.2 255.255.255.252
     ipv6 addr 9999::2 ffff::
     exit
    int tun1
     tunnel vrf v1
     tunnel mode gre
     tunnel source ethernet1
     tunnel destination 9999::1
     vrf for v1
     macsec ips
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 30 1.1.1.2 vrf v1
    r2 tping 100 30 1.1.1.1 vrf v1
    r1 tping 100 30 1234::2 vrf v1
    r2 tping 100 30 1234::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-macsec09](../clab/crypt-macsec09/crypt-macsec09.yml) file  
        3. Launch ContainerLab `crypt-macsec09.yml` topology:  

        ```
           containerlab deploy --topo crypt-macsec09.yml  
        ```
        4. Destroy ContainerLab `crypt-macsec09.yml` topology:  

        ```
           containerlab destroy --topo crypt-macsec09.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-macsec09.tst` file [here](../tst/crypt-macsec09.tst)  
        3. Launch `crypt-macsec09.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-macsec09 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-macsec09.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

