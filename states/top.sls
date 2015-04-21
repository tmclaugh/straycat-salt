base:
  '*':
    {%- if pillar['instance_id'] != '*' %}
    - service.{{ pillar['straycat_service']['state_name'] }}.{{ pillar['instance_id'] }}
    {%- else %}
    - service.{{ pillar['straycat_service']['state_name'] }}
    {% endif %}
