### FUNCTIONS ###

hi (){
history |grep -i $1
}


ali (){
alias |grep -i $1
}


dbstop (){
srvctl stop database -d ${ORACLE_SID::-1}
}

dbstart (){
srvctl start database -d ${ORACLE_SID::-1}
}


dbrestart (){
srvctl stop database -d ${ORACLE_SID::-1}
srvctl start database -d ${ORACLE_SID::-1}
}
