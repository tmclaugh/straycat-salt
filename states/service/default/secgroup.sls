{#

Service should be available on 80 and 443 for all hosts in the environment.

#}
{{ pillar['straycat_service']['name'] }}.secgroup:
  boto_secgroup.present:
    - name: {{ pillar['straycat_env'] }}-{{ pillar['straycat_service']['name'] }}
    - description: {{ pillar['straycat_env'] }}-{{ pillar['straycat_service']['name'] }} rules
    - rules: {{ pillar['straycat_service']['ec2_security_group_rules'] }}
    - region: {{ pillar['straycat_service']['aws_region'] }}
