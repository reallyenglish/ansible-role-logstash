require "spec_helper"
require "serverspec"

logstash_package_name = "logstash"
logstash_service_name = "logstash"
logstash_config_path  = "/etc/logstash/conf.d"
logstash_config       = "/etc/logstash/logstash.yml"
logstash_user_name    = "logstash"
logstash_user_group   = "logstash"
logstash_home         = "/usr/share/logstash"
logstash_log_dir      = "/var/log/logstash"
logstash_local_log    = "#{logstash_log_dir}/logstash-plain.log"
jvm_options           = "/etc/logstash/jvm.options"
# wait for logstash to start listening
sleep 15

case os[:family]
when "freebsd"
  logstash_package_name = "logstash5"
  logstash_config_path = "/usr/local/etc/logstash/conf.d"
  logstash_home        = "/usr/local/logstash"
  logstash_config      = "/usr/local/etc/logstash/logstash.yml"
  jvm_options          = "/usr/local/etc/logstash/jvm.options"
end

case os[:family]
when "freebsd"
  describe file("/dev/fd") do
    it { should be_mounted }
    it { should be_mounted.with(type: "fdescfs") }
  end
end
describe file("/proc") do
  let(:fstype) { os[:family] == "freebsd" ? "procfs" : "proc" }

  it { should be_mounted }
  it { should be_mounted.with(type: fstype) }
end

describe package(logstash_package_name) do
  it { should be_installed }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/logstash") do
    it { should be_file }
    its(:content) { should match %r{^logstash_config="/usr/local/etc/logstash/conf.d"} }
  end
end

describe file(logstash_config_path.to_s) do
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
  its(:content) { should_not match(/None/) }
end

describe file(logstash_log_dir) do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by logstash_user_name }
  it { should be_grouped_into logstash_user_group }
  it { should be_mode 755 }
end

describe file(logstash_local_log) do
  it { should exist }
  it { should be_file }
  it { should be_owned_by logstash_user_name }
  it { should be_grouped_into logstash_user_group }
  it { should be_mode 755 }
end

describe file("#{logstash_home}/bin/logstash-plugin") do
  it { should be_file }
  it { should be_mode 755 }
end

describe command("#{logstash_home}/bin/logstash-plugin list") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/logstash-input-rss/) }
end

describe file(logstash_config) do
  it { should be_file }
  its(:content_as_yaml) { should include("path.logs" => "/var/log/logstash") }
  its(:content_as_yaml) { should include("http.host" => "127.0.0.1") }
  its(:content_as_yaml) { should include("http.port" => 9600) }
end

describe file(jvm_options) do
  it { should be_file }
  # non-defaults
  its(:content) { should match(/^-Xms257m$/) }
  # defaults
  its(:content) { should match(/^-Xmx1g$/) }
  its(:content) { should match(/^-XX:\+UseParNewGC$/) }
  its(:content) { should match(/^-XX:\+UseConcMarkSweepGC$/) }
  its(:content) { should match(/^-XX:CMSInitiatingOccupancyFraction=75$/) }
  its(:content) { should match(/^-XX:\+UseCMSInitiatingOccupancyOnly$/) }
  its(:content) { should match(/^-XX:\+DisableExplicitGC$/) }
  its(:content) { should match(/^-Djava\.awt\.headless=true$/) }
  its(:content) { should match(/^-Dfile\.encoding=UTF-8$/) }
  its(:content) { should match(/^-XX:\+HeapDumpOnOutOfMemoryError$/) }
end
