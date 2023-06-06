{{/*
Expand the name of the chart.
*/}}
{{- define "octobox.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "octobox.fullname" -}}
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
{{- define "octobox.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "octobox.labels" -}}
helm.sh/chart: {{ include "octobox.chart" . }}
{{ include "octobox.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "octobox.selectorLabels" -}}
app.kubernetes.io/name: {{ include "octobox.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return secret name (either fullname or existingSecret if specified)
*/}}
{{- define "octobox.secretName" -}}
{{- $fullName := include "octobox.fullname" . -}}
{{- default $fullName .Values.existingSecret | quote -}}
{{- end -}}

{{/*
Return image reference (either using tag or sha)
*/}}
{{- define "octobox.image" -}}
{{- .Values.global.octobox.image.repository -}}
{{- if hasPrefix "sha256:" .Values.global.octobox.image.tag -}}
@{{- .Values.global.octobox.image.tag -}}
{{- else -}}
:{{- .Values.global.octobox.image.tag | default .Chart.AppVersion -}}
{{- end -}}
{{- end -}}

{{/*
Return configmap name (either fullname or existingConfigMap if specified)
*/}}
{{- define "octobox.configMapName" -}}
{{- $fullName := include "octobox.fullname" . -}}
{{- default $fullName .Values.existingConfigMap | quote -}}
{{- end -}}

{{/*
Return environment variables from postgresql service binding secret
*/}}
{{- define "octobox.database.serviceBindingEnvs" -}}
{{- if .Values.config.database.useServiceBinding }}
{{- $secretName := "" }}
{{- with (set (deepCopy .) "Values" .Values.postgresql) -}}
{{- $secretName = printf "%s-%s" (include "common.names.fullname" . ) "svcbind-custom-user" }}
{{- end }}
- name: OCTOBOX_DATABASE_HOST
  valueFrom:
    secretKeyRef:
      name: {{ $secretName }}
      key: host
- name: OCTOBOX_DATABASE_PORT
  valueFrom:
    secretKeyRef:
      name: {{ $secretName }}
      key: port
- name: OCTOBOX_DATABASE_NAME
  valueFrom:
    secretKeyRef:
      name: {{ $secretName }}
      key: database
- name: OCTOBOX_DATABASE_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ $secretName }}
      key: username
- name: OCTOBOX_DATABASE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ $secretName }}
      key: password
{{- end }}
{{- end }}

{{/*
Return environment variables from redis service binding secret
*/}}
{{- define "octobox.redis.serviceBindingEnvs" -}}
{{- if .Values.config.redis.useServiceBinding }}
{{- $secretName := "" }}
{{- with (set (deepCopy .) "Values" .Values.redis) -}}
{{- $secretName = printf "%s-%s" ( include "common.names.fullname" . ) "svcbind" }}
{{- end }}
- name: REDIS_URL
  valueFrom:
    secretKeyRef:
      name: redis-svcbind
      key: uri
{{- end }}
{{- end }}
