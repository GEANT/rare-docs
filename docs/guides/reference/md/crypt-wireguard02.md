# Example: wireguard over ipv6

=== "Topology"

    ![Alt text](../d2/crypt-wireguard02/crypt-wireguard02.svg)

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
     key EFw2rJEdqFGDgC80um3fwMmAafwqXno+PsbMHPZ0umM=M6vDV8QdiWDQppVKjKf8xjoKtyGAeRK/Ue48kwKI5Ss=
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips
     tunnel mode wireguard
     tunnel source ser1
     tunnel destination 1234::2
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
     key 6JhyvKPutQ9DNLupOPmDnQLRWtUWlUjI6PTJ/IZ9l1w=bQMmpCaGVyq9f+v48XGmfH5DMLytkqziID+rBH+qQic=
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips
     tunnel mode wireguard
     tunnel source ser1
     tunnel destination 1234::1
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
        2. Fetch [crypt-wireguard02](../clab/crypt-wireguard02/crypt-wireguard02.yml) file  
        3. Launch ContainerLab `crypt-wireguard02.yml` topology:  

        ```
           containerlab deploy --topo crypt-wireguard02.yml  
        ```
        4. Destroy ContainerLab `crypt-wireguard02.yml` topology:  

        ```
           containerlab destroy --topo crypt-wireguard02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-wireguard02.tst` file [here](../tst/crypt-wireguard02.tst)  
        3. Launch `crypt-wireguard02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-wireguard02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-wireguard02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

