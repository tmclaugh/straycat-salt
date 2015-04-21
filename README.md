**EXPERIMENTAL**
straycat-salt
===

SaltStack tree for orchestration and infrastructure management.

This tree is a central point for orchestration tasks and infrastructure management with in the Jana environment.  It is currently being used to experiment with how to use SaltStack in these capacities as Puppet starts to take over configuration management from the SaltStack tree in [Jana/config-mgmt](https://github.com/Jana-Mobile/config-mgmt).


## Repo layout
* _formulas/_: Third party formulas / any formulas that live in a different repo.
* _pillar/_: All pillar information
* _states/_:
  * _services/_: state for a service.  A service should be what Jana calls it in our environment.
      * ex. ("central-redis-5-proxy" or "redis-proxy") not "twemproxy"

## Usage

### Adding states
This repo uses pillar data for defining AWS state information for a service.  The [default state](https://github.com/Jana-Mobile/straycat-salt/tree/master/states/service/bizbot) is written with flexibility in mind so that most services can provide all relevant data in _pillars/_.  The tree's [service pillar](https://github.com/Jana-Mobile/straycat-salt/blob/master/pillar/service/init.sls) provides usable defaults which should leave a new service with little to configure.  At a minimum a new service will need the following:

* pillars/service/<myservice>/init.pp
```
straycat_service:
  lc_version:           20150421181000
  instances_desired:    1
  instances_min:        1
  instances_max:        1
  puppet_role:          straycat::roles::apphost
```

### Gathering service configuration
Salt provides the ability to display pillar data for a host and provide it in YAML format.  This is useful for examing the configuration of a service.

```
$ salt-call -l debug --config-dir=. --id 'lc.central-redis-1-proxy.infrastructure' pillar.items
```

Of particular interest for most people will be the straycat_service pillar.  This is a dictionary of all data related to the configuration of that service.
```
$ salt-call -l debug --config-dir=. --id 'lc.central-redis-1-proxy.infrastructure' pillar.items straycat_service

local:                                                                                                                                                                                             [29/9351]
    ----------
    straycat_service:
        ----------
        aws_availability_zones:
            - us-east-1a
            - us-east-1c
            - us-east-1d
            - us-east-1e
        aws_region:
            us-east-1
        aws_services:
            - secgroup
            - lc
            - asg
        ec2_image_id:
            ami-2a82a342
        ec2_key_name:
            txteagle-admin-29mar2012
        ec2_security_group_rules:
            |_
              ----------
              from_port:
                  6379
              ip_protocol:
                  tcp
              source_group_name:
                  - production
                  - infrastructure
                  - admin
                  - reporting
              to_port:
                  6379
        ec2_security_groups:
            - infrastructure
            - infrastructure-central-redis-1-proxy
        instance_monitoring:
            True
        instance_profile_name:
            ec2-instance
        instance_type:
            m3.large
        instances_desired:
            2
        instances_max:
            2
        instances_min:
            2
        lc_version:
            20150421181000
        name:
            central-redis-1-proxy
        puppet_role:
            straycat::roles::redis_proxy
        state_name:
            default
        user_data:
            #cloud-config
            preserve_hostname: true
            manage_etc_hosts: false

            bootcmd:
              - [cloud-init-per, once, set_hostname_file, /bin/sh, -xc, 'echo "$(curl http://169.254.169.254/latest/meta-data/instance-id)" > /etc/hostname']
              - [cloud-init-per, once, set_mailname_file, /bin/sh, -xc, 'echo "$(curl http://169.254.169.254/latest/meta-data/instance-id).straycat-net.com" > /etc/mailname']
              - [cloud-init-per, once, set_hosts_file, /bin/sh, -xc, 'echo "$(curl http://169.254.169.254/latest/meta-data/local-ipv4)" "$(curl http://169.254.169.254/latest/meta-data/instance-id).straycat-ne
t.com" "$(curl http://169.254.169.254/latest/meta-data/instance-id)" >> /etc/hosts']
              - cloud-init-per once set_hostname hostname $(curl http://169.254.169.254/latest/meta-data/instance-id)
              - cloud-init-per once restart_rsyslog /usr/sbin/service rsyslog restart
              - [cloud-init-per, once, puppet_psk, /bin/sh, -xc, 'echo  "---\nextension_requests:\n  pp_preshared_key: FoiWssfp1wOfbdQ4" > /etc/puppet/csr_attributes.yaml']

            timezone: UTC

            puppet:
              version: 3.7.4-1puppetlabs1
              conf:
                agent:
                  server: puppet.straycat.io
            salt_minion:
              master: salt.straycat.com
```
### Executing states
From the root of this repo run the following
```
$ salt-call -l debug --config-dir=. --id '<component>.<service>.<environment>' state.highstate
```

For example, to configure all __centralbooking__ do:
```
$ salt-call -l debug --config-dir=. --id '*.centralbooking.infrastructure' state.highstate
```

To just configure its auto-scaling group:
```
$ salt-call -l debug --config-dir=. --id 'asg.centralbooking.infrastructure' state.highstate
```
