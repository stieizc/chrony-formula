{% from 'chrony/map.jinja2' import chrony %}

{% set pkg_func = 'latest' if chrony.ensure_latest else 'installed' %}
---
include:
  - .config
{% if chrony.keys_managed and chrony.keys %}
  - .keys
{% endif %}

install chrony package:
  pkg.{{pkg_func}}:
    - name: {{chrony.package_name}}

{% if chrony.ensure_service.running %}
chrony service:
  service.running:
    - name: {{chrony.service_name}}
    - enable: {{chrony.ensure_service.enabled}}
    - watch:
      - sls: chrony.config
  {% if chrony.keys_managed and chrony.keys %}
      - sls: chrony.keys
  {% endif %}
{% endif %}
