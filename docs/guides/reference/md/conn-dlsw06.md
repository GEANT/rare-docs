# Example: lapb tunneling with dlsw

=== "Topology"

    ![Alt text](../d2/conn-dlsw06/conn-dlsw06.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int ser1
     enc lapb
     lapb mode dce
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
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    int ser1
     enc lapb
     xconnect v1 eth1 dlsw 1.1.1.2 123
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff:ffff::
     exit
    int ser1
     enc lapb
     lapb mode dce
     xconnect v1 eth1 dlsw 1.1.1.1 123
     exit
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int ser1
     enc lapb
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 10 1.1.1.2 vrf v1
    r3 tping 100 10 1.1.1.1 vrf v1
    r1 tping 100 10 2.2.2.2 vrf v1
    r1 tping 100 10 4321::2 vrf v1
    r4 tping 100 10 2.2.2.1 vrf v1
    r4 tping 100 10 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-dlsw06](../clab/conn-dlsw06/conn-dlsw06.yml) file  
        3. Launch ContainerLab `conn-dlsw06.yml` topology:  

        ```
           containerlab deploy --topo conn-dlsw06.yml  
        ```
        4. Destroy ContainerLab `conn-dlsw06.yml` topology:  

        ```
           containerlab destroy --topo conn-dlsw06.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-dlsw06.tst` file [here](../tst/conn-dlsw06.tst)  
        3. Launch `conn-dlsw06.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-dlsw06 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-dlsw06.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

