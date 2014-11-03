module Cylons
  class CylonsError < StandardError; end
  class CylonsConfigurationError < CylonsError; end
  class CylonsRemoteError < CylonsError; end
  class CylonsRemoteServiceNotFound < CylonsError; end
  class CylonsRemoteProxyError < CylonsError; end
  class CylonsRecordNotFound < CylonsRemoteError; end
  class InvalidRegistryAdapter < CylonsConfigurationError; end
  class CouldNotConnectToRegistry < CylonsConfigurationError; end
  class RemoteNamespaceNotSet < CylonsConfigurationError; end
  class HowDoYouKillThatWhichHasNoLife < CylonsRemoteProxyError; end
end
