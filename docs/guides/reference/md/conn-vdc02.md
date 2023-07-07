# Example: vdc parent connect

=== "Topology"

    ![Alt text](../d2/conn-vdc02/conn-vdc02.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vdc def a
     loc eth1
     exit
    vrf def v1
     rd 1:1
     exit
    int lo0
     vrf for v1
     ipv4 addr 9.9.9.9 255.255.255.255
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
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
    r1 tping 100 5 1.1.1.2 vrf v1
    r1 tping 100 5 1234::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-vdc02](../clab/conn-vdc02/conn-vdc02.yml) file  
        3. Launch ContainerLab `conn-vdc02.yml` topology:  

        ```
           containerlab deploy --topo conn-vdc02.yml  
        ```
        4. Destroy ContainerLab `conn-vdc02.yml` topology:  

        ```
           containerlab destroy --topo conn-vdc02.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-vdc02.tst` file [here](../tst/conn-vdc02.tst)  
        3. Launch `conn-vdc02.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-vdc02 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-vdc02.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

