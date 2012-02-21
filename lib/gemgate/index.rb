module Gemgate
  class Index
    attr_accessor :storage
    attr_writer :latest_specs, :prerelease_specs, :quick_marshal_specs

    def add(gem)
      latest_specs.add(gem)
      prerelease_specs.add(gem)
      quick_marshal_specs.add(gem)
    end

    private

    def latest_specs
      @latest_specs ||= SpecsIndex.new("latest_specs.4.8.gz").tap do |s|
        s.storage = storage
      end
    end

    def prerelease_specs
      @prerelease_specs ||= SpecsIndex.new("prerelease_specs.4.8.gz").tap do |s|
        s.storage = storage
        s.conditions << lambda {|g| g.prerelease? }
      end
    end

    def quick_marshal_specs
      @quick_marshal_specs || QuickMarshalSpecs.new.tap {|l| l.storage = storage }
    end
  end
end
