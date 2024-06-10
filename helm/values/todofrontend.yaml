image:
  tag: <тэг сборки образа todofrontend, типа main-55ea909e4be50d9dda30449a84439a1408e78907>
  repository: <адрес реджистри-репозитория todofrontend, который узнали из логов после работы CI-пайлайна build>
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
        - path: /
          pathType: ImplementationSpecific
  tls:
    - hosts:
        - todoapp.<ваш домен>
      secretName: yc-certmgr-cert-id-<ваш tls cert id>
service:
  type: NodePort
  nodePort: 30083
