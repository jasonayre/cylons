require 'active_attr'
require 'active_model'
require 'active_support/core_ext/array'
require 'active_support/core_ext/hash'
require 'active_support/inflector'
require 'active_support/json'
require 'will_paginate'
require "cylons/version"

require 'cylons/attributes'
require 'cylons/connection'
require 'cylons/configuration'
require 'cylons/errors'
require 'cylons/remote'
require 'cylons/remote_registry'
require 'cylons/remote_discovery'
require 'cylons/remote_proxy'
require 'cylons/registry_adapter'
require 'cylons/service'
require 'cylons/service_manager'
require 'dcell'
require 'socket'
require 'zk'
require 'dcell/registries/zk_adapter'
require 'pry'

module Cylons
  #dont load remotes if test env or SKIP_CYLONS=true (such as when running rake tasks)  
  def self.skip_cylons?
    !!ENV["SKIP_CYLONS"]
  end
    
  def self.silence?
    skip_cylons? || (defined?(Rails) && Rails.env == "test")
  end
  
  class << self
    attr_accessor :configuration, :logger
    
    def configuration
      @configuration ||= ::Cylons::Configuration.new
    end

    def configure
      yield(configuration) if block_given?
      
      @logger = configuration.logger
      
      ::ActiveSupport.run_load_hooks(:cylons, self)
    end
    
    alias_method :config, :configuration
  end
end

require 'cylons/railtie' if defined?(Rails)