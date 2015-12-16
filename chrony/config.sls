{% from 'chrony/map.jinja2' import chrony %}

{% macro chrony_set_option(key, val) -%}
chrony config set {{key}} {{val}}:
  file.replace:
    - name: {{chrony.config}}
    - pattern: '^\s*#*\s*{{key}} {{val}}\s*$'
    - repl: '{{key}} {{val}}'
    - append_if_not_found: True
    - require:
      - pkg: install chrony package
  {% if key in chrony.options.absent %}
      - file: chrony config absent {{key}}
  {% endif %}
{%- endmacro %}

{% macro chrony_remove_option(option) -%}
chrony config absent {{option}}:
  file.replace:
    - name: {{chrony.config}}
    - pattern: '^\s*({{option}}.*)$'
    - repl: '# \1'
    - require:
      - pkg: install chrony package
{%- endmacro %}

---
{%- for option in chrony.options.absent %}
{{chrony_remove_option(option)}}
{%- endfor %}

{%- for key, val in chrony.options.present.iteritems() %}
{{chrony_remove_option(key)}}
  {%- if val is string %}
{{chrony_set_option(key, val)}}
  {%- else %}
    {%- for _val in val %}
{{chrony_set_option(key, _val)}}
    {%- endfor %}
  {%- endif %}
{%- endfor %}

