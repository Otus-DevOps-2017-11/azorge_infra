# azorge_infra
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

