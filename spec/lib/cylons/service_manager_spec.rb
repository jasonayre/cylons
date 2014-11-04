require 'spec_helper'

describe ::Cylons::ServiceManager do
  subject { described_class }
  its(:remotes?) { should be true }
  describe ".start" do
    it do
      described_class.stub(:start_services)
      subject.should_receive(:start_services)
      subject.start
    end
  end

  describe ".start_service" do
    it "calls build_service" do
      subject.start_service(::Product)

      ::Celluloid::Actor[:node_manager].find("InventoryTest").should be_a(::DCell::Node)
    end
  end

  describe ".start_services" do
    context "remotes registered" do
      it "starts services" do
        subject.should_receive(:start_service).with(::Cylons::RemoteRegistry.remotes.first).once
        subject.start_services
      end
    end

    context "no remotes" do
      it "does not start" do
        subject.stub(:remotes?).and_return(false)
        subject.should_not_receive(:start_service)
        subject.start_services
      end
    end
  end

  describe ".service_defined?" do
    it {
      subject.service_defined?(OpenStruct).should be false
    }
  end

end
