{{- define "homework-chart.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "homework-chart.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "homework-chart.labels" -}}
app.kubernetes.io/name: {{ include "homework-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end }}

{{- define "homework-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "homework-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
