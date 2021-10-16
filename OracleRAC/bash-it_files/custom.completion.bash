### FUNCTIONS ###

hi (){
history |grep -i $1
}

start (){
virsh start $1
}

stop (){
virsh shutdown $1
}

destroy (){
virsh destroy $1
}

ali (){
alias |grep -i $1
}
