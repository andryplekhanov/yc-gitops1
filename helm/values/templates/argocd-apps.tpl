applications:
#  - name: apps
  apps:
    namespace: argocd
    project: default
    source:
      # Указываем путь к values, обратите внимание на то, что он относительный
      helm:
        valueFiles:
          - ../../values/apps.yaml
      # Путь до чарта
      path: helm/charts/apps
      # Репозиторий
      repoURL: <repo url with helm-chart>
    destination:
      # Устанавливаем все приложения в тот же неймспейс argocd
      namespace: argocd
      server: https://kubernetes.default.svc
    syncPolicy:
      automated: { }