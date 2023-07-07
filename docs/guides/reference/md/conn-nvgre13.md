# Example: tunnel interface with nvgre

=== "Topology"

    ![Alt text](../d2/conn-nvgre13/conn-nvgre13.svg)

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
     ipv6 addr 1234::1 ffff::
     exit
    int tun1
     tun vrf v1
     tun sou eth1
     tun dest 1.1.1.2
     tun key 123
     tun mod nvgre
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
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff:ffff::
     exit
    int tun1
     tun vrf v1
     tun sou eth1
     tun dest 1.1.1.1
     tun key 123
     tun mod nvgre
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r2 tping 100 10 1.1.1.1 vrf v1
    r1 tping 100 10 2.2.2.2 vrf v1
    r1 tping 100 10 4321::2 vrf v1
    r2 tping 100 10 2.2.2.1 vrf v1
    r2 tping 100 10 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-nvgre13](../clab/conn-nvgre13/conn-nvgre13.yml) file  
        3. Launch ContainerLab `conn-nvgre13.yml` topology:  

        ```
           containerlab deploy --topo conn-nvgre13.yml  
        ```
        4. Destroy ContainerLab `conn-nvgre13.yml` topology:  

        ```
           containerlab destroy --topo conn-nvgre13.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-nvgre13.tst` file [here](../tst/conn-nvgre13.tst)  
        3. Launch `conn-nvgre13.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-nvgre13 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-nvgre13.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

