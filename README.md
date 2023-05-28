# dev.lorenzosfienti.backup

Progetto del sistema di backup <backup.lorenzosfienti.dev>

## Pre requisiti

- [installare Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
- [installare AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- [creare un profilo aws](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) chiamato **lorenzosfienti** che permetta di gestire tutte le risorse dell'infrastruttura

## Uso

Per inizializzare il progetto bisognerà lanciare `terraform init`.

Per avere un formattazione uniforme suggeriamo di usare `terraform fmt`, mentre per verificare che eventuali modifiche siano consistenti usare `terraform validate`.

Dopo aver fatto una modifica locale oppure per tracciare un cambio fatto direttamente in AWS si può eseguire `terraform plan`.

Il comando più importantee è `terraform apply`che permette di creare/modificare l'infrastruttura su AWS. Inoltre il suo stato viene copiato su [ilpos](https://s3.console.aws.amazon.com/s3/buckets/ilpost-terraform?region=eu-central-1&tab=objects) in modo tale che sia condiviso e persistente.

>:warning: il bucket **lorenzosfienti-dev-terraform** non è gestito da terraform.

Per una lista completa dei comandi eseguire `terraform --help` o consultare la [documentazione ufficiale](https://www.terraform.io/docs/cli/commands/index.html)

## Output

Il progetto espone access key e secret tramite il comando `terraform apply` oppure possono essere richiesti in qualsiasi momento con `terraform output`. Eventuali dati sensibili vengono mostrati come `<sensitive>`. Se li volete vedere in chiaro dovrete richiedeli esplicitamente: `terraform output -json`
