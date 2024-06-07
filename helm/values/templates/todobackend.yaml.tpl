image:
  repository: <адрес реджистри-репозитория todobackend, который узнали из логов после работы CI-пайлайна build>
  tag: <тэг сборки образа todobackend, типа main-55ea909e4be50d9dda30449a84439a1408e78907>
ingress:
  enabled: true
  annotations:
    ingress.alb.yc.io/subnets: <subnet id ru-central1-b>
    ingress.alb.yc.io/external-ipv4-address: <static IP address>
    ingress.alb.yc.io/group-name: infra-ingress
    ingress.alb.yc.io/security-groups: <security-group id>
  hosts:
    - host: todoapp.<ваш домен>
      paths:
        - path: /api
          pathType: ImplementationSpecific
  tls:
    - hosts:
        - todoapp.<ваш домен>
      secretName: yc-certmgr-cert-id-<ваш tls cert id>
service:
  type: NodePort
  nodePort: 30084
env:
  - name: DB_PG_NAME
    value: <название базы данных PostgreSQL, которое вы указали при создании инфраструктуры>
  - name: DB_PG_USER
    value: <имя пользователя базы данных PostgreSQL>
  - name: DB_PG_PASSWORD
    value: <название базы данных PostgreSQL>
  - name: DB_PG_HOST
    value: c-<postgres_cluster_id>.rw.mdb.yandexcloud.net
  - name: DB_PG_PORT
    value: '6432'
migrations:
  activeDeadlineSeconds: 300
  command:
    - python
    - manage.py
    - migrate
