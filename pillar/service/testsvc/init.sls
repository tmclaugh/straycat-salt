{# Generic web service #}

straycat_service:
  lc_version:           20150421181000
  ec2_security_group_rules:
    - ip_protocol:  tcp
      from_port:    80
      to_port:      80
      source_group_name:
        - default
    - ip_protocol:  tcp
      from_port:    443
      to_port:      443
      source_group_name:
        - default
  instances_desired:    0
  instances_min:        0
  instances_max:        0
  instance_type:        m3.large
  puppet_role:          straycat::roles::apphost
  aws_services:
    - secgroup
    - lc
    - asg
