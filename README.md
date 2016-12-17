# ansible-role-logstash

Configures logstash.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `logstash_user` | logstash user | `{{ __logstash_user }}` |
| `logstash_group` | logstash group | `{{ __logstash_group }}` |
| `logstash_etc_dir` | path to directory to hold all the configuration files | `{{ __logstash_etc_dir }}` |
| `logstash_conf_dir` | path to directory where Logstash pipeline configuration files reside | `{{ __logstash_etc_dir }}/conf.d` |
| `logstash_package_name` | package name of logstash | `{{ __logstash_package_name }}` |
| `logstash_service_name` | service name | `logstash` |
| `logstash_plugins_to_install` | list of plugins to install | `[]` |
| `logstash_home` | path to logstash installation directory | `{{ __logstash_home }}` |
| `logstash_api_host` | `http.host` in `logstash.yml` | `127.0.0.1` |
| `logstash_api_port` | `http.port` in `logstash.yml` | `9600` |
| `logstash_jvm_options` | list of Java options in `jvm.options` | default options obtained from the official package, see `defaults/main.yml` |
| `logstash_config_default` | default options of `logstash.yml`. can be overrided by `logstash_config` | `{"path.config"=>"{{ logstash_conf_dir }}", "path.data"=>"{% if ansible_os_family == 'FreeBSD' %}/var/db/logstash{% elif ansible_os_family == 'Debian' %}/var/lib/logstash{% endif %}", "path.logs"=>"/var/log/logstash", "path.queue"=>"{% if ansible_os_family == 'FreeBSD' %}/var/db/logstash/queue{% elif ansible_os_family == 'Debian' %}/var/lib/logstash/queue{% endif %}", "http.host"=>"{{ logstash_api_host }}", "http.port"=>"{{ logstash_api_port }}"}` |
| `logstash_config` | additional options that override `logstash_config_default` | `{}` |
| `logstash_inputs` | input pipeline | `""` |
| `logstash_outputs` | output pipeline | `""` |
| `logstash_filters` | filter pipeline | `""` |

## Debian

| Variable | Default |
|----------|---------|
| `__logstash_etc_dir` | `/etc/logstash` |
| `__logstash_home` | `/usr/share/logstash` |
| `__logstash_package_name` | `logstash` |
| `__logstash_user` | `logstash` |
| `__logstash_group` | `logstash` |

## FreeBSD

| Variable | Default |
|----------|---------|
| `__logstash_etc_dir` | `/usr/local/etc/logstash` |
| `__logstash_home` | `/usr/local/logstash` |
| `__logstash_package_name` | `sysutils/logstash5` |
| `__logstash_user` | `logstash` |
| `__logstash_group` | `logstash` |

# Dependencies

None

# Example Playbook

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

# License

BSD

# Author Information

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>
