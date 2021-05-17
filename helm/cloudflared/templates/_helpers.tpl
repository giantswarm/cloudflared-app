{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "cloudflared.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cloudflared.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cloudflared.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cloudflared.labels" -}}
helm.sh/chart: {{ include "cloudflared.chart" . }}
{{ include "cloudflared.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cloudflared.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cloudflared.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cloudflared.serviceAccountName" -}}
{{ include "cloudflared.fullname" . }}
{{- end }}

{{- define "create_tunnel.envs" -}}
- name: TUNNEL_NAME
  value: {{ template "cloudflared.fullname" . }}
- name: TUNNEL_SECRET_BASE64
  valueFrom:
    secretKeyRef:
      {{- if $.Values.tunnelSecretName }}
      name: {{ $.Values.tunnelSecretName }}
      {{- else }}
      name: {{ template "cloudflared.fullname" . }}-tunnelsecret
      {{- end }}
      key: tunnelSecret
- name: ACCOUNT_EMAIL
  valueFrom:
    secretKeyRef:
      name:  {{ template "cloudflared.fullname" . }}
      key: accountEmail
- name: ACCOUNT_ID
  valueFrom:
    secretKeyRef:
      name:  {{ template "cloudflared.fullname" . }}
      key: accountId
- name: API_KEY
  valueFrom:
    secretKeyRef:
      {{- if $.Values.apiKeySecretName }}
      name: {{ $.Values.apiKeySecretName }}
      {{- else }}
      name: {{ template "cloudflared.fullname" . }}-apikey
      {{- end }}
      key: apiKey
{{- end -}}

{{- define "envs" -}}
- name: CONFIG_FILE
  value: "/etc/cloudflared/config.yml"
- name: TUNNEL_CRED_FILE
  value: "/credentials/credentials.json"
{{- end -}}
