require 'socket'
module Cylons
  class Interface
    def self.primary
      ::IPSocket.getaddress(::Socket.gethostname)
    end
  end
end