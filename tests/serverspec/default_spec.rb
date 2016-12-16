require 'spec_helper'
require 'serverspec'

logstash_package_name = 'logstash'
logstash_service_name = 'logstash'
logstash_config_path  = '/etc/logstash/conf.d'
logstash_config       = "/etc/logstash/logstash.yml"
logstash_user_name    = 'logstash'
logstash_user_group   = 'logstash'
logstash_home         = '/usr/share/logstash'
logstash_local_log   = "/var/log/logstash/logstash-plain.log"

# wait for logstash to start listening
sleep 15

case os[:family]
when 'freebsd'
  logstash_package_name = "logstash5"
  logstash_config_path = '/usr/local/etc/logstash/conf.d'
  logstash_home        = '/usr/local/logstash'
  logstash_config      = "/usr/local/etc/logstash/logstash.yml"
end

case os[:family]
when "freebsd"
  describe file("/dev/fd") do
    it { should be_mounted }
    # XXX in lib/specinfra/processor.rb, line 93, sepcinfra 2.66.2 has
    # linuxism, expecting:
    #
    # proc on /proc type proc (rw,noexec,nosuid,nodev)
    #
    # but in FeeeBSD, mount(8) returns:
    #
    # procfs on /proc (procfs, local)
    #
    # it { should be_mounted.with(:type => "fdescfs") }
  end
end
describe file("/proc") do
  it { should be_mounted }
  # it { should be_mounted.with(:type => "procfs") }
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

describe file("#{logstash_home}/bin/logstash-plugin") do
  it { should be_file }
  it { should be_mode 755 }
end

describe command("#{ logstash_home }/bin/logstash-plugin list") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /logstash-input-rss/ }
end

describe file(logstash_config) do
  it { should be_file }
  its(:content_as_yaml) { should include("path.logs" => "/var/log/logstash") }
  its(:content_as_yaml) { should include("http.host" => "127.0.0.1") }
  its(:content_as_yaml) { should include("http.port" => "9700") }
end
