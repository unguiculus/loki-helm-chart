{{/*
Expand the name of the chart.
*/}}
{{- define "loki.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "loki.fullname" -}}
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
{{- define "loki.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "loki.labels" -}}
helm.sh/chart: {{ include "loki.chart" . }}
{{ include "loki.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "loki.selectorLabels" -}}
app.kubernetes.io/name: {{ include "loki.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "loki.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "loki.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Docker image name for Loki
*/}}
{{- define "loki.lokiImage" -}}
{{- $registry := coalesce .global.registry .service.registry .loki.registry -}}
{{- $repository := coalesce .service.repository .loki.repository -}}
{{- $tag := coalesce .service.tag .loki.tag .defaultVersion | toString -}}
{{- printf "%s/%s:%s" $registry $repository $tag -}}
{{- end -}}

{{/*
Docker image name
*/}}
{{- define "loki.image" -}}
{{- $registry := coalesce .global.registry .service.registry -}}
{{- $tag := .service.tag | toString -}}
{{- printf "%s/%s:%s" $registry .service.repository (.service.tag | toString) -}}
{{- end -}}

{{/*
Create a fully qualified app name for the memcached-chunks requirement.
*/}}
{{- define "loki.memcachedChunksFullname" -}}
{{- $context := dict "Values" (index .Values "memcached-chunks") "Release" .Release "Chart" (dict "Name" "memcached-chunks") -}}
{{ include "memcached.fullname" $context }}
{{- end }}

{{/*
Create a fully qualified app name for the memcached-frontend requirement.
*/}}
{{- define "loki.memcachedFrontendFullname" -}}
{{- $context := dict "Values" (index .Values "memcached-frontend") "Release" .Release "Chart" (dict "Name" "memcached-frontend") -}}
{{ include "memcached.fullname" $context }}
{{- end }}

{{/*
Create a fully qualified app name for the memcached-index-writes requirement.
*/}}
{{- define "loki.memcachedIndexWritesFullname" -}}
{{- $context := dict "Values" (index .Values "memcached-index-writes") "Release" .Release "Chart" (dict "Name" "memcached-index-writes") -}}
{{ include "memcached.fullname" $context }}
{{- end }}

{{/*
Create a fully qualified app name for the memcached-index-queries requirement.
*/}}
{{- define "loki.memcachedIndexQueriesFullname" -}}
{{- $context := dict "Values" (index .Values "memcached-index-queries") "Release" .Release "Chart" (dict "Name" "memcached-index-queries") -}}
{{ include "memcached.fullname" $context }}
{{- end }}
