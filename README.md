# Разворачиваем TodoApp по модели GitOps

## Этап 1 — Подготовка

### Подготовка репозиториев с приложениями

Клонируем в свой Gitlab следующие репозитории:
- репо с данным приложением **yc-gitops1**
- репо с [фронтэнд-сервисом](https://github.com/yandex-cloud-examples/yc-courses-devops-course2/tree/master/todofrontend) приложения **todofrontend**
- репо с [бэкэнд-сервисом](https://github.com/yandex-cloud-examples/yc-courses-devops-course2/tree/master/todobackend) приложения **todobackend**


### Подготовка ПК или ВМ

На вашем ПК или ВМ должны быть установлены утилиты: terraform, kubectl, Helm, helm-secrets plugin, YandexCloud CLI, sops, age.

**Для их автоматической установки на Ubuntu 22-04:**
- клонируйте данный репозиторий и перейдите в проект
- дайте права на исполнение: `chmod +x prepare.sh`
- запустите скрипт: `./prepare.sh`

### Подготовка YandexCloud

- В **Yandex Cloud** должны быть созданы **cloud** с дефолтной **folder**. Фолдер должен быть пустым (удалите дефолтные сети и подсети, если они создались).
- Зарегистрируйте **домен** и для его делегирования на NS сервера Яндекса внутри настроек домена поменяйте NS записи на:
  - ns1.yandexcloud.net
  - ns2.yandexcloud.net

**Внимание!** Обновление DNS может занять до 24 часов. Проделайте этот шаг заранее.


## Этап 2 — Разворачиваем инфраструктуру в Yandex Cloud

- Переходим в папку terraform: `cd terraform`
- В файле `variables.tf` вписываем значение переменной `domain_name` - домен, который мы зарегистрировали на предыдущем этапе.
- В Yandex Cloud берём **cloud id**, **folder id**, **token**. Вставляем их между кавычками в команду ниже.
- Также придумываем и запоминаем данные для БД PostgreSQL и вписываем в команду ниже.
- Инициализируем terraform: `terraform init`
- Применяем: 

```bash
terraform apply \
 -var yc_cloud="" \
 -var yc_folder="" \
 -var yc_token="" \
 -var user="" \
 -var db_name="" \
 -var db_username="" \
 -var db_password=""
```
- Получаем результат и сохраняем его себе. Пригодится на следующем этапе:

```
Outputs:

container_registry_id = "crp69e285mfj20bs4g8d"
k8s_cluster_id = "catamgrfucga530niuuv"
postgres_cluster_id = "c9qu6uq5h780np9bfokc"
security_group_id = "enpp86il0rdrhjo3slkj"
yandex_cm_certificate_id = "fpqg57o3bhhkto5f9jhm"
yandex_vpc_address = "158.160.16.2"
yandex_vpc_subnet_id = "e2l2n59ar0m90j4qmunk"
yc_network_id = "enp6elt8tgn1f6rs00l4"
```

- переходим в папку с чартами: `cd ../helm`
- подключаемся к кластеру: `yc managed-kubernetes cluster get-credentials --name=kube-infra --external --force`
- для сервисных аккаунтов **ingress-controller**, **registry-puller** и **registry-pusher** создаем ключи (пригодятся позже):

```bash
yc iam key create --service-account-name ingress-controller --output ingress-sa-key.json
yc iam key create --service-account-name registry-puller --output reg-puller-sa-key.json
yc iam key create --service-account-name registry-pusher --output reg-pusher-sa-key.json
```

## Этап 3 — Настраиваем Gitlab

### Разворачиваем в кластере runner

- заходим на Gitlab в данный проект (с helm-чартами) и идём в **Settings**
- в разделе **Access Tokens** создаём токен с ролью **Developer** и разрешением **Read repository**. Запоминаем его. Он нам пригодится далее.
- в разделе **CI/CD** идём в **Runners** и создаём раннер. Подставляем полученный token и URL в команду ниже и выполняем её:

```
helm install gitlab-runner charts/gitlab-runner \
  --set gitlabUrl=<runner URL> \
  --set runnerRegistrationToken=<runner token> \
  --set rbac.create=true \
  --namespace gitlab \
  --create-namespace
```

### Настраиваем CI в репозиториях с микросервисами

- заходим на Gitlab в проекты с приложениями **todofrontend** и **todobackend** (в каждый) и идём в **Settings** -> **CI/CD**
- идём в **Runners** и подключаем ранее созданный раннер.
- идём в **Variables** и создаём переменные:
  - **YC_CI_REGISTRY**: cr.yandex
  - **YC_CI_REGISTRY_ID**: <указываем наш container_registry_id>
  - **YC_CI_REGISTRY_PASSWORD**: <содержимое файла reg-pusher-sa-key.json>
  - **YC_CI_REGISTRY_USER**: json_key

![ci-variables](ci-variables.png)

- запускаем джобу **build**, ждём успешного выполнения и смотрим результат:

![ci-job-result](ci-job-result.png)

- отсюда запоминаем 2 вещи:
  - **адрес реджистри-репозитория** `cr.yandex/crp8eltfp9p1mgq5tb7a/andryplekhanov/todofrontend`
  - **тэг сборки** `main-55ea909e4be50d9dda30449a84439a1408e78907`
- В Yandex Cloud идём в наш **Container Registry** и убеждаемся, что наш образ загрузился и находится в статусе **Active**.


## Этап 4 — Разворачиваем приложения

### Создаём секретный ключ

- создаём неймспейс: `kubectl create namespace argocd`
- генерим ключ: `age-keygen -o key.txt`
- экспортируем переменные:
  - `export SOPS_AGE_KEY_FILE=$(pwd)/key.txt`
  - `export SOPS_AGE_RECIPIENTS=<публичный ключ, который распечатала команда выше>`
- создаем Secret внутри кластера: `kubectl -n argocd create secret generic helm-secrets-private-keys --from-file=key.txt`

### Разворачиваем в кластере Argocd и App of apps

- редактируем файлы в папке `values`. Вписываем параметры везде, где встречаются угловые скобки **<some_data>**
- зашифровываем эти файлы, кроме **apps.yaml** и **argocd-apps.yaml**, например: `helm secrets enc values/argocd.yaml`
- всё коммитим и пушим в Gitlab
- устанавливаем Argocd в кластер: `helm secrets -n argocd upgrade --install argocd charts/argo-cd -f values/argocd.yaml`
- добавляем репо в helm: `helm repo add argo https://argoproj.github.io/argo-helm`
- устанавливаем **App of apps** из репо: `helm secrets -n argocd upgrade --install argocd-apps argo/argocd-apps -f values/argocd-apps.yaml`

Минут через 10-15, когда поднимется балансировщик, можем зайти на наш Argocd по адресу `https://argocd.<ваш домен>`
- логин **admin**, 
- пароль узнать командой `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`

Также по адресу `https://todoapp.<ваш домен>` получаем наше работающее приложение.