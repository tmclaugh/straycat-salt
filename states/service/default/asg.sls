{{ pillar['straycat_service']['name'] }}.asg:
  boto_asg.present:
    - name: {{ pillar['straycat_env'] }}-{{ pillar['straycat_service']['name'] }}
    - launch_config_name: {{ pillar['straycat_env'] }}-{{ pillar['straycat_service']['name'] }}-{{ pillar['straycat_service']['lc_version'] }}
    - availability_zones: {{ pillar['straycat_service']['aws_availability_zones'] }}
    - min_size: {{ pillar['straycat_service']['instances_min'] }}
    - max_size: {{ pillar['straycat_service']['instances_max'] }}
    - desired_capacity: {{ pillar['straycat_service']['instances_desired'] }}
    - region: {{ pillar['straycat_service']['aws_region'] }}
    - tags:
      - { "key":"straycat:env", "value":"{{ pillar['straycat_env'] }}", "propagate_at_launch": True }
      - { "key":"straycat:cluster", "value":"{{ pillar['straycat_service']['name'] }}", "propagate_at_launch": True }
      - { "key":"straycat:puppet-role", "value":"{{ pillar['straycat_service']['puppet_role'] }}", "propagate_at_launch": True }
      {%- if 'ec2_tags_extra' in pillar['straycat_service'] %}
        {%- for tag in pillar['straycat_service']['ec2_tags_extra'] %}
      - {{ tag }}
        {% endfor %}
      {% endif %}