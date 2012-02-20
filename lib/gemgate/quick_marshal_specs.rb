module Gemgate
  class QuickMarshalSpecs
    attr_accessor :storage

    def add(gem)
      storage.create("quick/Marshal.4.8/#{gem.spec_filename}.rz", Gem.deflate(Marshal.dump(gem.spec)))
    end
  end
end
