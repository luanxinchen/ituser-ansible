执行脚本:
```shell
curl -Lso- http://172.16.2.33:8080/ituser.sh > /tmp/ituser.sh && chmod +x /tmp/ituser.sh && /tmp/ituser.sh
或
. <(curl -Ls http://172.16.2.33:8080/ituser.sh) #执行结束后会退出shell，需要重新登陆
```

查看脚本执行反馈
http://172.16.2.33:8080/sinfo

