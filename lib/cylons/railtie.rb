require 'cylons'
require 'rails'
require 'rails/railtie'
require 'active_record'
# require 'will_paginate'
require 'will_paginate/array'

module Cylons
  class Railtie < ::Rails::Railtie
    config.after_initialize do
      ::Cylons::RemoteDiscovery.load_remotes unless ::Cylons.silence? || ::Cylons::RemoteDiscovery.loaded? || ::Cylons.config.static?
    end if ::Cylons.connect?

    ::ActiveSupport.on_load(:cylons) do
      ::Cylons::Connection.connect unless ::Cylons.silence? || ::Cylons::RemoteDiscovery.loaded? || ::Cylons::Connection.connected?
    end if ::Cylons.connect?

    ::ActiveSupport.on_load(:active_record) do
      require 'will_paginate/active_record'
    end
  end
end
