# Example: ipv4 over gtp

=== "Topology"

    ![Alt text](../d2/conn-gtp02/conn-gtp02.svg)

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
    int lo0
     vrf for v1
     ipv4 addr 4.4.4.4 255.255.255.255
     ipv6 addr 4444::4 ffff::
     exit
    ipv4 pool p4 2.2.2.1 0.0.0.1 254
    ipv6 pool p6 2222::1111 ::1 254
    int di1
     enc iponly
     vrf for v1
     ipv4 addr 2.2.2.0 255.255.255.255
     ipv4 pool p4
     exit
    server gtp gtp
     clone di1
     vrf v1
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    int di1
     enc raw
     vrf for v1
     ipv4 addr 3.3.3.3 0.0.0.0
     ipv6 addr 3333::3333 ::
     exit
    vpdn gtp
     int di1
     proxy p1
     tar 1.1.1.1
     called inet
     calling 4321
     dir in
     prot gtp
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 60 4.4.4.4 vrf v1
    r2 tping 0 5 4444::4 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-gtp02](../clab/conn-gtp02/conn-gtp02.yml) file  
        3. Launch ContainerLab `conn-gtp02.yml` topology:  

        ```
           containerlab deploy --topo conn-gtp02.yml  
        ```
        4. Destroy ContainerLab `conn-gtp02.yml` topology:  

        ```
           containerlab destroy --topo conn-gtp02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-gtp02.tst` file [here](../tst/conn-gtp02.tst)  
        3. Launch `conn-gtp02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-gtp02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-gtp02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

