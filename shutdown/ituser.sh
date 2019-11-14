#!/bin/bash
[ $UID != 0 ] && { echo "Error: You must be root to run this script"; return; }
name=ituser
sshdir=/home/$name/.ssh
pubkey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6g6QBvkZcMjHLT2m3pB8TafzEbvn4yAqIzzZx58lLyktF0mCt17u5Jj15TOkfI/76mYlhxV/W1J3xfQ6LRejab2vSrADHkVlhGcQ0JL98kkUEaMKxQQ6zrez7nYCNhpQMyyyKt7mzAChcovmfo2uLBLkOabQvRYZOs07vLIheltfo13GTRZ9IzOdOUhM83DEpqnEl5/1M3eS8Fmid7+HvMkmFsykxghSpHbha/376uty3b+ml71dazMLrAgdEZU6m9HZ+4c0xdAUCJLj1EBPAg1vCrv+neyMov686VcKpMYw5kBxZ+PsL1wLuWBsmntpQBkssEqa+YuEvtcRnD2hD root@localhost.localdomain"
ipaddr=`ip addr | grep 'state UP' -A2 | grep '172.[12]6' | head -n 1 | awk '{print $2}' | cut -f1 -d '/'`
hostname=`hostname -f`
read -p "Please input the name of the server owner(use email prefix, such as zongyao.zhou) :" ownername

#user creat
useradd $name
if [ $? -eq 0 ];then
   echo "user '${name}' is created success!"
   mkdir -p $sshdir
else
   echo "user '${name}' is creating failed!"
   echo "exit." 
   #exit by return
   return
fi

#pubkey import
echo $pubkey >> $sshdir/authorized_keys
if [ $? -eq 0 ];then
   echo "imported public key success!"
   chown -R $name $sshdir
   chmod 700 $sshdir
   chmod 600 $sshdir/authorized_keys
else
   echo "importing public key failed!"
   rollback;
fi

#SSHconfiguration
sed -i "/PubkeyAuthentication/s/^#//; /PubkeyAuthentication/s/no/yes/" /etc/ssh/sshd_config
if [ $? -eq 0 ];then
   echo "sshd configuration success!"
   if command -v systemctl >/dev/null 2>&1;then
      systemctl restart sshd
   else
      service sshd restart
   fi
   if [ $? -eq 0 ];then
      echo "sshd.service restart success!"
      sshst=OK
   else
      echo "sshd.service restarting failed! Please restart the service manually."
      sshst=Failed
   fi
else
   echo "sshd configuration failed!"
   rollback;
fi

#set sudocommand
sed -i "/Allow root to run any commands anywhere/a $name ALL=(root)NOPASSWD: /sbin/shutdown" /etc/sudoers
if [ $? -eq 0 ];then
   echo "sudo command set success!"
   sudost=OK
else
   echo "sudo command setting failed! please check the sudoers file!"
   sudost=Failed
fi

rollback(){
   userdel $name
   rm -rf /home/$name
   echo "rollback & exit."
   #exit by return
   return
}

#status return
curl http://172.16.2.33:8080/sinfo -X POST -d "ip=${ipaddr}&hn=${hostname}&on=${ownername}&sshst=${sshst}&sudost=${sudost}"

#exit by return
return

