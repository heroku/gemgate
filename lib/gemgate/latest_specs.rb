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

      update_with(entry)
    end

    private

    def filename
      "latest_specs.4.8.gz"
    end

    def update_with(entry)
      storage.update(filename, to_gzipped_marshal(existing_data + [entry.for_inclusion]))
    end

    def existing_data
      if existing_file_data = storage.get(filename)
        from_gzipped_marshal(existing_file_data)
      else
        []
      end
    end

    def to_gzipped_marshal(data)
      Gem.gzip(Marshal.dump(data))
    end

    def from_gzipped_marshal(data)
      Marshal.load(Gem.gunzip(data))
    end
  end
end
