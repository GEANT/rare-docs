# Example: macsec over framerelay

=== "Topology"

    ![Alt text](../d2/crypt-macsec06/crypt-macsec06.svg)

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
    int ser1
     enc framerelay
     framerelay mode dce
     framerelay dlci 123
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
    int ser1
     enc framerelay
     framerelay dlci 123
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
        2. Fetch [crypt-macsec06](../clab/crypt-macsec06/crypt-macsec06.yml) file  
        3. Launch ContainerLab `crypt-macsec06.yml` topology:  

        ```
           containerlab deploy --topo crypt-macsec06.yml  
        ```
        4. Destroy ContainerLab `crypt-macsec06.yml` topology:  

        ```
           containerlab destroy --topo crypt-macsec06.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-macsec06.tst` file [here](../tst/crypt-macsec06.tst)  
        3. Launch `crypt-macsec06.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-macsec06 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-macsec06.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

