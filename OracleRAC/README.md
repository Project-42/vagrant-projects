# Oracle Real Application Cluster (RAC) Vagrant project on VirtualBox or KVM/libVirt provider

###### Original Author: Ruggero Citton (<ruggero.citton@oracle.com>) - Orale RAC Pack, Cloud Innovation and Solution Engineering Team

This directory contains Vagrant build files to provision automatically
two Oracle RAC nodes (12.2, 18c, 19c, 21c), using Vagrant, Oracle Linux 7 and shell scripts.


## PORJECT42 Modifications ##
This is the list of modifications made to the amazing original project https://github.com/oracle/vagrant-projects

- Second rac cluster added to be deployed independtly
- Extra 19c Database created in cluster "rac1" *(See "db2_name:/db2_home/pdb2_name" etc.. under "config/vagrant.yml")*
- No databases are created in "rac2" *(The intention is to create more scripts to create Standby Databases there)*
- Extra packages installed *(nano highlight git mlocate bash-completion bash-it)*
- Extra packages to be able to install 11g databases *(elfutils-libelf-devel-0* gcc-4*x86_64* gcc-c++-4*x86_64* numactl-devel-2*x86_64*)*
- Changed Diskgroups to have External Redundancy and RDBMS compatibility to 11.2 in RECO case *(Seems like you still need to change "_asm_allow_older_clients" to TRUE to be able to install 11g)*
- Bash profile modified (Current SID configured and pmon processes running)
- oracle user added to sudoers with no password *(I know, not very secure, but this is for a test after all :) )*
- DNS 8.8.8.8 added to resolv.conf
- ORCL_software moved to have a central place for both Clusters
- Added extra script to modify oratab file *(Not working for second node of the cluster though :()*
- Fred Denis [oracle-scripts](https://github.com/freddenis/oracle-scripts/) downloaded into */home/$USER/bin*
- sqlcl installed using [Connor Mcdonald "getsqlcl" script](https://connor-mcdonald.com/2021/10/29/keeping-my-sqlcl-toasty-fresh/)

![image](images/P42_Vagrant_RACs.png)



## Prerequisites

1. Read the [prerequisites in the top level README](../README.md#prerequisites) to set up Vagrant with either VirtualBox or KVM
1. You need to download Database binary separately

## Free disk space requirement

- Grid Infrastructure and Database binary zip under "./ORCL_software": ~9.3 Gb
- Grid Infrastructure and Database binary on u01 vdisk (node1/node2): ~20 Gb
- OS guest vdisk (node1/node2): ~2 Gb
  - In case of KVM/libVirt provider, the disk is created under `storage pool = "storage_pool_name"`
  - In case of VirtualBox
    - Use `VBoxManage list systemproperties |grep folder` to find out the current VM default location
    - Use `VBoxManage setproperty machinefolder <your path>` to set VM default location
- ASM shared virtual disks (fixed size): ~80 Gb

## Memory requirement

Running two nodes RAC at least 6Gb per node are required
Using Oracle Restart, only one node it's active

## VirtualBox host-Only

The guest VMs are using an "host-Only" network defined as 'vboxnet0'

## Getting started

1. Clone this repository `git clone https://github.com/Project-42/vagrant-projects.git`
2. Change into OracleRAC folder (`./vagrant-projects/OracleRAC`)
3. Download Grid Infrastructure and Database binary from OTN into `./ORCL_software` folder (*)
4. Run `vagrant up`
5. Connect to the database.
6. You can shut down the VM via the usual `vagrant halt` and the start it up again via `vagrant up`.

(*) Download Grid Infrastructure and Database binary from OTN into `ORCL_software` folder
https://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html

    Accept License Agreement
    go to version (12.2, 18c, 19c, 21c) for Linux x86-64 you need -> "See All", example

    * Oracle Database 21c Grid Infrastructure (21.3) for Linux x86-64
        LINUX.X64_213000_grid_home.zip (2,422,217,613 bytes)
        (sha256sum - 070d4471bc067b1290bdcee6b1c1fff2f21329d2839301e334bcb2a3d12353a3)

    * Oracle Database 21c (21.3) for Linux x86-64
       LINUX.X64_213000_db_home.zip (3,109,225,519 bytes)
       (sha256sum - c05d5c32a72b9bf84ab6babb49aee99cbb403930406aabe3cf2f94f1d35e0916)

## Customization

You can customize your Oracle environment by amending the parameters in the configuration file: `./config/vagrant.yml`
The following can be customized:

#### node1/node2

- `vm_name`:    VM Guest partial name. The full name will be <prefix_name>-<vm_name>
- `mem_size`:   VM Guest memory size Mb (minimum 6Gb --> 6144)
- `cpus`:       VM Guest virtual cores
- `public_ip`:  VM public ip. VirtualBox `vboxnet0` hostonly is in use
- `vip_ip`:     Oracle RAC VirtualIP (VIP). VirtualBox 'vboxnet0' hostonly is in use
- `private_ip`: VM private ip.
- `storage_pool_name`: KVM/libVirt storage pool name
- `u01_disk`:          VirtualBox Oracle binary virtual disk (u01) file path

#### shared network

- `prefix_name`:    VM Guest prefix name (the GI cluster name will be: <prefix_name>-c')
- `domain`  :       VM Guest domain name
- `scan_ip1`:       Oracle RAC SCAN IP1
- `scan_ip2`:       Oracle RAC SCAN IP2
- `scan_ip3`:       Oracle RAC SCAN IP3

#### shared storage

- `storage_pool_name`: KVM/libVirt Oradata dbf KVM storage pool name
- `oradata_disk_path`: VirtualBox Oradata dbf path
- `asm_disk_num`:      Oracle RAC Automatic Storage Manager virtual disk number (min 4)
- `asm_disk_size`:     Oracle RAC Automatic Storage Manager virtual disk size in Gb (at least 10)
- `asm_lib_type`:      Oracle ASM filter driver (asmfd) or Oracle ASMlib (asmlib)
- `p1_ratio`:          ASM disks partiton ration (%). Min 10%, Max 80%

#### environment

- `provider`:         It's defining the provider to be used: 'libvirt' or 'virtualbox'
- `grid_software`:    Oracle Database XXc Grid Infrastructure for Linux x86-64 zip file
- `db_software`:      Oracle Database XXc for Linux x86-64 zip file
- `db2_software`:     Oracle Database XXc for Linux x86-64 zip file for Second Database
- `root_password`:    VM Guest root password
- `grid_password`:    VM Guest grid password
- `oracle_password`:  VM Guest oracle password
- `sys_password`:     Oracled RDBMS SYS password
- `pdb_password`:     Oracled PDB SYS password
- `pdb2_password`:    Oracled PDB2 SYS password 
- `ora_languages`:    Oracle products languages
- `nomgmtdb`:         Oracle GI Management database creation (true/false)
- `orestart`:         Oracle GI configured as Oracle Restart (true/false)
- `db_name`:          Oracle RDBMS database name
- `db2_name`:         Oracle RDBMS database name for Second CDB
- `pdb_name`:         Oracle RDBMS pluggable database name
- `pdb2_name`:        Oracle RDBMS pluggable database name for Second CDB
- `db_type`:          Oracle RDBMS type: RAC, RACONE, SI (single Instance)
- `cdb`:              Oracle RDBMS database created as container (true/false)



#### RAC1 Example:
-- vagrant-projects/OracleRAC/rac1/config/vagrant.yml

```bash
node1:
  vm_name: rac1-node1
  mem_size: 16384
  cpus: 24
  public_ip:  192.168.125.111
  vip_ip:     192.168.125.151
  private_ip: 192.168.200.101
  storage_pool_name: Vagrant_RAC_Storage

node2:
  vm_name: rac1-node2
  mem_size: 16384
  cpus: 24
  public_ip:  192.168.125.112
  vip_ip:     192.168.125.152
  private_ip: 192.168.200.102
  storage_pool_name: Vagrant_RAC_Storage

shared:
  prefix_name:   rac1
  # ---------------------------------------------
  domain  : localdomain
  scan_ip1: 192.168.125.125
  scan_ip2: 192.168.125.126
  scan_ip3: 192.168.125.127
  # ---------------------------------------------
  asm_disk_num:   6
  asm_disk_size: 20
  p1_ratio:      80
  asm_lib_type: 'ASMLIB'
  storage_pool_name: Vagrant_RAC_Storage
  # ---------------------------------------------

env:
  provider: libvirt
  # ---------------------------------------------
  gi_software:     LINUX.X64_213000_grid_home.zip
  db_software:     LINUX.X64_213000_db_home.zip
  db2_software:    LINUX.X64_193000_db_home.zip
  # ---------------------------------------------
  root_password:   Welcome1
  grid_password:   Welcome1
  oracle_password: Welcome1
  sys_password:    Welcome1
  pdb_password:    Welcome1
  pdb2_password:   Welcome1
  # ---------------------------------------------
  ora_languages:   en,en_GB
  # ---------------------------------------------
  nomgmtdb:        true
  orestart:        false
  # ---------------------------------------------
  db_name:         CDB21
  pdb_name:        PDB211
  db_type:         RAC
  cdb:             true
  db2_name:        CDB19
  pdb2_name:       PDB191
  db2_type:        RAC
  cdb:             true
  # ---------------------------------------------
```

#### RAC2 Example:
-- vagrant-projects/OracleRAC/rac2/config/vagrant.yml

```bash
node1:
  vm_name: rac2-node1
  mem_size: 16384
  cpus: 24
  public_ip:  192.168.125.121
  vip_ip:     192.168.125.141
  private_ip: 192.168.200.111
  storage_pool_name: Vagrant_RAC_Storage

node2:
  vm_name: rac2-node2
  mem_size: 16384
  cpus: 24
  public_ip:  192.168.125.122
  vip_ip:     192.168.125.142
  private_ip: 192.168.200.112
  storage_pool_name: Vagrant_RAC_Storage

shared:
  prefix_name:   rac2
  # ---------------------------------------------
  domain  : localdomain
  scan_ip1: 192.168.125.145
  scan_ip2: 192.168.125.146
  scan_ip3: 192.168.125.147
  # ---------------------------------------------
  asm_disk_num:   6
  asm_disk_size: 20
  p1_ratio:      80
  asm_lib_type: 'ASMLIB'
  storage_pool_name: Vagrant_RAC_Storage
  # ---------------------------------------------

env:
  provider: libvirt
  # ---------------------------------------------
  gi_software:     LINUX.X64_213000_grid_home.zip
  db_software:     LINUX.X64_213000_db_home.zip
  db2_software:    LINUX.X64_193000_db_home.zip
  # ---------------------------------------------
  root_password:   Welcome1
  grid_password:   Welcome1
  oracle_password: Welcome1
  sys_password:    Welcome1
  pdb_password:    Welcome1
  # ---------------------------------------------
  ora_languages:   en,en_GB
  # ---------------------------------------------
  nomgmtdb:        true
  orestart:        false
  # ---------------------------------------------
  #  db_name:         CDB21
  #  pdb_name:        PDB211
  db_type:         RAC
  #  cdb:             true
  #  db2_name:        CDB19
  #  pdb2_name:       PDB191
  db2_type:        RAC
  #  cdb:             true
  # ---------------------------------------------

```



## Running scripts after setup

You can have the installer run scripts after setup by putting them in the `userscripts` directory below the directory where you have this file checked out. Any shell (`.sh`) or SQL (`.sql`) scripts you put in the `userscripts` directory will be executed by the installer after the database is set up and started. Only shell and SQL scripts will be executed; all other files will be ignored. These scripts are completely optional.
Shell scripts will be executed as the root user, which has sudo privileges. SQL scripts will be executed as SYS.
To run scripts in a specific order, prefix the file names with a number, e.g., `01_shellscript.sh`, `02_tablespaces.sql`, `03_shellscript2.sh`, etc.

## Note

- `SYSTEM_TIMEZONE`: `automatically set (see below)`
  The system time zone is used by the database for SYSDATE/SYSTIMESTAMP.
  The guest time zone will be set to the host time zone when the host time zone is a full hour offset from GMT.
  When the host time zone isn't a full hour offset from GMT (e.g., in India and parts of Australia), the guest time zone will be set to UTC.
  You can specify a different time zone using a time zone name (e.g., "America/Los_Angeles") or an offset from GMT (e.g., "Etc/GMT-2"). For more information on specifying time zones, see [List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).
- Wallet Zip file location `/tmp/wallet_<pdb name>.zip`.
  Copy the file on client machine, unzip and set TNS_ADMIN to Wallet loc. Connect to DB using Oracle Sql Client or using your App
- Using KVM/libVirt provider you may need add a firewall rule to permit NFS shared folder mounted on the guest

    example: using 'uwf' : `sudo ufw allow to 192.168.121.1` where 192.168.121.1 is the IP for the `vagrant-libvirt` network (created by vagrant automatically)

      virsh net-dumpxml vagrant-libvirt
      <network connections='1' ipv6='yes'>
        <name>vagrant-libvirt</name>
        <uuid>d2579032-4e5e-4c3f-9d42-19b6c64ac609</uuid>
        <forward mode='nat'>
          <nat>
            <port start='1024' end='65535'/>
          </nat>
        </forward>
        <bridge name='virbr1' stp='on' delay='0'/>
        <mac address='52:54:00:05:12:14'/>
        <ip address='192.168.121.1' netmask='255.255.255.0'>
          <dhcp>
            <range start='192.168.121.1' end='192.168.121.254'/>
          </dhcp>
        </ip>
      </network>
- If you are behind a proxy, set the following env variables
  - (Linux/MacOSX)
    - export http_proxy=http://proxy:port
    - export https_proxy=https://proxy:port
  -(Windows)
    - set http_proxy=http://proxy:port
    - set https_proxy=https://proxy:port
