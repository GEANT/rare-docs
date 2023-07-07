# Example: event manager

=== "Topology"

    ![Alt text](../d2/serv-eventmgr/serv-eventmgr.svg)

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
     ipv6 addr 1234::1 ffff::
     shutdown
     exit
    event-manager test
     event .* testing .*
     tcl exec "test logging debug hello there"
     tcl config "int eth1" "no shut"
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
    ```

=== "Verification"

    ```
    r1 send test logging debug testing 123
    r2 tping 100 15 1.1.1.1 vrf v1
    r2 tping 100 15 1234::1 vrf v1
    r1 tping 100 15 1.1.1.2 vrf v1
    r1 tping 100 15 1234::2 vrf v1
    ```

=== "Emulation"

    === "ContainerLab"

        1. Install ContainerLab as described [here](https://containerlab.dev/install/)  
        2. Fetch [serv-eventmgr](../clab/serv-eventmgr/serv-eventmgr.yml) file  
        3. Launch ContainerLab `serv-eventmgr.yml` topology:  

        ```
           containerlab deploy --topo serv-eventmgr.yml  
        ```
        4. Destroy ContainerLab `serv-eventmgr.yml` topology:  

        ```
           containerlab destroy --topo serv-eventmgr.yml  
        ```
        5. Copy-paste configuration for each node in the lab topology

    === "freeRtr CLI"

        1. Fetch or compile freeRtr rtr.jar file.  
           You can grab it [here](http://www.freertr.org/rtr.jar)  
        2. Fetch `serv-eventmgr.tst` file [here](../tst/serv-eventmgr.tst)  
        3. Launch `serv-eventmgr.tst` test:  

        ```
           java -jar ../../rtr.jar test tester serv-eventmgr path ./ temp ./ wait
        ```
        4. Destroy freeRtr `serv-eventmgr.tst` test:  

        ```
           Ctrl-C (In freeRtr test window)
        ```

