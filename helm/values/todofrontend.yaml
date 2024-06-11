image:
  repository: <адрес реджистри-репозитория todofrontend, который узнали из логов после работы CI-пайлайна build>
  tag: <тэг сборки образа todofrontend, типа main-55ea909e4be50d9dda30449a84439a1408e78907>
ingress:
  enabled: true
  annotations:
    ingress.alb.yc.io/subnets: <yandex_vpc_subnet_id>
    ingress.alb.yc.io/external-ipv4-address: <yandex_vpc_address>
    ingress.alb.yc.io/group-name: infra-ingress
    ingress.alb.yc.io/security-groups: <security_group_id>
  hosts:
    - host: todoapp.<ваш домен>
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls:
    - hosts:
        - todoapp.<ваш домен>
      secretName: yc-certmgr-cert-id-<yandex_cm_certificate_id>
service:
  type: NodePort
  nodePort: 30083
