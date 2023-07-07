# Example: mplsudp server

=== "Topology"

    ![Alt text](../d2/conn-mplsudp05/conn-mplsudp05.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.252
     exit
    int tun1
     tunnel vrf v1
     tunnel mode mplsudp
     tunnel source eth1
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
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.252
     exit
    int temp1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     shut
     exit
    server mplsudp mu
     clone temp1
     vrf v1
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
        2. Fetch [conn-mplsudp05](../clab/conn-mplsudp05/conn-mplsudp05.yml) file  
        3. Launch ContainerLab `conn-mplsudp05.yml` topology:  

        ```
           containerlab deploy --topo conn-mplsudp05.yml  
        ```
        4. Destroy ContainerLab `conn-mplsudp05.yml` topology:  

        ```
           containerlab destroy --topo conn-mplsudp05.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-mplsudp05.tst` file [here](../tst/conn-mplsudp05.tst)  
        3. Launch `conn-mplsudp05.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-mplsudp05 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-mplsudp05.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

