module Gemgate
  class QuickMarshalSpecs
    class Entry
      def initialize(gem)
        @gem = gem
      end

      def filename
        "quick/Marshal.4.8/#{@gem.spec_filename}.rz"
      end

      def spec
        @gem.spec
      end
    end

    attr_accessor :storage

    def add(gem)
      entry = Entry.new(gem)

      storage.create(entry.filename, to_deflated_marshal(entry.spec))
    end

    private

    def to_deflated_marshal(data)
      Gem.deflate(Marshal.dump(data))
    end
  end
end
