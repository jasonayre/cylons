require 'spec_helper'

describe ::Cylons::Connection do
  subject { described_class }

  its(:connected) { should be true }

  describe ".validate_configuration" do
    it "should raise error if no remote namespace present" do
      ::Cylons.configuration.remote_namespace.stub(:present?).and_return(false)
      expect{ subject.validate_configuration }.to raise_error ::Cylons::RemoteNamespaceNotSet
    end
  end

end
