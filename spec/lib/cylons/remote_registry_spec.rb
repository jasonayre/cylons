require 'spec_helper'

describe ::Cylons::RemoteRegistry do
  subject { described_class }

  describe ".clear_registry" do
    it {
      ::DCell.registry.instance_variable_get("@global_registry").stub(:clear)
      ::DCell.registry.instance_variable_get("@global_registry").should_receive(:clear)
      subject.clear_registry
    }
  end

  describe ".register" do
    it "appends class to remotes" do
      current_remotes_count = subject.remotes.size
      subject.register(OpenStruct)
      subject.remotes.size.should eq current_remotes_count + 1
      subject.remotes.pop
    end
  end

  describe ".register_schemas" do
    it "registers schema for each remote in registry" do
      subject.remotes.each do
        subject.stub(:register_remote_schema)
      end

      subject.should_receive(:register_remote_schema).exactly(subject.remotes.size).times

      subject.register_schemas
    end
  end

  describe ".remote_schemas" do
    it {
      subject.register_schemas
      subject.remote_schemas.should include(:product_schema)
    }
  end

  describe ".remotes" do
    it { described_class.remotes.should include(Product) }
  end

  describe ".remote_schema?" do
    it {
      described_class.remote_schema?("product").should be true
    }
  end

  describe ".get_remote_schema" do
    it {
      subject.get_remote_schema("product").should be_a(::Cylons::RemoteSchema)
    }
  end
end
