require 'spec_helper'

describe ::Cylons::ServiceManager do
  describe ".remotes?" do
    it "should return true if remotes were registered" do
      described_class.remotes?.should == false
    end
  end
end