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
      # create our own instance of Gem::Version for the incoming gem version.
      # this works around an issue where the @hash instance variable is already set
      # in the YAML-dumped metadata in the uploaded gem, which breaks our uniq'ing of the
      # index.
      store(existing_data + [[gem.name, Gem::Version.create(gem.version.version), gem.platform]])
    end

    def existing_file_data
      @existing_file_data ||= storage.get(@filename)
    end

    def existing_data
      if existing_file_data
        from_gzipped_marshal(existing_file_data).map do |(name, version, platform)|
          # create our own Gem::Version here, too
          [name, Gem::Version.create(version.version), platform]
        end
      else
        []
      end
    end

    def store(data)
      storage.update(@filename, to_gzipped_marshal(data.uniq))
    end

    def to_gzipped_marshal(data)
      Gem.gzip(Marshal.dump(data))
    end

    def from_gzipped_marshal(data)
      Marshal.load(Gem.gunzip(data))
    end
  end
end
