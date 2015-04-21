{{ pillar['straycat_service']['name'] }}.lc:
  boto_lc.present:
    - name: {{ pillar['straycat_env'] }}-{{ pillar['straycat_service']['name'] }}-{{ pillar['straycat_service']['lc_version'] }}
    - image_id: {{ pillar['straycat_service']['ec2_image_id'] }}
    - key_name: {{ pillar['straycat_service']['ec2_key_name'] }}
    - security_groups: {{ pillar['straycat_service']['ec2_security_groups'] }}
    - instance_type: {{ pillar['straycat_service']['instance_type'] }}
    - instance_monitoring: {{ pillar['straycat_service']['instance_monitoring'] }}
    - instance_profile_name: {{ pillar['straycat_service']['instance_profile_name'] }}
    - block_device_mappings:
      - '/dev/xvda':
          size: 10
    - user_data: |
        {{ pillar['straycat_service']['user_data'] | indent(8) }}
    - region: {{ pillar['straycat_service']['aws_region'] }}
