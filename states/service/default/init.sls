{#
application setup for central-booking.

ref: https://github.com/Jana-Mobile/central-booking
#}

include:
      {%- for service in pillar['straycat_service']['aws_services'] %}
    - service.{{ pillar['straycat_service']['state_name'] }}.{{ service }}
      {% endfor %}
