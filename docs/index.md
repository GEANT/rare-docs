---
hide:
  - navigation
---

# **RARE** documentation home

## **Overview**
**RARE** (**R**outer for **A**cademia, **R**esearch & **E**ducation) is an ongoing effort under the [GÉANT 5th programme](https://www.geant.org/Projects/GEANT_Project_GN4-3) which focus on creating an Open Source routing software platform.
The project aims to integrate different pieces of software related to building blocks inherent to a routing stack:

### **Control plane**:
* **RARE** uses **[FreeRtr](http://freerouter.nop.hu/)** under the hood used as the control plane component
### **Programmable dataplane**
* **[P4](https://p4.org/), [DPDK](https://www.dpdk.org/), [XDP](https://prototype-kernel.readthedocs.io/en/latest/networking/XDP/) or [TCPDUMP/libpcap](https://tcpdump.org)** are possible candidates
### **Communication interface**
* This is the interface between the control plane and data plane and it is specific to the target dataplane. For example, [BMv2](https://github.com/p4lang/behavioral-model), the open source P4 virtual switch developed by [p4.org](https://p4,org), uses [P4Runtime](https://github.com/p4lang/p4runtime) in order to expose internal P4 program's object to an external control plane

**[P4](https://p4.org/)** and **[NPL](https://nplang.org/)** are such languages that allows data plane programmability.

!!! note
    **[P4](https://p4.org/)** and **[NPL](https://nplang.org/)** languages attempt to be as much as possible independent from the target or Programmable Ethernet ASIC architecture.
    However architecture dependance is still prominent. Code adjustments followed by a target specific compilation is necessary if you want to run your dataplane program on a specific architecture.

## **How to use this site**
You'll find in this page various guides that will help you deploy and use **RARE** routing platform.

There are 3 categories of documentation:  

### **Reference guides**
This section will guide you in configuring freeRtr control plane. In essence, it is similar to [freeRtr test cases](http://www.freertr.org/tests.html). While the [freeRtr test cases](http://www.freertr.org/tests.html) is convenient as it provides an extensive list of all the features in one page, this section will provide a navigation structure that helps you to find your way among the incredible freeRtr feature and interoperability list. 

### **Installation guides**
**RARE** platform has the particularity to be able to run on top of different dataplanes.   

* If you want to deploy a BGP Route Reflector, no need to run **RARE** & **freeRtr** with a **P4** or **DPDK** dataplane. You can just use **freeRtr** native software dataplane
* At the opposite, if you wish to implement router with 6.4 Tbps capability, your best bet is to run **RARE** & **freeRtr** with an **INTEL/TOFINO P4** dataplane.
* **RARE** with **DPDK** or **P4Emu** dataplane is a perfect fit use case such as SOHO router requiring lower switching capability. (nx1GE,nx10GE or a couple of 100GE) 

### **Cookbooks**
This section corresponds to cookbooks that will guide you in learning how to configure **RARE** for distinct use cases.

