# HackathonInfra
Repositório para infra Kubernetes com Terraform para o Hackathon da Fiap Turma 4SOAT grupo 48


# Preparação

## Intalações
- AWS CLI
- Terraform

## Configurações

### Console AWS {#console-aws}
1. criar um novo usuário para uso no terraform
    1. Não precisa de acesso ao console da AWS;
    1. Atribuir as permissões referentes a EKS;
        ![Permissões terraform](/imgs/permissoes_terraform.png)
    1. Criar uma chave de acesso para este usuário para uso com AWSL CLI
1. Criar um bucket para armazenar o arquivo de controle do terraform
    1. Como o nome do bucket é unico a sugestão é variar o final para o caso de aplicar em várias contas
        - Sugestão para o padrão de nome: terraform-fiap-4soat-g48-RADOM
        - este bucket pode ser para todos os ambientes se quiser
    1. Crie as subpastas dentro do bucket
        - o nome da pasta é que faz a separação dos ambientes
            - ex: dev/4soat-g48/k8s
            - ambiente/turma-grupo/recurso
        1. no caso desse trabalho crie as seguintes pastas
            ```
            +-- dev
            |   +-- k8s
            +-- hml
            |   +-- k8s
            ```

### Local de execução

1. Crie um novo perfil de acesso na AWS passando a chave de acesso e secreat criada para o usuário do terraform (Console AWS > 1 > 3). Para facilitar crie com o nome do perfil indicado;
    ``` sh
    aws configure --profile 4soat_g48
    ```
1. Recupere o ID da conta que será usado para configurar o terraform:
    1. Execute o comando abaixo:
        ```sh
        aws sts get-caller-identity --profile 4soat_g48
        ```
    1. No resultado deste comando pode ser visto o usuário que é atribuido ao perfil cheque se o ARN do resultado do comando é referente ao usuário que você criou no passo anterior (Console AWS > 1);
    1. Ainda no resultado do comando copie o valor da chave "Account"
1. Com o id da conta copiado siga os passos
    1. Acesse a pasta deste projeto chamada [enviroment](/environments/)
    1. Na sequencia acesse a subpasta do ambiente onde serão executadas as criações do ambiente
        1. [Desenvolvimento](/environments/dev/)
    1. No arquivo **locals.tf** cole o ID da conta copiado anteriormente na variavel local chamada **aws_account_id**
1. Com o bucket criado deve ser configurado o backend do terraform
    1. Acesse a pasta deste projeto chamada [enviroment](/environments/)
    1. Na sequencia acesse a subpasta do ambiente onde serão executadas as criações do ambiente
        1. [Desenvolvimento](/environments/dev/)
    1. No arquivo **terraform.tf** configure o nome do bucket no parametro **bucket**



# Execução

1. Via terminal entre na pasta do ambiente que deve ser executada;
1. Execute o comando de inicialização
    ``` shell
    terraform init
    ```
1. Execute o planejamento
    ```
    terraform plan -out=plan.out
    ````
1. Aplique o planejamento
    ```
    terraform apply "plan.out"
    ```


# Destroi (para testes)

1. Via terminal entre na pasta do ambiente que deve ser executada;
1. Execute o comando de destruição para todo o ambiente
    ``` shell
    terraform destroy
    ```
1. Execute o comando de destruição para todos os recursos menos os ECRs
    ``` shell
    terraform destroy -target=module.vpc -target=module.ecs_pedido -target=module.ecs_pagamento -target=module.ecs_producao -target=module.orquestracao -target=module.rds -target=module.docdb -target=module.rabbitmq
    ```