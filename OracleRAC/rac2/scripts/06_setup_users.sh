#!/bin/bash
#│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#
# LICENSE UPL 1.0
#
# Copyright (c) 1982-2020 Oracle and/or its affiliates. All rights reserved.
#
#    NAME
#      06_setup_users.sh
#
#    DESCRIPTION
#      Setup oracle & grid users
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

echo "-----------------------------------------------------------------"
echo -e "${INFO}`date +%F' '%T`: Setup oracle and grid user"
echo "-----------------------------------------------------------------"
userdel -fr oracle
groupdel oinstall
groupdel dba
groupdel backupdba
groupdel dgdba
groupdel kmdba
groupdel racdba
groupadd -g 1001 oinstall
groupadd -g 1002 dbaoper
groupadd -g 1003 dba
groupadd -g 1004 asmadmin
groupadd -g 1005 asmoper
groupadd -g 1006 asmdba
groupadd -g 1007 backupdba
groupadd -g 1008 dgdba
groupadd -g 1009 kmdba
groupadd -g 1010 racdba
useradd oracle -d /home/oracle -m -p $(echo "welcome1" | openssl passwd -1 -stdin) -g 1001 -G 1002,1003,1006,1007,1008,1009,1010
useradd grid   -d /home/grid   -m -p $(echo "welcome1" | openssl passwd -1 -stdin) -g 1001 -G 1002,1003,1004,1005,1006
# Add oracle to sudo
echo "oracle        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

echo "-----------------------------------------------------------------"
echo -e "${INFO}`date +%F' '%T`: Set oracle and grid limits"
echo "-----------------------------------------------------------------"
cat << EOL >> /etc/security/limits.conf
# Grid user
grid soft nofile 131072
grid hard nofile 131072
grid soft nproc 131072
grid hard nproc 131072
grid soft core unlimited
grid hard core unlimited
grid soft memlock 98728941
grid hard memlock 98728941
grid soft stack 10240
grid hard stack 32768
# Oracle user
oracle soft nofile 131072
oracle hard nofile 131072
oracle soft nproc 131072
oracle hard nproc 131072
oracle soft core unlimited
oracle hard core unlimited
oracle soft memlock 98728941
oracle hard memlock 98728941
oracle soft stack 10240
oracle hard stack 32768
EOL

echo "-----------------------------------------------------------------"
echo -e "${INFO}`date +%F' '%T`: Create GI_HOME and DB_HOME directories"
echo "-----------------------------------------------------------------"
mkdir -p ${GRID_BASE}
mkdir -p ${DB_BASE}
mkdir -p ${GI_HOME}
mkdir -p ${DB_HOME}
mkdir -p ${DB2_HOME}
chown -R grid:oinstall /u01
chown -R grid:oinstall ${GRID_BASE}
chown -R grid:oinstall ${GI_HOME}
chown -R oracle:oinstall ${DB_BASE}
chown -R oracle:oinstall ${DB_HOME}
chown -R oracle:oinstall ${DB2_HOME}
chmod -R ug+rw /u01

echo "-----------------------------------------------------------------"
echo -e "${INFO}`date +%F' '%T`: Set user env"
echo "-----------------------------------------------------------------"
if [ `hostname` == ${NODE1_HOSTNAME} ]
then
  cat >> /home/grid/.bash_profile << EOF
export ORACLE_HOME=${GI_HOME}
export PATH=\$ORACLE_HOME/bin:~/bin:~/.local/bin:$PATH
export ORACLE_SID=+ASM1
echo ""
echo "PMON processes running"
ps -ef |grep pmon |grep -v grep
EOF

  cat >> /home/oracle/.bash_profile << EOF
export ORACLE_HOME=${DB_HOME}
export PATH=\$ORACLE_HOME/bin:~/bin:~/.local/bin:$PATH
export ORACLE_SID=${DB_NAME}1
echo ""
echo "PMON processes running"
ps -ef |grep pmon |grep -v grep
EOF
fi

if [ `hostname` == ${NODE2_HOSTNAME} ]
then
  cat >> /home/grid/.bash_profile << EOF
export ORACLE_HOME=${GI_HOME}
export PATH=\$ORACLE_HOME/bin:~/bin:~/.local/bin:$PATH
export ORACLE_SID=+ASM2
echo ""
echo "PMON processes running"
ps -ef |grep pmon |grep -v grep
EOF

  cat >> /home/oracle/.bash_profile << EOF
export ORACLE_HOME=${DB_HOME}
export PATH=\$ORACLE_HOME/bin:~/bin:~/.local/bin:$PATH
export ORACLE_SID=${DB_NAME}2
echo ""
echo "PMON processes running"
ps -ef |grep pmon |grep -v grep
EOF
fi


echo "-----------------------------------------------------------------"
echo -e "${INFO}`date +%F' '%T`: Installing bash-it"
echo "-----------------------------------------------------------------"

git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it ; yes | ~/.bash_it/install.sh
su -l oracle -c "git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it ; yes | ~/.bash_it/install.sh"
su -l grid -c "git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it ; yes | ~/.bash_it/install.sh"

cp -pr /vagrant/bash-it_files/custom.bash /root/.bash_it/lib/custom.bash
cp -pr /vagrant/bash-it_files/custom.completion.bash /root/.bash_it/completion/custom.completion.bash
cp -pr /vagrant/bash-it_files/bobby.theme.bash /root/.bash_it/themes/bobby/bobby.theme.bash
cp -pr /vagrant/bash-it_files/custom.aliases.bash /root/.bash_it/aliases/custom.aliases.bash


for i in {oracle,grid} ; do
cp -pr /root/.bash_it/lib/custom.bash /home/$i/.bash_it/lib/custom.bash
cp -pr /root/.bash_it/completion/custom.completion.bash /home/$i/.bash_it/completion/custom.completion.bash
cp -pr /root/.bash_it/themes/bobby/bobby.theme.bash /home/$i/.bash_it/themes/bobby/bobby.theme.bash
cp -pr /root/.bash_it/aliases/custom.aliases.bash /home/$i/.bash_it/aliases/custom.aliases.bash
chown -R $i:oinstall /home/$i/.bash_it/lib/custom.bash /home/$i/.bash_it/completion/custom.completion.bash /home/$i/.bash_it/themes/bobby/bobby.theme.bash /home/$i/.bash_it/aliases/custom.aliases.bash
done

echo "-----------------------------------------------------------------"
echo -e "${INFO}`date +%F' '%T`: Installing Fred Denis oracle-scripts"
echo "-----------------------------------------------------------------"

su -l oracle -c "mkdir /home/oracle/bin ; git clone https://github.com/freddenis/oracle-scripts.git /home/oracle/bin"
su -l grid -c "mkdir /home/grid/bin ; git clone https://github.com/freddenis/oracle-scripts.git /home/grid/bin"
chmod +x -R /home/oracle/bin/* /home/grid/bin/* 

echo "-----------------------------------------------------------------"
echo -e "${INFO}`date +%F' '%T`: Installing sqlcl using Connor's Script "
echo "-----------------------------------------------------------------"
su -l oracle -c "git clone https://github.com/connormcd/misc-scripts.git /home/oracle/bin"
su -l oracle -c "chmod +x -R /home/oracle/bin/*"
su -l oracle -c "/home/oracle/bin/getsqlcl.sh"


#----------------------------------------------------------
# EndOfFile
#----------------------------------------------------------
