# Example: spantree over ethernet

=== "Topology"

    ![Alt text](../d2/conn-stp/conn-stp.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     exit
    bridge 1
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
     ipv6 addr 1234::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     exit
    bridge 1
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
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 5 1.1.1.2 vrf v1
    r1 tping 100 5 1234::2 vrf v1
    r2 tping 100 5 1.1.1.1 vrf v1
    r2 tping 100 5 1234::1 vrf v1
    r2 output show bridge 1
    r2 output show inter bvi1 full
    r2 output show ipv4 arp bvi1
    r2 output show ipv6 neigh bvi1
    output ../binTmp/conn-stp.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the bridge:
    here is the interface:
    here is the arp:
    here are the neighbors:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [conn-stp](../clab/conn-stp/conn-stp.yml) file  
        3. Launch ContainerLab `conn-stp.yml` topology:  

        ```
           containerlab deploy --topo conn-stp.yml  
        ```
        4. Destroy ContainerLab `conn-stp.yml` topology:  

        ```
           containerlab destroy --topo conn-stp.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `conn-stp.tst` file [here](../tst/conn-stp.tst)  
        3. Launch `conn-stp.tst` test:  

        ```
           java -jar ../../rtr.jar test tester conn-stp path ./ temp ./ wait
        ```
        4. Destroy freeRtr `conn-stp.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

