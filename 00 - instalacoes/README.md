# Instala o basicao

* Instala o docker
* Instala o minikube
* Instala o kubectl
* Se pá já instala o kops tb

Instala o autocomplete do kubectl pro bash

```
kubectl completion bash > ~/.autokube
kops completion bash > ~/.autokops
```

edita o \~/.bashrc e add

```
source $HOME/.autokube
source $HOME/.autokops
```

# Valida se as ferramentas estão ok

Sobe o minikube, testa o kubectl, entra no minikube e brinca um pouquinho

```
minikube start
kubectl get all
minikube ssh
docker ps
exit
minikube dashboard
```
