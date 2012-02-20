module Gemgate
  class GemFiles
    attr_accessor :storage

    def add(gem)
      storage.create("gems/#{gem.filename}", gem.data)
    end
  end
end
