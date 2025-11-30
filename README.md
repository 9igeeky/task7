## Практическая работа выполнялась в VK Cloud
Использовался образ из Практической  работы №6
### Перед началом работы 
1. Войдите в VK Cloud
2. Настройте доступ по API
3. В настройках проекта скачайте файл OpenStack RC file v3
4. Используйте команду `source /path/to/your/file` для установки переменных
5. В файле `create_image/packer/vars.pkr.hcl` задайте переменные
6. Перейдите в директорию `create_image/packer`  и ведите команду packer `init packer.pkr.hcl`, а затем `packer build -var-file vars.pkr.hcl packer.pkr.hcl`, чтобы запустить сборку образа.
7. Создайте файл командой `nano /home/<username>/.terraformrc` и поместите в него:
```
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```
#### Список переменных доступен в `terraform.tfvars`
1. terraform init
2. terraform plan
3. terraform apply

