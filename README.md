## 💡 Idea
Rancher Kubernetes Engine (RKE) is an open-source container orchestration platform that uses a graphical interface to help manage Kubernetes (k8s).
In this lab, we will create a small test environment with one control plane / etcd and two workers, i.e., this way we will not have high-availability (H.A), with nodes are created automatically through Vagrant.

![Screenshot](Rancher-vagrant.png)

---

### 🛠️ Worked wuth
* Vagrant
* Docker
* Rancher
* Script Bash

---

### 🚀 Process

1. Após a configuração das ferramentas solicitadas, iniciamos com o comando ```terraform apply``` no diretório raiz do projeto. Confirme caso solicite a criação de um recurso EC2.

2. Após o terraform criar a infraestrutura, ele chamará localmente (local-exec) o ansible para instalar o docker e suas dependencias no EC2 provisionado.

3. Após instalar o docker, ele irá transferir (file) um script bash de configuração do swarm e o arquivo do compose com os detalhes do container.

4. Após a transferência, será executado o script bash, que irá subir o mysql e wordpress.

5. Dentro poucos minutos desde o comando (terraform apply) o wordpress já estará disponível para acesso pela internet!

---

### 🐛 Bug

* As vezes pode ocorrer de não se executar a tarefa do ansible, por causa do _provisioner local-exec/remote-exec_. Uma parte da documentação do terraform diz que estes _provisioners_ devem ser utilizados como último recurso e explica o por que de o host ficar "unreacheble" em alguns casos: "Note that even though the resource will be fully created when the provisioner is run, there is no guarantee that it will be in an operable state - for example system services such as sshd may not be started yet on compute resources.". Como é um laboratório, eu executo novamente o terraform que recria o EC2 e executa novamente.

---

