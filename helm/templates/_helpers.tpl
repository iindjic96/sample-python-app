{{/*
Expand the name of the chart.
*/}}
{{- define "sample-python-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sample-python-app.fullname" -}}
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
Create chart label.
*/}}
{{- define "sample-python-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels - applied to all resources.
*/}}
{{- define "sample-python-app.labels" -}}
helm.sh/chart: {{ include "sample-python-app.chart" . }}
{{ include "sample-python-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "sample-python-app.name" . }}
{{- end }}

{{/*
Selector labels - used in matchLabels and service selectors.
Keep this minimal — changing these forces pod recreation.
*/}}
{{- define "sample-python-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sample-python-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Service account name.
*/}}
{{- define "sample-python-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "sample-python-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Active service name.
*/}}
{{- define "sample-python-app.activeServiceName" -}}
{{- default (printf "%s-active" (include "sample-python-app.fullname" .)) .Values.service.active.name }}
{{- end }}

{{/*
Preview service name.
*/}}
{{- define "sample-python-app.previewServiceName" -}}
{{- default (printf "%s-preview" (include "sample-python-app.fullname" .)) .Values.service.preview.name }}
{{- end }}

{{/*
Container image reference.
*/}}
{{- define "sample-python-app.image" -}}
{{- printf "%s:%s" .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) }}
{{- end }}

{{/*
Returns "true" if HPA should be created.
HPA is disabled when replicaCount is explicitly set to a fixed value of 1,
or when hpa.enabled is false.
*/}}
{{- define "sample-python-app.hpaEnabled" -}}
{{- if and .Values.hpa.enabled (gt (.Values.hpa.maxReplicas | int) 1) }}
{{- true }}
{{- end }}
{{- end }}

{{/*
Pod annotations — merges global podAnnotations with any extra ones.
*/}}
{{- define "sample-python-app.podAnnotations" -}}
{{- with .Values.podAnnotations }}
{{- toYaml . }}
{{- end }}
{{- end }}
