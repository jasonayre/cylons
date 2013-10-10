require 'spec_helper'

describe ::Cylons::RemoteRegistry do
  describe ".remotes" do
    it { described_class.remotes.should include(:product) }
  end
end