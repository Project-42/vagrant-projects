. /vagrant/config/setup.env

if [ `hostname` == ${NODE1_HOSTNAME} ]
then
  cat >> /etc/oratab << EOF
+ASM1:${GI_HOME}:N
EOF
fi

if [ `hostname` == ${NODE2_HOSTNAME} ]
then
  cat >> /etc/oratab << EOF
+ASM2:${GI_HOME}:N
EOF
fi
