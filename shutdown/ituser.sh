#!/bin/bash
if [ $UID != 0 ];then
   echo "Please use the root user"
   exit 0
fi 
name=ituser
passwd=Password@12345
useradd $name
echo $passwd | sudo passwd $name --stdin  &>/dev/null
#passwd $name  --stdin "$passwd"
if [ $? -eq 0 ];then
   echo "user ${name} is created success!"
else
   echo "user ${name} is created failed!!!"
   exit 1
fi
sed -i "/Allow root to run any commands anywhere/a $name ALL=(root)NOPASSWD: /sbin/shutdown" /etc/sudoers
if [ $? -eq 0 ];then
   echo "sudoers is set success! "
else
   echo "sudoers is set failed!!!"
fi
exit
