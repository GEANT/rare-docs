# Example: forwarder server

=== "Topology"

    ![Alt text](../d2/serv-forward/serv-forward.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     exit
    server telnet tel
     vrf v1
     port 6666
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
     ipv6 addr 1234::2 ffff::
     exit
    int eth2
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    server forwarder fwd
     port 666
     target vrf v1
     target address 1.1.1.1
     target protocol tcp
     target port 6666
     vrf v1
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
     ipv4 addr 2.2.2.3 255.255.255.0
     ipv6 addr 4321::3 ffff::
     exit
    ```

=== "Verification"

    ```
    r2 tping 100 15 1.1.1.1 vrf v1
    r2 tping 100 15 2.2.2.3 vrf v1
    r3 send telnet 2.2.2.2 666 vrf v1
    r3 tping 100 15 2.2.2.2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [serv-forward](../clab/serv-forward/serv-forward.yml) file  
        3. Launch ContainerLab `serv-forward.yml` topology:  

        ```
           containerlab deploy --topo serv-forward.yml  
        ```
        4. Destroy ContainerLab `serv-forward.yml` topology:  

        ```
           containerlab destroy --topo serv-forward.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `serv-forward.tst` file [here](../tst/serv-forward.tst)  
        3. Launch `serv-forward.tst` test:  

        ```
           java -jar ../../rtr.jar test tester serv-forward path ./ temp ./ wait
        ```
        4. Destroy freeRtr `serv-forward.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

