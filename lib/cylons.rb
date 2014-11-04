require 'active_attr'
require 'active_model'
require 'active_support/core_ext/array'
require 'active_support/core_ext/hash'
require 'active_support/inflector'
require 'active_support/json'
require 'will_paginate'
require 'will_paginate/array'
require "cylons/version"

require 'cylons/attributes'
require 'cylons/agent'
require 'cylons/connection'
# require 'cylons/configuration'
require 'cylons/config'
require 'cylons/errors'
require 'cylons/logging'
require 'cylons/remote'
require 'cylons/remote_registry'
require 'cylons/remote_discovery'
require 'cylons/remote_pagination'
require 'cylons/registry_adapter'
require 'cylons/service'
require 'cylons/service_manager'
require 'dcell'
require 'socket'
require 'zk'
require 'dcell/registries/zk_adapter'
require 'pry'

module Cylons
  def self.connect?
    !!ENV["RPC"]
  end

  def self.load_models
    ::Dir.glob(model_paths).each{ |file|
        puts "loading #{file}"
       load file }
  end

  def self.model_paths
    if configuration.model_paths
      return configuration.model_paths
    elsif defined?(::Rails)
      [::Rails.root.join('app', 'models', "*.rb"), ::Rails.root.join('app', 'models', "**", "*.rb")]
    else
      []
    end
  end

  def self.skip_cylons?
    !connect?
  end

  def self.silence?
    skip_cylons? || (defined?(Rails) && Rails.env == "test")
  end

  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= ::Cylons::Config.new
    end

    def configure
      yield(configuration) if block_given?

      @logger = configuration.logger

      ::ActiveSupport.run_load_hooks(:cylons, self)
    end
    alias_method :config, :configuration

    def logger
      ::Cylons.config.logger
    end


    delegate :connect, :to => ::Cylons::Connection
    delegate :connected?, :to => ::Cylons::Connection
  end
end

require 'cylons/railtie' if defined?(Rails)
