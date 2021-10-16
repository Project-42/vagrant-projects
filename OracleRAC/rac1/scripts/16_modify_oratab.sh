. /vagrant/config/setup.env

if [ `hostname` == ${NODE1_HOSTNAME} ]
then
  cat >> /etc/oratab << EOF
${DB_NAME}1:${DB_HOME}:N
${DB2_NAME}1:${DB2_HOME}:N
EOF
fi

if [ `hostname` == ${NODE2_HOSTNAME} ]
then
  cat >> /etc/oratab << EOF
${DB_NAME}2:${DB_HOME}:N
${DB2_NAME}2:${DB2_HOME}:N
EOF
fi
