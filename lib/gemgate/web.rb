require "sinatra/base"

module Gemgate
  class Web < Sinatra::Base

    class << self
      attr_accessor :repository
    end

    enable :raise_errors
    disable :show_exceptions

    post "/" do
      repository.add_gem(params[:file][:tempfile].path)

      status 200
    end

    helpers do
      def repository
        @repository ||= self.class.repository || Repository.new
      end
    end
  end
end
