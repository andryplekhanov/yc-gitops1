configs:
  repositories:
    infra:
      password: <gitlab acces token>
      project: default
      type: git
      url: <repo url with helm-chart>
      username: gitlab-ci-token
server:
  # Меняем тип сервиса на NodePort
  service:
    nodePortHttp: 30082
    type: NodePort
  # Включаем ингресс, прописываем хост, подсеть, адрес и группу
  ingress:
    annotations:
      ingress.alb.yc.io/subnets: <yandex_vpc_subnet_id>
      ingress.alb.yc.io/external-ipv4-address: <yandex_vpc_address>
      ingress.alb.yc.io/group-name: infra-ingress
      ingress.alb.yc.io/security-groups: <security_group_id>
      # связь между балансировщиком и argocd – также через https
      ingress.alb.yc.io/transport-security: tls
    enabled: true
    # указываем чтобы использовался https
    https: true
    tls:
      - hosts:
          - argocd.<ваш домен>
        secretName: yc-certmgr-cert-id-<yandex_cm_certificate_id>
    hosts:
      - argocd.<ваш домен>
  config:
    # Учим helm взаимодействоать со схемами файлов values
    # конкретно нас интересует secrets+age-import
    helm.valuesFileSchemes: secrets+gpg-import, secrets+gpg-import-kubernetes, secrets+age-import, secrets+age-import-kubernetes, secrets, https

# Копируем конфигурацию из документации по ссылке выше
repoServer:
  env:
    - name: HELM_PLUGINS
      value: /custom-tools/helm-plugins/
    - name: HELM_SECRETS_HELM_PATH
      value: /usr/local/bin/helm
    - name: HELM_SECRETS_SOPS_PATH
      value: /custom-tools/sops
    - name: HELM_SECRETS_KUBECTL_PATH
      value: /custom-tools/kubectl
    - name: HELM_SECRETS_CURL_PATH
      value: /custom-tools/curl
    - name: HELM_SECRETS_VALUES_ALLOW_SYMLINKS
      value: "false"
    - name: HELM_SECRETS_VALUES_ALLOW_ABSOLUTE_PATH
      value: "false"
    - name: HELM_SECRETS_VALUES_ALLOW_PATH_TRAVERSAL
      value: "true"
  volumes:
    - name: custom-tools
      emptyDir: { }
    # Создаем volume из Secret с ключом key.txt
    - name: helm-secrets-private-keys
      secret:
        secretName: helm-secrets-private-keys
  volumeMounts:
    - mountPath: /custom-tools
      name: custom-tools
    # Монтируем volume с Secret с ключом key.txt
    - mountPath: /helm-secrets-private-keys/
      name: helm-secrets-private-keys
  initContainers:
    - name: download-tools
      image: alpine:latest
      command:
        - sh
        - -ec
      env:
        - name: HELM_SECRETS_VERSION
          value: 3.15.0
        - name: SOPS_VERSION
          value: 3.7.3
        - name: KUBECTL_VERSION
          value: 1.24.0
      args:
        - |
          mkdir -p /custom-tools/helm-plugins
          wget -qO- https://github.com/jkroepke/helm-secrets/releases/download/v${HELM_SECRETS_VERSION}/helm-secrets.tar.gz | tar -C /custom-tools/helm-plugins -xzf-;
          
          wget -qO /custom-tools/sops https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux
          wget -qO /custom-tools/kubectl https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl
          wget -qO /custom-tools/curl https://github.com/moparisthebest/static-curl/releases/latest/download/curl-amd64 \
          
          chmod +x /custom-tools/*
      volumeMounts:
        - mountPath: /custom-tools
          name: custom-tools