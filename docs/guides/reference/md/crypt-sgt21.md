# Example: sgt encapsulation with egress allow

=== "Topology"

    ![Alt text](../d2/crypt-sgt21/crypt-sgt21.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     sgt ena
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.2
    ipv6 route v1 :: :: 1234::2
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    int eth1
     sgt ena
     sgt allow-out 0 2
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int eth2
     sgt ena
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth1
     sgt ena
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 2.2.2.1
    ipv6 route v1 :: :: 4321::1
    ```

=== "Verification"

    ```
    r1 tping 100 5 2.2.2.2 vrf v1 sgt 0
    r3 tping 100 5 1.1.1.1 vrf v1 sgt 0
    r1 tping 100 5 4321::2 vrf v1 sgt 0
    r3 tping 100 5 1234::1 vrf v1 sgt 0
    r1 tping 0 5 2.2.2.2 vrf v1 sgt 1
    r3 tping 0 5 1.1.1.1 vrf v1 sgt 1
    r1 tping 0 5 4321::2 vrf v1 sgt 1
    r3 tping 0 5 1234::1 vrf v1 sgt 1
    r1 tping 100 5 2.2.2.2 vrf v1 sgt 2
    r3 tping 100 5 1.1.1.1 vrf v1 sgt 2
    r1 tping 100 5 4321::2 vrf v1 sgt 2
    r3 tping 100 5 1234::1 vrf v1 sgt 2
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [crypt-sgt21](../clab/crypt-sgt21/crypt-sgt21.yml) file  
        3. Launch ContainerLab `crypt-sgt21.yml` topology:  

        ```
           containerlab deploy --topo crypt-sgt21.yml  
        ```
        4. Destroy ContainerLab `crypt-sgt21.yml` topology:  

        ```
           containerlab destroy --topo crypt-sgt21.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `crypt-sgt21.tst` file [here](../tst/crypt-sgt21.tst)  
        3. Launch `crypt-sgt21.tst` test:  

        ```
           java -jar ../../rtr.jar test tester crypt-sgt21 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `crypt-sgt21.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

