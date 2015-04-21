{# Redis proxy cluster #}

straycat_service:
  lc_version:           20150421181000
  ec2_security_group_rules:
    - ip_protocol:  tcp
      from_port:    6379
      to_port:      6379
      source_group_name:
        - production
        - infrastructure
        - admin
        - reporting
  instances_desired:    0
  instances_min:        0
  instances_max:        0
  instance_type:        m3.large
  puppet_role:          straycat::roles::redis_proxy
  aws_services:
    - secgroup
    - lc
    - asg
