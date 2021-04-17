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
{{- .Values.image.repository -}}
{{- if hasPrefix "sha256:" .Values.image.tag -}}
@{{- .Values.image.tag -}}
{{- else -}}
:{{- .Values.image.tag | default .Chart.AppVersion -}}
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
Return postgres host (from postgresql values or overwrite if specified)
*/}}
{{- define "octobox.postgresHost" -}}
{{- if .Values.config.database.host -}}
{{ .Values.config.database.host -}}
{{- else -}}
{{- $postgresFullname := "postgres" -}}
{{- with (set (deepCopy .) "Values" .Values.postgresql) -}}
{{- $postgresFullname := include "common.names.fullname" . -}}
{{- end -}}
{{ printf "%s.%s" $postgresFullname .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{/*
Return redis connection URL (from redis values or overwrite if specified)
*/}}
{{- define "octobox.redisURL" -}}
{{- if .Values.config.redisURL -}}
{{- .Values.config.redisURL -}}
{{- else -}}
{{- $redisURL := "redis://" -}}
{{- if and .Values.redis.usePassword .Values.redis.password -}}
{{- $redisURL = printf "%s:%s@" $redisURL .Values.redis.password -}}
{{- end -}}
{{- $redisFullname := "redis" -}}
{{- with (set (deepCopy .) "Values" .Values.redis) -}}
{{- $redisFullname := include "redis.fullname" . -}}
{{- end -}}
{{- $redisHost := print $redisFullname "-master" -}}
{{- if .Values.redis.sentinel.enabled -}}
{{- $redisHost = $redisFullname -}}
{{- end -}}
{{- printf "%s%s.%s:%s" $redisURL $redisHost .Release.Namespace (toString .Values.redis.master.service.port) -}}
{{- end -}}
{{- end -}}
