# Example: etherip server

=== "Topology"

    ![Alt text](../d2/conn-etherip14/conn-etherip14.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    bridge 1
     mac-learn
     exit
    vpdn er
     bridge-group 1
     proxy p1
     target 1.1.1.2
     vcid 123
     protocol etherip
     exit
    int bvi1
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
    proxy-profile p1
     vrf v1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    bridge 1
     mac-learn
     exit
    server etherip ei
     bridge 1
     vrf v1
     exit
    int bvi1
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
        2. Fetch [conn-etherip14](../clab/conn-etherip14/conn-etherip14.yml) file  
        3. Launch ContainerLab `conn-etherip14.yml` topology:  

        ```
           containerlab deploy --topo conn-etherip14.yml  
        ```
        4. Destroy ContainerLab `conn-etherip14.yml` topology:  

        ```
           containerlab destroy --topo conn-etherip14.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-etherip14.tst` file [here](../tst/conn-etherip14.tst)  
        3. Launch `conn-etherip14.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-etherip14 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-etherip14.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

