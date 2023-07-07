# Example: wireguard over wireguard

=== "Topology"

    ![Alt text](../d2/crypt-wireguard03/crypt-wireguard03.svg)

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
    crypto ipsec ips1
     key EFw2rJEdqFGDgC80um3fwMmAafwqXno+PsbMHPZ0umM=M6vDV8QdiWDQppVKjKf8xjoKtyGAeRK/Ue48kwKI5Ss=
     exit
    crypto ipsec ips2
     key EFw2rJEdqFGDgC80um3fwMmAafwqXno+PsbMHPZ0umM=M6vDV8QdiWDQppVKjKf8xjoKtyGAeRK/Ue48kwKI5Ss=
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips2
     tunnel mode wireguard
     tunnel source ethernet1
     tunnel destination 1.1.1.2
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     exit
    int tun2
     tunnel vrf v1
     tunnel prot ips1
     tunnel mode wireguard
     tunnel source tun1
     tunnel destination 2.2.2.2
     vrf for v1
     ipv4 addr 3.3.3.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
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
     exit
    crypto ipsec ips1
     key 6JhyvKPutQ9DNLupOPmDnQLRWtUWlUjI6PTJ/IZ9l1w=bQMmpCaGVyq9f+v48XGmfH5DMLytkqziID+rBH+qQic=
     exit
    crypto ipsec ips2
     key 6JhyvKPutQ9DNLupOPmDnQLRWtUWlUjI6PTJ/IZ9l1w=bQMmpCaGVyq9f+v48XGmfH5DMLytkqziID+rBH+qQic=
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips2
     tunnel mode wireguard
     tunnel source ethernet1
     tunnel destination 1.1.1.1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     exit
    int tun2
     tunnel vrf v1
     tunnel prot ips1
     tunnel mode wireguard
     tunnel source tun1
     tunnel destination 2.2.2.1
     vrf for v1
     ipv4 addr 3.3.3.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 1.1.1.2 vrf v1
    r2 tping 100 5 1.1.1.1 vrf v1
    r1 tping 100 5 2.2.2.2 vrf v1
    r2 tping 100 5 2.2.2.1 vrf v1
    r1 tping 100 5 3.3.3.2 vrf v1
    r2 tping 100 5 3.3.3.1 vrf v1
    r1 tping 100 5 1234::2 vrf v1
    r2 tping 100 5 1234::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-wireguard03](../clab/crypt-wireguard03/crypt-wireguard03.yml) file  
        3. Launch ContainerLab `crypt-wireguard03.yml` topology:  

        ```
           containerlab deploy --topo crypt-wireguard03.yml  
        ```
        4. Destroy ContainerLab `crypt-wireguard03.yml` topology:  

        ```
           containerlab destroy --topo crypt-wireguard03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-wireguard03.tst` file [here](../tst/crypt-wireguard03.tst)  
        3. Launch `crypt-wireguard03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-wireguard03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-wireguard03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

