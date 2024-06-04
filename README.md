## Этап 1 — Подготовка

_Данный этап я не стал автоматизировать, поскольку действия связанные с регистрацией домена и выдачей сертификата могут занять продолжительное время, поэтому лучше всё это проделать заранее._

- В Yandex Cloud должно быть создано облако с дефолтными **folder**, **network** и **subnets** (3 шт.: в зонах ru-central1-a, b и d)
- В Yandex Cloud в дефолтном **folder** должны быть созданы:
  - Публичный статический IP-адрес
  - DNS зона (публичная), например `andreiplekhanov.ru.`
  - В этой зоне: запись типа A, например `*.andreiplekhanov.ru.`, указывающая на ранее созданный IP.
  - Сертификат от **Let’s Encrypt** и **CNAME** запись к ранее созданному домену.

## Этап 2 — Разворачиваем зональный кластер k8s

- Переходим в папку terraform: `cd terraform`
- В Yandex Cloud нам нужны **cloud id**, **folder id**, **token**. Вставляем их между кавычками в команду ниже и применяем её:

```bash
export CLOUD="" && \
export FOLDER="" && \
export TOKEN=""
```
- В Yandex Cloud берём **network id** и **subnet ids** (3 шт.: в зонах ru-central1-a, b и d). Вставляем их в `variables.tf` в **yc_network_id** и **yc_subnet_ids**.
- Инициализируем terraform: `terraform init`
- Применяем: `terraform apply -var yc_cloud=$CLOUD -var yc_folder=$FOLDER -var yc_token=$TOKEN -var user=$USER`
- Получаем результат:

```
Outputs:

cluster_id = "cate0ugm3ubsq2iana7f"
container_registry_id = "crplq85o3ts2puflph5j"
security_group_id = "enpmbs0454vsg2vjtida"
```

- Подключаемся к кластеру: `yc managed-kubernetes cluster get-credentials --name=kube-infra --external --force`