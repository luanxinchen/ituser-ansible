# Ansible-Playbook

## 1.Prometheus

### node_exporter

`ansible-playbook ./roles/node_exporter.yml`

说明：一键部署node_exporter并添加到systemd启动

* 默认安装路径`/usr/local/prometheus`
* 默认textfile_collector路径：`/usr/local/prometheus/textfile_collector`
* systemd文件路径`/usr/lib/systemd/system/node_exporter.service`
* 手动启动、重启`systemctl start/restart node_exporter`

> 文件依赖：
`./prometheus/node_exporter{version}.tar.gz` 
`./prometheus/node_exporter.service`

### storcli.py

`ansible-playbook ./roles/storcli.yml`

说明：部署storcli和探针脚本并添加到crontab启动

* storcli安装路径`/opt/MegaRAID/storcli/storcli64`
* script默认工作路径`/usr/local/prometheus/textfile_collector`
* crontab刷新时间`30`分钟
* metric文件`/usr/local/prometheus/textfile_collector/storcli.prom`

> 文件依赖：
`./prometheus/storcli.py`
`./prometheus/storcli-1.14.12-1.noarch.rpm`

## 2.shutdown

`ansible-playbook ./shutdown/shutdown.yml`

说明：批量关机playbook

`./shutdown/ituser.sh`

说明：一键添加关机用到的ituser用户，并增加/sbin/shutdown执行权限