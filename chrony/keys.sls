{%- from 'chrony/map.jinja2' import chrony %}
{%- if 'keyfile' in chrony.options.present %}
{%- set chrony_keyfile = chrony.options.present.keyfile %}
{%- else %}
{%- set chrony_keyfile = salt.cmd.run("grep -oP '^\s*keyfile\s*\K.+' " + chrony.config) %}
{%- endif %}
---
include:
  - .config

chrony key file:
  file.managed:
    - name: {{chrony_keyfile}}
    - source: salt://chrony/files/chrony.keys.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - sls: chrony.config