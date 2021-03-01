{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "labels.common" -}}
{{ include "labels.selector" . }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
helm.sh/chart: {{ include "chart" . | quote }}
giantswarm.io/service-type: {{ .Values.serviceType }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "labels.selector" -}}
app.kubernetes.io/instance: "{{ .Chart.Name }}-{{ .Release.Name }}"
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end -}}

{{- define "common.envs" -}}
- name: TUNNEL_CRED_FILE
  value: "/credentials/credentials.json"
- name: CONFIG_FILE
  value: "/etc/cloudflared/config.yml"
- name: TUNNEL_SECRET_BASE64
  valueFrom:
    secretKeyRef:
      {{- if $.Values.tunnelSecretName }}
      name: {{ $.Values.tunnelSecretName }}
      {{- else }}
      name: cloudflared-{{ $.Release.Name }}-tunnelsecret
      {{- end }}
      key: tunnelSecret
- name: ACCOUNT_EMAIL
  valueFrom:
    secretKeyRef:
      name: cloudflared-{{ $.Release.Name }}
      key: accountEmail
- name: ACCOUNT_ID
  valueFrom:
    secretKeyRef:
      name: cloudflared-{{ $.Release.Name }}
      key: accountId
- name: API_KEY
  valueFrom:
    secretKeyRef:
      {{- if $.Values.apiKeySecretName }}
      name: {{ $.Values.apiKeySecretName }}
      {{- else }}
      name: cloudflared-{{ $.Release.Name }}-apikey
      {{- end }}
      key: apiKey
{{- end -}}
