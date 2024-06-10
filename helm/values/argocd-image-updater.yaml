extraEnv:
  - name: YC_REGISTRY_CREDS
    value: 'json_key:<json-ключ из файла reg-puller-sa-key.json в одну строку>'
config:
  argocd:
    grpcWeb: false
    serverAddress: 'https://argocd-server.argocd'
    insecure: true
    plaintext: false
  registries:
    - name: YC
      api_url: 'https://cr.yandex'
      ping: false
      credentials: 'env:YC_REGISTRY_CREDS'
      prefix: cr.yandex
