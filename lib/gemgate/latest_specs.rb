module Gemgate
  class LatestSpecs
    class Entry
      def initialize(gem)
        @gem = gem
      end

      def for_inclusion
        [@gem.name, @gem.version, @gem.platform]
      end
    end

    attr_accessor :storage

    def add(gem)
      entry = Entry.new(gem)

      storage.update(filename, to_gzipped_marshal([entry.for_inclusion]))
    end

    private

    def filename
      "latest_specs.4.8.gz"
    end

    def to_gzipped_marshal(data)
      Gem.gzip(Marshal.dump(data))
    end
  end
end
