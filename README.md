# ansible-role-logstash

Configures logstash.

SSL setup senario is not supported by this role (#10).

## FreeBSD

`sysutils/logstash5` is in the ports tree now, but it has several bugs and will
not work. The bugs have been fixed in [our
tree](https://github.com/reallyenglish/freebsd-ports/tree/10_3_re/sysutils/logstash5).

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

## RedHat

| Variable | Default |
|----------|---------|
| `__logstash_etc_dir` | `/etc/logstash` |
| `__logstash_home` | `/usr/share/logstash` |
| `__logstash_package_name` | `logstash` |
| `__logstash_user` | `logstash` |
| `__logstash_group` | `logstash` |

# Dependencies

None

# Example Playbook

```yaml
- hosts: all
  roles:
    - ansible-role-logstash
    - { role: reallyenglish.freebsd-repos, when: ansible_os_family == 'FreeBSD' }
    - { role: reallyenglish.redhat-repo, when: ansible_os_family == 'RedHat' }
  vars:
    logstash_enable_log: true
    logstash_inputs: |
      tcp {
        'port' => '5140'
        'type' => 'syslog'
      }
    logstash_outputs: |
      elasticsearch {}
    logstash_plugins_to_install:
      - logstash-input-rss
    logstash_config: {}
    logstash_jvm_options:
      - -Xms257m
      - -Xmx1g
      - -XX:+UseParNewGC
      - -XX:+UseConcMarkSweepGC
      - -XX:CMSInitiatingOccupancyFraction=75
      - -XX:+UseCMSInitiatingOccupancyOnly
      - -XX:+DisableExplicitGC
      - -Djava.awt.headless=true
      - -Dfile.encoding=UTF-8
      - -XX:+HeapDumpOnOutOfMemoryError

    freebsd_repos_name: reallyenglish_staging
    freebsd_repos_url: pkg+http://10.3.build.reallyenglish.com
    freebsd_repos_priority: 100
    freebsd_repos_disable_default_repository: false
    apt_repo_to_add: "{% if ansible_distribution == 'Ubuntu' and ansible_distribution_version | version_compare('16.04', '<') %}ppa:webupd8team/java{% endif %}"
    redhat_repo:
      logstash-5.x:
        baseurl: https://artifacts.elastic.co/packages/5.x/yum
        gpgcheck: yes
        enabled: yes
        gpgkey: https://artifacts.elastic.co/GPG-KEY-elasticsearch
```

# License

```
Copyright (c) 2016 Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>
