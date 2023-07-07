# Example: pvrp peer metric

=== "Topology"

    ![Alt text](../d2/rout-pvrp40/rout-pvrp40.svg)

=== "Configurations"

    **r1**

    ```
    hostname r1
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    router pvrp4 1
     vrf v1
     router 4.4.4.1
     label
     red conn
     exit
    router pvrp6 1
     vrf v1
     router 6.6.6.1
     label
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.1 255.255.255.255
     ipv6 addr 4321::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.1 255.255.255.0
     ipv6 addr 1234::1 ffff::
     router pvrp4 1 ena
     router pvrp4 1 metric-in 100
     router pvrp6 1 ena
     router pvrp6 1 metric-in 100
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.1 255.255.255.0
     ipv6 addr 1235::1 ffff::
     mpls enable
     router pvrp4 1 ena
     router pvrp4 1 metric-in 1
     router pvrp6 1 ena
     router pvrp6 1 metric-in 1
     exit
    ```

    **r2**

    ```
    hostname r2
    vrf def v1
     rd 1:1
     label-mode per-prefix
     exit
    router pvrp4 1
     vrf v1
     router 4.4.4.2
     label
     red conn
     exit
    router pvrp6 1
     vrf v1
     router 6.6.6.2
     label
     red conn
     exit
    int lo1
     vrf for v1
     ipv4 addr 2.2.2.2 255.255.255.255
     ipv6 addr 4321::2 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
     exit
    int eth1
     vrf for v1
     ipv4 addr 1.1.1.2 255.255.255.0
     ipv6 addr 1234::2 ffff::
     mpls enable
     router pvrp4 1 ena
     router pvrp4 1 metric-in 2
     router pvrp4 1 accept-met
     router pvrp6 1 ena
     router pvrp6 1 metric-in 2
     router pvrp6 1 accept-met
     exit
    int eth2
     vrf for v1
     ipv4 addr 1.1.2.2 255.255.255.0
     ipv6 addr 1235::2 ffff::
     mpls enable
     router pvrp4 1 ena
     router pvrp4 1 metric-in 200
     router pvrp4 1 accept-met
     router pvrp6 1 ena
     router pvrp6 1 metric-in 200
     router pvrp6 1 accept-met
     exit
    ```

=== "Verification"

    ```
    r1 tping 100 20 2.2.2.2 vrf v1 sou lo1
    r2 tping 100 20 2.2.2.1 vrf v1 sou lo1
    r1 tping 100 20 4321::2 vrf v1 sou lo1
    r2 tping 100 20 4321::1 vrf v1 sou lo1
    r2 output show ipv4 pvrp 1 sum
    r2 output show ipv6 pvrp 1 sum
    r2 output show ipv4 pvrp 1 rou
    r2 output show ipv6 pvrp 1 rou
    r2 output show ipv4 route v1
    r2 output show ipv6 route v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [rout-pvrp40](../clab/rout-pvrp40/rout-pvrp40.yml) file  
        3. Launch ContainerLab `rout-pvrp40.yml` topology:  

        ```
           containerlab deploy --topo rout-pvrp40.yml  
        ```
        4. Destroy ContainerLab `rout-pvrp40.yml` topology:  

        ```
           containerlab destroy --topo rout-pvrp40.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `rout-pvrp40.tst` file [here](../tst/rout-pvrp40.tst)  
        3. Launch `rout-pvrp40.tst` test:  

        ```
           java -jar ../../rtr.jar test tester rout-pvrp40 path ./ temp ./ wait
        ```
        4. Destroy freeRtr `rout-pvrp40.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

