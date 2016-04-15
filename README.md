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
| logstash\_conf\_dir     | the directory all logstash configs reside   | {{ \_\_logstash\_etc\_dir }}/conf.d |
| logstash\_service\_name | the service name of logstash                | logstash |
| logstash\_java\_opts    | options for Java                            | "" |
| logstash\_inputs        | configurations for input plugins            | "" |
| logstash\_outputs       | configurations for output plugins           | "" |
| logstash\_filters       | configurations for filter plugins           | "" |
| logstash\_enable\_log   | enable logging to local file. note that you need to configure log rotation yourself | true |
| logstash\_home          | path to root directory of logstash installation | {{ \_\_logstash\_home }} |
| logstash\_plugins\_to\_install   | logstash plugins to install | [] |


Dependencies
------------

None

Example Playbook
----------------

    - hosts: servers
      roles:
        - role:  ansible-role-logstash
          logstash_inputs: |
            syslog {
                     port => "514"
                     type => "syslog_input"
            }
          logstash_outputs: |
            elasticsearch {}

License
-------

BSD

Author Information
------------------

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>
