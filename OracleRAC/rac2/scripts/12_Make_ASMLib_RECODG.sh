#!/bin/bash
#│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#
# LICENSE UPL 1.0
#
# Copyright (c) 1982-2020 Oracle and/or its affiliates. All rights reserved.
#
#    NAME
#      12_Make_ASMLib_RECODG.sh
#
#    DESCRIPTION
#      Make RECO DG
#
#    NOTES
#       DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
#
#    AUTHOR
#       Ruggero Citton - RAC Pack, Cloud Innovation and Solution Engineering Team
#
#    MODIFIED   (MM/DD/YY)
#    rcitton     03/30/20 - VBox libvirt & kvm support
#    rcitton     11/06/18 - Creation
#
#    REVISION
#    20200330 - $Revision: 2.0.2.1 $
#
#│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒│
. /vagrant/config/setup.env
export ORACLE_HOME=${GI_HOME}
if [ "${ORESTART}" == "false" ]
then
  export ORACLE_SID=+ASM1
else
  export ORACLE_SID=+ASM
fi

DISKS_STRING=""
declare -a DEVICES
for device in /dev/oracleasm/disks/ORCL_DISK*_P2
do
  DEVICES=("${dev[@]}" "$device")
  DISK=$(basename "$DEVICES")
  DISKS_STRING=${DISKS_STRING}"DISK '"${DEVICES}"' NAME "${DISK}" "
done

#echo $DISKS_STRING



${GI_HOME}/bin/sqlplus / as sysasm <<EOF
CREATE DISKGROUP RECO EXTERNAL REDUNDANCY 
 ${DISKS_STRING}
 ATTRIBUTE 
   'compatible.asm'='11.2.0.2.0', 
   'compatible.rdbms'='11.2.0.2.0',
   'compatible.advm'='11.2.0.2.0',
   'sector_size'='512',
   'AU_SIZE'='4M';

EOF
#----------------------------------------------------------
# EndOfFile
#----------------------------------------------------------
