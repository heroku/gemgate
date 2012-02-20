module Gemgate
  class Index
    attr_accessor :storage
    attr_writer :latest_specs, :quick_marshal_specs

    def add(gem)
      latest_specs.add(gem)
      quick_marshal_specs.add(gem)
    end

    private

    def latest_specs
      @latest_specs || LatestSpecs.new.tap {|l| l.storage = storage }
    end

    def quick_marshal_specs
      @quick_marshal_specs || QuickMarshalSpecs.new.tap {|l| l.storage = storage }
    end
  end
end
