# Example: openvpn with des

=== "Topology"

    ![Alt text](../d2/crypt-openvpn05/crypt-openvpn05.svg)

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
     hash md5
     key 22f9c676f655336c3f3188b8d9cc759903733212ed77231bc38126b6000b043f1f56d07b885f4d00676afd8fea25c88fa917294d8f1e89b84922d5d2556de977beac2f254ba2b67477131f4d4708cb509f4c9f784780465462e502d29183665bbd5eff6bdc27370f05aa1d856b497a1f7ef5f20bad7aff155619a4b09849fab814ee76e7121c2adf85326db4c1cce132200ca3e4d03930f765ba96a8c46f1ab374beb73e79093d60879a8d9585f2feb987d89e65a33ef3857f3b09df80a2403f6c50dc50439e258d61c7dac377514a8d281c10feeea79ae7b063064aec3989b4d867bb24182f7d007ad41284ee6577053dae2cc289dd39e66cd8fe7089b7015f
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips
     tunnel mode openvpn
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
     hash md5
     key 22f9c676f655336c3f3188b8d9cc759903733212ed77231bc38126b6000b043f1f56d07b885f4d00676afd8fea25c88fa917294d8f1e89b84922d5d2556de977beac2f254ba2b67477131f4d4708cb509f4c9f784780465462e502d29183665bbd5eff6bdc27370f05aa1d856b497a1f7ef5f20bad7aff155619a4b09849fab814ee76e7121c2adf85326db4c1cce132200ca3e4d03930f765ba96a8c46f1ab374beb73e79093d60879a8d9585f2feb987d89e65a33ef3857f3b09df80a2403f6c50dc50439e258d61c7dac377514a8d281c10feeea79ae7b063064aec3989b4d867bb24182f7d007ad41284ee6577053dae2cc289dd39e66cd8fe7089b7015f
     exit
    int tun1
     tunnel vrf v1
     tunnel prot ips
     tunnel mode openvpn
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
        2. Fetch [crypt-openvpn05](../clab/crypt-openvpn05/crypt-openvpn05.yml) file  
        3. Launch ContainerLab `crypt-openvpn05.yml` topology:  

        ```
           containerlab deploy --topo crypt-openvpn05.yml  
        ```
        4. Destroy ContainerLab `crypt-openvpn05.yml` topology:  

        ```
           containerlab destroy --topo crypt-openvpn05.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-openvpn05.tst` file [here](../tst/crypt-openvpn05.tst)  
        3. Launch `crypt-openvpn05.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-openvpn05 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-openvpn05.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

