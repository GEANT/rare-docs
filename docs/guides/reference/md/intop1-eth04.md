# Example: interop1: spantree root

=== "Topology"

    ![Alt text](../d2/intop1-eth04/intop1-eth04.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    bridge 1
     stp-priority 4096
     stp-mode ieee
     mac-learn
     exit
    int eth1
     bridge-gr 1
     exit
    int eth2
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     exit
    ```

    **r2**

    ```
    hostname r2
    ip routing
    ipv6 unicast-routing
    bridge irb
    bridge 1 protocol ieee
    bridge 1 route ip
    interface gigabit1
     bridge-group 1
     no shutdown
     exit
    interface gigabit2
     bridge-group 1
     no shutdown
     exit
    interface bvi1
     ip address 1.1.1.2 255.255.255.0
     no shutdown
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 60 1.1.1.2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [intop1-eth04](../clab/intop1-eth04/intop1-eth04.yml) file  
        3. Launch ContainerLab `intop1-eth04.yml` topology:  

        ```
           containerlab deploy --topo intop1-eth04.yml  
        ```
        4. Destroy ContainerLab `intop1-eth04.yml` topology:  

        ```
           containerlab destroy --topo intop1-eth04.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `intop1-eth04.tst` file [here](../tst/intop1-eth04.tst)  
        3. Launch `intop1-eth04.tst` test:  

        ```
           java -jar ../../rtr.jar test tester intop1-eth04 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `intop1-eth04.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

