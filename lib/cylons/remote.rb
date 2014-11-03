require 'cylons/remote_registry'
require 'cylons/active_record_extensions'

module Cylons
  module Remote
    extend ::ActiveSupport::Concern

    include ::Cylons::ActiveRecordExtensions
    include ::Cylons::Associations

    included do
      class_attribute :remote_associations
      self.remote_associations = []

      ::Cylons::RemoteRegistry.register(self)
    end
  end
end
