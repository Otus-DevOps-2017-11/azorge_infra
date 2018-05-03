# azorge_infra

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

