module Gemgate
  class SpecsIndex
    class Entry
      def initialize(gem)
        @gem = gem
      end

      def for_inclusion
        [@gem.name, @gem.version, @gem.platform]
      end
    end

    attr_accessor :storage
    attr_reader :conditions

    def initialize(filename)
      @filename = filename
      @conditions = []
    end

    def add(gem)
      entry = Entry.new(gem)

      if conditions.all? {|c| c.call(gem) }
        update_with(entry)
      else
        ensure_exists
      end
    end

    private

    def ensure_exists
      unless existing_file_data
        storage.update(@filename, to_gzipped_marshal([]))
      end
    end

    def update_with(entry)
      storage.update(@filename, to_gzipped_marshal(existing_data + [entry.for_inclusion]))
    end

    def existing_file_data
      @existing_file_data ||= storage.get(@filename)
    end

    def existing_data
      if existing_file_data
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
