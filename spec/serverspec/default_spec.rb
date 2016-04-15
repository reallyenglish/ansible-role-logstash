require 'spec_helper'
require 'serverspec'

logstash_package_name = 'logstash'
logstash_service_name = 'logstash'
logstash_config_path  = '/etc/logstash/conf.d'
logstash_user_name    = 'logstash'
logstash_user_group   = 'logstash'
logstash_local_log    = '/var/log/logstash.log'
logstash_home         = '/usr/local/logstash'

# wait for logstash to start listening
sleep 15

case os[:family]
when 'freebsd'
  logstash_config_path = '/usr/local/etc/logstash/conf.d'
end

describe package(logstash_package_name) do
  it { should be_installed }
end

case os[:family]
when 'freebsd'
  describe file('/etc/rc.conf.d/logstash') do
    it { should be_file }
    its(:content) { should match %r{^logstash_config="/usr/local/etc/logstash/conf.d"} }
    its(:content) { should match /logstash_log=YES/ }
  end
end

describe file("#{logstash_config_path}") do
  it { should be_directory }
end

describe service(logstash_service_name) do
  it { should be_enabled }
  it { should be_running }
end

describe port(5140) do
  it { should be_listening }
end

describe file("#{logstash_config_path}/filter.conf") do
  it { should be_file }
  its(:content) { should_not match %r{None} }
end

describe file(logstash_local_log) do
  it { should be_file }
end

describe file("#{logstash_home}/bin/plugin") do
  it { should be_file }
  it { should be_mode 755 }
end
