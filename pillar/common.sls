{# Common pillar values

Setup common pillar values.

#}

{# Import global vars #}
{%- from 'vars.jinja' import vars with context %}

instance_id:    '{{ vars.instance_id }}'
straycat_service:
  name:         {{ vars.straycat_service_name }}
straycat_env:       {{ vars.straycat_env }}
