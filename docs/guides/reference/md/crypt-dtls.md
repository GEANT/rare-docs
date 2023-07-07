# Example: dtls test

=== "Topology"

    ![Alt text](../d2/crypt-dtls/crypt-dtls.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    crypto rsakey rsa generate 2048
    crypto dsakey dsa generate 1024
    crypto ecdsakey ecdsa generate 256
    crypto certificate dsa generate dsa dsa
    crypto certificate rsa generate rsa rsa
    crypto certificate ecdsa generate ecdsa ecdsa
    server udptn udptn
     security rsakey rsa
     security dsakey dsa
     security ecdsakey ecdsa
     security rsacert rsa
     security dsacert dsa
     security ecdsacert ecdsa
     security protocol dtls
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
    ```

=== "Verification"

    ```
    r1 tping 100 5 1.1.1.2 vrf v1
    r2 send telnet 1.1.1.1 666 vrf v1 dtls
    r2 tping 100 5 2.2.2.2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-dtls](../clab/crypt-dtls/crypt-dtls.yml) file  
        3. Launch ContainerLab `crypt-dtls.yml` topology:  

        ```
           containerlab deploy --topo crypt-dtls.yml  
        ```
        4. Destroy ContainerLab `crypt-dtls.yml` topology:  

        ```
           containerlab destroy --topo crypt-dtls.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-dtls.tst` file [here](../tst/crypt-dtls.tst)  
        3. Launch `crypt-dtls.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-dtls path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-dtls.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

