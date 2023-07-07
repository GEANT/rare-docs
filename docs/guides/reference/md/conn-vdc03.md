# Example: vdc peer connect

=== "Topology"

    ![Alt text](../d2/conn-vdc03/conn-vdc03.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vdc def a
     exit
    vdc def b
     conn eth1 a
     exit
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 9.9.9.9 255.255.255.255
     exit
    ```

=== "Verification"

    ```
    port 61000 62000
    r1 tping 100 5 9.9.9.9 vrf v1
    r1 send att vdc a
    r1 send conf t
    r1 send vrf def v1
    r1 send  rd 1:1
    r1 send  exit
    r1 send int eth1
    r1 send  vrf for v1
    r1 send  ipv4 addr 1.1.1.1 255.255.255.0
    r1 send  ipv6 addr 1234::1 ffff::
    r1 send  exit
    r1 send end
    r1 tping 100 5 1.1.1.1 vrf v1
    sleep 1000
    r1 char 3
    sleep 1000
    r1 char 24
    sleep 1000
    r1 read closed
    r1 tping 100 5 9.9.9.9 vrf v1
    r1 send att vdc b
    r1 send conf t
    r1 send vrf def v1
    r1 send  rd 1:1
    r1 send  exit
    r1 send int eth1
    r1 send  vrf for v1
    r1 send  ipv4 addr 1.1.1.2 255.255.255.0
    r1 send  ipv6 addr 1234::2 ffff::
    r1 send  exit
    r1 send end
    r1 tping 100 5 1.1.1.1 vrf v1
    r1 tping 100 5 1234::1 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-vdc03](../clab/conn-vdc03/conn-vdc03.yml) file  
        3. Launch ContainerLab `conn-vdc03.yml` topology:  

        ```
           containerlab deploy --topo conn-vdc03.yml  
        ```
        4. Destroy ContainerLab `conn-vdc03.yml` topology:  

        ```
           containerlab destroy --topo conn-vdc03.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-vdc03.tst` file [here](../tst/conn-vdc03.tst)  
        3. Launch `conn-vdc03.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-vdc03 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-vdc03.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

