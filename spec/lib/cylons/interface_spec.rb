require 'spec_helper'

describe ::Cylons::Interface do
  subject { described_class }

  its(:primary) { should eq ::IPSocket.getaddress(::Socket.gethostname) }
end
