{{/*
Template for outputing the gitlabUrl
*/}}
{{- define "gitlab-runner.gitlabUrl" -}}
{{- if .Values.gitlabUrl }}
{{- .Values.gitlabUrl | quote }}
{{- else }}
{{- $urlHost := regexReplaceAll "^(?:.*://)?([^/]+).*" .Values.gitlabDomain "${1}" }}
{{- printf "https://%s/" $urlHost | quote }}
{{- end }}
{{- end -}}
