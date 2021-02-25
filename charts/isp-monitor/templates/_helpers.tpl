{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "isp-monitor.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "isp-monitor.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create unified labels for isp-monitor components
*/}}
{{- define "isp-monitor.common.matchLabels" -}}
app: {{ template "isp-monitor.name" . }}
release: {{ .Release.Name }}
{{- end -}}

{{- define "isp-monitor.common.metaLabels" -}}
chart: {{ template "isp-monitor.chart" . }}
heritage: {{ .Release.Service }}
{{- end -}}

{{- define "isp-monitor.labels" -}}
{{ include "isp-monitor.matchLabels" . }}
{{ include "isp-monitor.common.metaLabels" . }}
{{- end -}}

{{- define "isp-monitor.matchLabels" -}}
{{ include "isp-monitor.common.matchLabels" . }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "isp-monitor.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for deployment.
*/}}
{{- define "isp-monitor.deployment.apiVersion" -}}
{{- print "apps/v1" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for daemonset.
*/}}
{{- define "isp-monitor.daemonset.apiVersion" -}}
{{- print "apps/v1" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for networkpolicy.
*/}}
{{- define "isp-monitor.networkPolicy.apiVersion" -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for podsecuritypolicy.
*/}}
{{- define "isp-monitor.podSecurityPolicy.apiVersion" -}}
{{- print "policy/v1beta1" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for rbac.
*/}}
{{- define "rbac.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "rbac.authorization.k8s.io/v1" }}
{{- print "rbac.authorization.k8s.io/v1" -}}
{{- else -}}
{{- print "rbac.authorization.k8s.io/v1beta1" -}}
{{- end -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "ingress.apiVersion" -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- end -}}

{{/*
Define the isp-monitor.namespace template if set with forceNamespace or .Release.Namespace is set
*/}}
{{- define "isp-monitor.namespace" -}}
{{- if .Values.forceNamespace -}}
{{ printf "namespace: %s" .Values.forceNamespace }}
{{- else -}}
{{ printf "namespace: %s" .Release.Namespace }}
{{- end -}}
{{- end -}}
