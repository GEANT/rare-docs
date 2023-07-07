# Example: nsh over ethernet

=== "Topology"

    ![Alt text](../d2/mpls-nsh01/mpls-nsh01.svg)

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
     ipv6 addr 1111::1 ffff::
     exit
    ```

    **r2**

    ```
    hostname r2
    int eth1
     nsh ena
     nsh xconn 2 255
     exit
    int eth2
     nsh ena
     exit
    nsh 2 255 int eth2 0000.1111.2222
    nsh 3 254 int eth1 0000.1111.2222 rawpack keephdr
    ```

    **r3**

    ```
    hostname r3
    int eth1
     nsh ena
     exit
    int eth2
     nsh ena
     nsh xconn 3 255
     exit
    nsh 3 255 int eth1 0000.1111.2222
    nsh 2 254 int eth2 0000.1111.2222 rawpack keephdr
    ```

    **r4**

    ```
    hostname r4
    vrf def v1
     rd 1:1
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1111::2 ffff::
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 10 1.1.1.2 vrf v1
    r1 tping 100 10 1111::2 vrf v1
    r4 tping 100 10 1.1.1.1 vrf v1
    r4 tping 100 10 1111::1 vrf v1
    r2 output show inter eth1 full
    r2 output show inter eth2 full
    r2 output show nsh for
    r2 output show nsh for 2 255
    r2 output show nsh for 3 254
    output ../binTmp/mpls-nsh.html
    <html><body bgcolor="#000000" text="#FFFFFF" link="#00FFFF" vlink="#00FFFF" alink="#00FFFF">
    here is the interface:
    here is the interface:
    here is the fib:
    here is the detailed fib:
    here is the detailed fib:
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [mpls-nsh01](../clab/mpls-nsh01/mpls-nsh01.yml) file  
        3. Launch ContainerLab `mpls-nsh01.yml` topology:  

        ```
           containerlab deploy --topo mpls-nsh01.yml  
        ```
        4. Destroy ContainerLab `mpls-nsh01.yml` topology:  

        ```
           containerlab destroy --topo mpls-nsh01.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `mpls-nsh01.tst` file [here](../tst/mpls-nsh01.tst)  
        3. Launch `mpls-nsh01.tst` test:  

        ```
           java -jar ../../rtr.jar test tester mpls-nsh01 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `mpls-nsh01.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

