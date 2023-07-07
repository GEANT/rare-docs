# Example: hsrp over ethernet

=== "Topology"

    ![Alt text](../d2/conn-hsrp/conn-hsrp.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    bridge 1
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
     ipv6 addr 1234::1 ffff::
     exit
    ipv4 route v1 0.0.0.0 0.0.0.0 1.1.1.254
    ipv6 route v1 :: :: 1234::254
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    bridge 1
     mac-learn
     block-unicast
     exit
    int eth1
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv4 hsrp address 1.1.1.254
     ipv4 hsrp priority 120
     ipv4 hsrp preempt
     ipv6 addr 1234::2 ffff::
     ipv6 hsrp address 1234::254
     ipv6 hsrp priority 120
     ipv6 hsrp preempt
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.0
     ipv6 addr 4321::2 ffff::
     exit
    ```

    **r3**

    ```
    hostname r3
    vrf def v1
     rd 1:1
     exit
    bridge 1
     mac-learn
     block-unicast
     exit
    int eth1
     bridge-gr 1
     exit
    int bvi1
     vrf for v1
     ipv4 addr 1.1.1.3 255.255.255.0
     ipv4 hsrp address 1.1.1.254
     ipv4 hsrp priority 110
     ipv4 hsrp preempt
     ipv6 addr 1234::3 ffff::
     ipv6 hsrp address 1234::254
     ipv6 hsrp priority 110
     ipv6 hsrp preempt
     exit
    int lo0
     vrf for v1
     ipv4 addr 2.2.2.3 255.255.255.0
     ipv6 addr 4321::3 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 1.1.1.2 vrf v1
    r1 tping 100 5 1.1.1.3 vrf v1
    r1 tping 100 5 1234::2 vrf v1
    r1 tping 100 5 1234::3 vrf v1
    r2 tping 100 5 1.1.1.1 vrf v1
    r2 tping 100 5 1.1.1.3 vrf v1
    r2 tping 100 5 1234::1 vrf v1
    r2 tping 100 5 1234::3 vrf v1
    r3 tping 100 5 1.1.1.1 vrf v1
    r3 tping 100 5 1.1.1.2 vrf v1
    r3 tping 100 5 1234::1 vrf v1
    r3 tping 100 5 1234::2 vrf v1
    r1 tping 100 5 2.2.2.2 vrf v1
    r1 tping 100 5 4321::2 vrf v1
    r1 tping 0 5 2.2.2.3 vrf v1
    r1 tping 0 5 4321::3 vrf v1
    r2 send conf t
    r2 send int eth1
    r2 send shut
    r2 send end
    r1 tping 0 5 2.2.2.2 vrf v1
    r1 tping 0 5 4321::2 vrf v1
    r1 tping 100 5 2.2.2.3 vrf v1
    r1 tping 100 5 4321::3 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-hsrp](../clab/conn-hsrp/conn-hsrp.yml) file  
        3. Launch ContainerLab `conn-hsrp.yml` topology:  

        ```
           containerlab deploy --topo conn-hsrp.yml  
        ```
        4. Destroy ContainerLab `conn-hsrp.yml` topology:  

        ```
           containerlab destroy --topo conn-hsrp.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-hsrp.tst` file [here](../tst/conn-hsrp.tst)  
        3. Launch `conn-hsrp.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-hsrp path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-hsrp.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

