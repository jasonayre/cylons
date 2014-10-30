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
      ::Cylons::RemoteDiscovery.load_remotes unless ::Cylons.silence? || ::Cylons::RemoteDiscovery.loaded? || ::Cylons.config.static?
    end if ::Cylons.connect?

    #todo: overwrite ransack search method to auto paginate by default, or pull ransack out..
    ::ActiveSupport.on_load(:active_record) do
      # ::ActiveRecord::Base.extend ::Ransack::Adapters::ActiveRecord::Base
      require 'will_paginate/active_record'
    end
  end
end
