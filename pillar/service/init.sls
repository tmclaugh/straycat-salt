{# Service configuration.

Defaults for all services are congifured here.  At the end a service specific
pillar will be imported that can override tyhese values.  At a mimimum a
service must provide the following.

{{ pillar['straycat_service']['name'] }}/init.sls:
___
straycat_service:
  lc_version:         20150416182700
  instances_desired:  2
  instances_min:      2
  instances_max:      2
...

#}

{# Import global vars #}
{% from 'vars.jinja' import vars with context %}


straycat_service:
{# Service defaults to be overriden

These need be overriden by a service pillar

#}
  instances_desired:  0
  instances_min:      0
  instances_max:      0
  lc_version:         0
  puppet_role:        None


{# Suggested service defaults

These may be overriden based upon actual need.
#}
  instance_type:          m3.medium
  instance_monitoring:    true
  instance_profile_name:  ec2-instance
{#
Order is impotant to aws_services.  Our state handles these in the order
given.  It allows us to order states whithout using 'requires' and therefore
make changes to later states alone without needing to process dependant its
states.
#}
  aws_services:
    - secgroup
    - lc
    - asg
  state_name: default

{# Hard service defaults.

These should typically not be overriden!

#}
  aws_region:             us-east-1
  aws_availability_zones:
    - us-east-1a
    - us-east-1c
    - us-east-1d
    - us-east-1e
  ec2_image_id:           ami-1234abcd
  ec2_key_name:           straycat-admin
  ec2_security_groups:
    - {{ vars.straycat_env }}
    - {{ vars.straycat_env }}-{{ vars.straycat_service_name }}
  {# Don't be fooled, user_data's value is a string for formatted YAML. #}
  user_data: |
    #cloud-config
    preserve_hostname: true
    manage_etc_hosts: false

    bootcmd:
      - [cloud-init-per, once, set_hostname_file, /bin/sh, -xc, 'echo "$(curl http://169.254.169.254/latest/meta-data/instance-id)" > /etc/hostname']
      - [cloud-init-per, once, set_mailname_file, /bin/sh, -xc, 'echo "$(curl http://169.254.169.254/latest/meta-data/instance-id).{{ vars.hostname_domain }}" > /etc/mailname']
      - [cloud-init-per, once, set_hosts_file, /bin/sh, -xc, 'echo "$(curl http://169.254.169.254/latest/meta-data/local-ipv4)" "$(curl http://169.254.169.254/latest/meta-data/instance-id).straycat-net.com" "$(curl http://169.254.169.254/latest/meta-data/instance-id)" >> /etc/hosts']
      - cloud-init-per once set_hostname hostname $(curl http://169.254.169.254/latest/meta-data/instance-id)
      - cloud-init-per once restart_rsyslog /usr/sbin/service rsyslog restart
      - [cloud-init-per, once, puppet_psk, /bin/sh, -xc, 'echo  "---\nextension_requests:\n  pp_preshared_key: {{ vars.puppet_psk }}" > /etc/puppet/csr_attributes.yaml']

    timezone: UTC

    puppet:
      version: {{ vars.puppet_version }}
      conf:
        agent:
          server: {{ vars.puppet_master }}
    salt_minion:
      master: {{ vars.salt_master }}


{# Service overrides #}
include:
  - service.{{ vars.straycat_service_name }}