require 'celluloid'
require 'cylons/rpc'
module Cylons
  class Service
    include ::Celluloid
    include ::Cylons::RPC
    
    class << self
      attr_accessor :model
    end
  end
end