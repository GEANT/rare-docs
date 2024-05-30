# **Install FreeRouter control plane**

### Step 1: Clone the FreeRouter source files

```bash
[nix-shell(SDE-9.11.2):~]$ git clone https://github.com/rare-freertr/freeRtr.git
// To rebuild the binaries
[nix-shell(SDE-9.11.2):~/freeRtr/misc/native]$ ./c.sh
```

- The fatal errors are due to the lack of DPDK, install DPDK env (if only P4 data plane is needed, please ignore this setup):

```bash
[nix-shell(SDE-9.11.2):~/freeRtr/misc/native]$ apt-cache search dpdk-dev

```

# Configure RARE with P4 data plane

### Step 1: Clone the source folder of RARE with P4 data plane

```bash
[nix-shell(SDE-9.11.2):~]$ git clone [https://bitbucket.software.geant.org/scm/rare/rare.git](https://bitbucket.software.geant.org/scm/rare/rare.git)
```

### Step 2: Build the P4 code

```bash
[nix-shell(SDE-9.11.2):~]$ cd rare
[nix-shell(SDE-9.11.2):~]$ p4_build.sh --cmake-flags "-DTOFINO2=OFF -DCMAKE_VERBOSE_MAKEFILE=ON" --p4c-flags "-I$(realpath p4src) -I$(realpath profiles/9.11.2/tofino) -DPROFILE_GEANT_TESTBED -Xp4c=--disable-parse-depth-limit" p4src/bf_router.p4
```

- Note that the flags notations may change in different SDE versions. The attached one is only for SDE 9.11.2.
- If the warning says “exceeding the stage”, drop the “disable-parse-depth-limit” may help:
    
    e.g. `p4_build.sh --cmake-flags "-DTOFINO2=OFF -DCMAKE_VERBOSE_MAKEFILE=ON" --p4c-flags "-I$(realpath p4src) -I$(realpath profiles/9.11.2/tofino)" p4src/bf_router.p4`
    

## Configure freeRTR-RARE

### Step 1: Download the **freeRouter** source file 

```bash
[nix-shell(SDE-9.11.2):~/freeRtr/]$ wget www.freertr.org/rtr.jar
```

### Step 2: Configure freeRTR

Create 2 configuration files for freeRTR: **tna-freerouter-hw.txt & tna-freerouter-sw.txt** as follow: 

- **tna-freerouter-hw.txt**

```bash
int eth0 eth 0000.1111.00fb 127.0.0.1 22710 127.0.0.1 22709
tcp2vrf 2323 v1 23
tcp2vrf 9080 v1 9080
```

- **tna-freerouter-sw.txt**

```bash
hostname tna-freerouter
buggy
!
!
vr
f definition v1
 exit
!
interface ethernet0
 description freerouter@P4_CPU_PORT[veth251]
 no shutdown
 no log-link-change
 exit
!
interface sdn1
 description freerouter@sdn1[enp0s3]
 mtu 9000
 macaddr 0072.3e18.1b6f
 vrf forwarding v1
 ipv4 address 192.168.0.131 255.255.255.0
 ipv6 address 2a01:e0a:159:2850::666 ffff:ffff:ffff:ffff::
 ipv6 enable
 no shutdown
 no log-link-change
 exit
!
!
!
!
!
!
!
!
!
!
!
!
!
!
server telnet tel
 security protocol telnet
 no exec authorization
 no login authentication
 vrf v1
 exit
!
server p4lang p4
 export-vrf v1 1
 export-port sdn1 0 10
 interconnect ethernet0
 vrf v1
 exit
!
client tcp-checksum transmit
!
end
```

### Step 3: **Prepare for the network interfaces**

Create and run a bash file `bf_switchd_interface_setup.sh` for setup bf_switchd dataplane communication channel via veth pair and interface adjustment:  

```bash
#!/bin/bash

echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6
 
ip link add veth251 type veth peer name veth250
ip link set veth250  up
ip link set veth251  up
 
ifconfig enp0s3 promisc
ifconfig veth250 promisc
ifconfig veth251 promisc
 
ip link set dev veth250 up mtu 10240
ip link set dev veth251 up mtu 10240
ip link set dev enp0s3 up mtu 10240
export TOE_OPTIONS="rx tx sg tso ufo gso gro lro rxvlan txvlan rxhash"
 
for TOE_OPTION in $TOE_OPTIONS; do
    /sbin/ethtool --offload veth250 "$TOE_OPTION" off &> /dev/null
    /sbin/ethtool --offload veth251 "$TOE_OPTION" off &> /dev/null
    /sbin/ethtool --offload enp0s3 "$TOE_OPTION" off &> /dev/null
done
```

### Step 4: Run freeRTR

Launch **freeRouter** with supplied `tna-freerouter-hw.txt` and `tna-freerouter-sw.txt` with a console prompt:

```bash
[nix-shell(SDE-9.11.2):~/freeRtr/]$ java -jar rtr.jar routersc tna-freerouter-hw.txt tna-freerouter-sw.txt
####                       ##################
 ##                                  ##
 ##  ## ###   #####   #####  ## ###  ## ## ###
####  ### ## ##   ## ##   ##  ### ## ##  ### ##
 ##   ##  ## ####### #######  ##  ## ##  ##  ##
 ##   ##     ##      ##       ##     ##  ##
 ##   ##     ##   ## ##   ##  ##     ##  ##
 ##   ##      #####   #####   ##     ##  ##

freeRouter-rare v23.11.2-cur, done by sprscc13@mr.n0b0dy.

place on the web: http://www.freertr.org/
license: http://creativecommons.org/licenses/by-sa/4.0/
the beer-ware,abandon-ware license for selected group of people:
sprscc13@mr.n0b0dy wrote these files. as long as you retain this notice you
can do whatever you want with this stuff. if we meet some day, and
you think this stuff is worth it, you can buy me a beer in return

XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXX XXXXX XXX    XXX     XXX XX XX XXXX XXXXXXXXXXXXXXXXXX
XXXX  XXXX XX XXXX XX XXXX XX XX XX XXXX XXXXXXX/~~~~\XXXXX
XXXX X XXX XX XXXX XX XXXX XX XX XX XXXX XXXXXX| demo |XXXX
XXXX XX XX XX XXXX XX     XXX    XX XXXX XXXXXXX\____/XXXXX
XXXX XXX X XX XXXX XX XXXXXXX XX XX XXXX XXXXXXXXXXXXXXXXXX
XXXX XXXX  XX XXXX XX XXXXXXX XX XX XXXX XXXXXXXXXXXXXXXXXX
XXXX XXXXX XXX    XXX XXX XXX XX XXX    XXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
welcome
line ready
...
tna-freerouter# 
```

### Step 5: Prepare the interface between freeRTR and RARE

Make sure pcap/pcapInt is installed for connectivity setup:

```bash
[nix-shell(SDE-9.11.2):~/freeRtr/misc/native]$ sudo dpkg -l | grep pcap 
ii  libpcap-dev:amd64                             1.9.1-3                                       amd64        development library for libpcap (transitional package)
ii  libpcap0.8:amd64                              1.9.1-3                                       amd64        system interface for user-level packet capture
ii  libpcap0.8-dev:amd64                          1.9.1-3                                       amd64        development library and header files for libpcap0.8
ii  librte-pmd-pcap20.0:amd64                     19.11.14-0ubuntu0.20.04.1                    amd64        Data Plane Development Kit (librte-pmd-pcap runtime library)

```

Configure the connectivity between freeRTR CPU port (eth0) and veth251 to stitch control plane and P4 dataplane communication: 

```bash
[nix-shell(SDE-9.11.2):~/freeRtr/]$ sudo ./binTmp/pcapInt.bin veth251 20002 127.0.0.1 20001 127.0.0.1 
binded to local port 127.0.0.1 20002.
will send to 127.0.0.1 20001.
pcap version: libpcap version 1.9.1 (with TPACKET_V3)
opening interface veth251
serving others
>  
```

### Step 7: Configure RARE

Create a directory for RARE running environment: 

```bash
mkdir -p ~/rare-run/etc ~/rare-run/logs ~/rare-run/mibs ~/rare-run/snmp
```

Create a custom `ports.json` file under the directory of `~/rare-run/etc/` for bf_switchd model: 

```bash
{
    "PortToIf" : [
        { "device_port" :  0, "if" : "enp0s3" },
        { "device_port" : 64, "if" : "veth250" }
    ]
}
```


