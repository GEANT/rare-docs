# Example: atmdxi with gre

=== "Topology"

    ![Alt text](../d2/conn-gre09/conn-gre09.svg)

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
    int di1
     enc atmdxi
     atmdxi vpi 1
     atmdxi vci 2
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.0
     ipv6 addr 4321::1 ffff::
     exit
    vpdn pou
     interface dialer1
     proxy p1
     target 1.1.1.2
     vcid 1234
     protocol greppp
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
     enc atmdxi
     atmdxi vpi 1
     atmdxi vci 2
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    vpdn pou
     interface dialer1
     proxy p1
     target 1.1.1.1
     vcid 1234
     protocol greppp
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 30 2.2.2.2 vrf v1
    r1 tping 100 30 4321::2 vrf v1
    r2 tping 100 30 2.2.2.1 vrf v1
    r2 tping 100 30 4321::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-gre09](../clab/conn-gre09/conn-gre09.yml) file  
        3. Launch ContainerLab `conn-gre09.yml` topology:  

        ```
           containerlab deploy --topo conn-gre09.yml  
        ```
        4. Destroy ContainerLab `conn-gre09.yml` topology:  

        ```
           containerlab destroy --topo conn-gre09.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-gre09.tst` file [here](../tst/conn-gre09.tst)  
        3. Launch `conn-gre09.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-gre09 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-gre09.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

