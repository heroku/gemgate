module Gemgate
  class SpecsIndex
    attr_accessor :storage
    attr_reader :conditions

    def initialize(filename)
      @filename = filename
      @conditions = []
    end

    def add(gem)
      if conditions.all? {|c| c.call(gem) }
        update_with(gem)
      else
        ensure_exists
      end
    end

    private

    def ensure_exists
      unless existing_file_data
        store([])
      end
    end

    def update_with(gem)
      store(existing_data + [[gem.name, gem.version, gem.platform]])
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

    def store(data)
      storage.update(@filename, to_gzipped_marshal(data))
    end

    def to_gzipped_marshal(data)
      Gem.gzip(Marshal.dump(data))
    end

    def from_gzipped_marshal(data)
      Marshal.load(Gem.gunzip(data))
    end
  end
end
