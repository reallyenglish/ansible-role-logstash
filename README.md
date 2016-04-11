ansible-role-logstash
=====================

Installs logstash

Requirements
------------

None

Role Variables
--------------

| Name | Description | Default |
|------|-------------|---------|
| logstash\_conf\_dir | the directory all logstash configs reside| {{ \_\_logstash\_etc\_dir }}/conf.d |
| logstash\_service\_name | the service name of logstash | logstash |

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
        - ansible-role-logstash

License
-------

BSD

Author Information
------------------

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>
