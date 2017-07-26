require "spec_helper"
require "json"
require "digest"

context "after provisioning finished" do
  hash = Digest::SHA1.hexdigest(Time.now.to_s)
  describe server(:client1) do
    it "writes an event to logstash.input" do
      r = current_server.ssh_exec("echo #{hash} >> /home/vagrant/logstash.input && echo OK")
      expect(r).to match(/OK/)
    end
  end

  describe server(:server1) do
    it "writes the event from client to /var/log/logstash/output.json" do
      sleep 5
      r = current_server.ssh_exec("tail -n 1 /var/log/logstash/output.json")
      expect { JSON.parse(r) }.not_to raise_error
      json = JSON.parse(r)
      expect(json.key?("message")).to eq true
      expect(json["message"]).to eq hash
    end
  end
end
