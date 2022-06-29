# Objetivo
Subir um cluster na nuvem (AWS + SPOT)

# Vombora

Instala o kops, configura os arquivos pra dar acesso à tua conta do spot e da AWS (~/.aws/credentials e ~/.spotinst/credentials) 
https://kops.sigs.k8s.io/getting_started/install/
https://kops.sigs.k8s.io/getting_started/spot-ocean/
https://kops.sigs.k8s.io/getting_started/aws/#setup-your-environment

As variaveis abaixo sao pra criar o cluster.
Fica a vontade pra modificar de acodo com o seu contexto.

```
export CLUSTERNAME=clustertestetony # o nome do cluster
export AWS_REGION=us-east-2 # regiao onde vai criar
export AWS_ZONES=us-east-2a,us-east-2b # zonas pra criar instance-groups
export DOMAIN=busercamp.com.br # dominio pra usar (vc precisa ter um hosted zone no Route53)
export STATEBUCKET=busercamp-kops-state-store # bucket pra salvar o estado do cluster
export OIDCBUCKET=busercamp-kops-oidc-store # outro bucket pro cluster usar (nao entendi pra que)
```

Cria o usuario do kops na AWS

`01_create_aws_user.sh`

o ultimo comando do script acima gera um cara que vc pode mandar pro \~/.aws/credentials

Cria os 2 buckets que o cluster precisa

`02_create_buckets.sh`

Cria o cluster

```
export KOPS_FEATURE_FLAGS="Spotinst,SpotinstOcean,SpotinstOceanTemplate"
export KOPS_STATE_STORE=s3://${STATEBUCKET}

# precisa estar o tempo todo com essas variaveis setadas. uma merda.
# mehor botar logo no .bashrc

kops create cluster --zones=$AWS_ZONES $CLUSTERNAME.$DOMAIN --discovery-store=s3://${OIDCBUCKET}
```

Na verdade isso nao criou cluster nenhum. Só escreveu um arquivo lá no s3. Pode ir la ver

Aih vc pode baixar esses arquivos, salvar e mexer um pouquinho antes de mandar criar as paradas de verdade

```
kops get $CLUSTERNAME.$DOMAIN -o yaml > cluster.yaml
```

edita o yaml:
- muda o machinetype do master pra t3.small
- muda o machinetype dos node pra micro
- ...

atualiza no s3 

```
kops replace -f cluster.yaml
```

cria o cluster

```
kops update cluster --name $CLUSTERNAME.$DOMAIN
kops update cluster --name $CLUSTERNAME.$DOMAIN --yes --admin
```

vai la brincar

```
ssh -i ~/.ssh/id_rsa ubuntu@api.clustertestetony.busercamp.com.br

kops rolling-update cluster
kops rolling-update cluster --yes

kubectl...

```


Outras sugestoes do proprio kops

```
Suggestions:
 * validate cluster: kops validate cluster --wait 10m
 * list nodes: kubectl get nodes --show-labels
 * ssh to the master: ssh -i ~/.ssh/id_rsa ubuntu@api.clustertestetony.busercamp.com.br
 * the ubuntu user is specific to Ubuntu. If not using Ubuntu please use the appropriate user based on your OS.
 * read about installing addons at: https://kops.sigs.k8s.io/addons.

```

destroi tudo

```
kops delete cluster $CLUSTERNAME.$DOMAIN
kops delete cluster $CLUSTERNAME.$DOMAIN --yes
aws s3api delete-bucket --bucket ${STATEBUCKET}
aws s3api delete-bucket --bucket ${OIDCBUCKET}
```
