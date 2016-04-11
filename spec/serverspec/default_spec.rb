require 'spec_helper'
require 'serverspec'

logstash_package_name = 'logstash'
logstash_service_name = 'logstash'
logstash_config_path  = '/etc/logstash/conf.d'
logstash_user_name    = 'logstash'
logstash_user_group   = 'logstash'

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
  end
end

describe file("#{logstash_config_path}") do
  it { should be_directory }
end

describe service(logstash_service_name) do
  it { should be_enabled }
  it { should be_running }
end
