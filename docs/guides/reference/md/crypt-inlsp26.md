# Example: inlsp with sha3512

=== "Topology"

    ![Alt text](../d2/crypt-inlsp26/crypt-inlsp26.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int ser1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    crypto ipsec ips
     cipher des
     hash sha3512
     key tester
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips
     tunnel mode inlsp
     tunnel source ser1
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
    int ser1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    crypto ipsec ips
     cipher des
     hash sha3512
     key tester
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips
     tunnel mode inlsp
     tunnel source ser1
     tunnel destination 1.1.1.1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 2.2.2.2 vrf v1
    r2 tping 100 5 2.2.2.1 vrf v1
    r1 tping 100 5 4321::2 vrf v1
    r2 tping 100 5 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-inlsp26](../clab/crypt-inlsp26/crypt-inlsp26.yml) file  
        3. Launch ContainerLab `crypt-inlsp26.yml` topology:  

        ```
           containerlab deploy --topo crypt-inlsp26.yml  
        ```
        4. Destroy ContainerLab `crypt-inlsp26.yml` topology:  

        ```
           containerlab destroy --topo crypt-inlsp26.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-inlsp26.tst` file [here](../tst/crypt-inlsp26.tst)  
        3. Launch `crypt-inlsp26.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-inlsp26 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-inlsp26.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

