# azorge_infra
#### Homework 10:

1. создание инвентори файлов для ansible в разных форматах:
```
ansible all -m ping -i inventory
ansible all -m ping -i inventory.yml
ansible all -m ping -i inventory.json
```
2. разделение хостов по группам
3. использование ansible модулей: `command, shell, git, systemd, service` 


#### Homework 9:

Настройка и хранение стейт файлов на удаленном бэкэнде gcs <br/>
```
cd stage\prod
terraform init
terraform apply -auto-approve=true
terraform destroy 
```

 В `modules/app` и `modules/db` добавил `provisioner "file"` и `provisioner "remote-exec"`
 для запуска приложения.

#### Homework 8:
1. Определение `input` переменных для приватного ключа и зоны.
2. Заполнен `terraform.tfvars.example`
3. форматирование terraform конфигов с помощью `terraform fmt`

`*` и `**`:
1. Описано добавление ключей для `appuser,appuser2,appuser3`
2. Добален HTTP балансировщик
3. Через параметр `count` настраивается количество инстансов с приложением (по дефолту 1)


#### Homework 7:
reddit-base шаблон: <br/>
`packer validate -var-file=variables.json mod_ubuntu16.json` <br/>
`packer build -var-file=variables.json mod_ubuntu16.json`

reddit-full шаблон:<br/>
`packer validate -var-file=variables.json immutable.json` <br/>
`packer build -var-file=variables.json immutable.json`

```
cat config-scripts/create-reddit-vm.sh 
#!/usr/bin/env bash

gcloud compute instances create reddit-app  --boot-disk-size=10GB --image-family=reddit-full --tags "default-puma-server" --preemptible  --restart-on-failure
```

#### Homework 6:
1. Удаляем фаервол правило: <br/>
`gcloud compute firewall-rules delete default-puma-server`

2. Создаем новое правило для фаервола: <br/>
`gcloud compute firewall-rules create default-puma-server --allow tcp:9292 --source-tags=puma-server --source-ranges=0.0.0.0/0 --description="allow 9292 port"`

3. Создаем vm и деплоим приложение: <br/>
startup-script <br/>
`gcloud compute instances create reddit-app-for-test --boot-disk-size=10GB --image-family ubuntu-1604-lts  --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --zone=europe-west1-b --metadata-from-file startup-script=startup_script.sh`<br/>
или startup-script-url<br/>
`gcloud compute instances create reddit-app-for-test --boot-disk-size=10GB --image-family ubuntu-1604-lts  --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --zone=europe-west1-b --metadata-from-file startup-script-url=http://url_to_startup_script.sh`

 
#### Homework 5:
1. подключения к `internalhost` в одну команду с локального хоста:<br />
`ssh -t -A appuser@35.195.53.45 ssh 10.132.0.3`

2. Для подключения через `ssh internalhost`, добавляем в `~/.ssh/config`:
<pre>Host *
 AddKeysToAgent yes
 UseKeychain yes
 IdentityFile ~/.ssh/appuser
 ForwardAgent yes
<br />
Host bastion
HostName 35.205.203.37
User appuser
<br />
Host internalhost
HostName 10.132.0.4
User appuser
ProxyCommand ssh bastion nc %h %p</pre>

<pre>Host: bastion, ext IP: 35.195.53.45, int IP: 10.132.0.3
Host: someinternalhost, ext IP: 10.132.0.4</pre>

