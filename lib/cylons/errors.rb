module Cylons
  class CylonsError < StandardError; end
  class CylonsRecordNotFound < CylonsError; end
  class CylonsConfigurationError < CylonsError; end
  class InvalidRegistryAdapter < CylonsConfigurationError; end
  class CouldNotConnectToRegistry < CylonsConfigurationError; end
  class RemoteNamespaceNotSet < CylonsConfigurationError; end
end