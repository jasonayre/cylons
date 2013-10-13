require 'cylons'
require 'rails'
require 'rails/railtie'
require 'active_record'
require 'ransack'
require 'ransack/search'
require 'ransack/adapters/active_record/base'
require 'will_paginate'

module Cylons
  class Railtie < ::Rails::Railtie
    config.after_initialize do
      ::Cylons::RemoteDiscovery.load_remotes unless ::Cylons.silence? || ::Cylons::RemoteDiscovery.loaded?
    end

    ::ActiveSupport.on_load(:cylons) do
      ::Cylons::Connection.connect unless ::Cylons.silence? || ::Cylons::RemoteDiscovery.loaded? || ::Cylons::Connection.connected?
      ::Cylons::RemoteDiscovery.load_remotes unless ::Cylons.silence? || ::Cylons::RemoteDiscovery.loaded?
    end
    
    #todo: overwrite ransack search method to auto paginate by default, or pull ransack out..
    ::ActiveSupport.on_load(:active_record) do
      ::ActiveRecord::Base.extend ::Ransack::Adapters::ActiveRecord::Base
      require 'will_paginate/active_record'
      
      case ::ActiveRecord::VERSION::STRING
      when /^3\.0\./
        require 'ransack/adapters/active_record/3.0/context'
      when /^3\.1\./
        require 'ransack/adapters/active_record/3.1/context'
      when /^3\.2\./
        require 'ransack/adapters/active_record/3.2/context'
      else
        require 'ransack/adapters/active_record/context'
      end
    end
  end
end