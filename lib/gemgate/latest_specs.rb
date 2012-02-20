module Gemgate
  class LatestSpecs
    attr_accessor :storage

    def add(gem)
      storage.update("latest_specs.4.8.gz", Gem.gzip(Marshal.dump([[gem.name, gem.version, gem.platform]])))
    end
  end
end
