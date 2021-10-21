# terraform-mba

## Objetivo é criar um VM que tenha o mysql rodando na porta 3306.

### Para acessar a base é necessário seguir os passos abaixo:

* Clonar o projeto
* entrar na pasta do projeto
* executar no terminal os comandos a seguir.
* terraform init
* terraform apply (esperar o deploy finalizar)
* mysql -h ip_publico_vm -u petclinic -P 3306 -p
* o password é petclinic
