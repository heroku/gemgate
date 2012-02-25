require "sinatra/base"
require "tempfile"

module Gemgate
  class Web < Sinatra::Base

    class << self
      attr_accessor :repository
    end

    def self.env!(name)
      ENV[name] or raise "ENV[#{name}] must be set"
    end

    def self.auth
      env!("GEMGATE_AUTH").split(":")
    end

    configure :test do
      enable :raise_errors
    end

    disable :show_exceptions

    post "/" do
      full_authorize

      repository.add_gem(params[:file][:tempfile].path)

      status 200
    end

    post "/api/v1/gems" do
      gem_push_authorize

      Tempfile.open("gem") do |f|
        while data = request.body.read(8192)
          f.write(data)
        end
        f.close

        repository.add_gem(f.path)
      end

      status 200
    end

    helpers do
      def full_authorize
        unless basic_auth_credentials == self.class.auth
          halt 401
        end
      end

      def gem_push_authorize
        unless request.env["HTTP_AUTHORIZATION"] == self.class.auth.last
          halt 401
        end
      end

      def basic_auth_credentials
        auth = Rack::Auth::Basic::Request.new(request.env)
        auth.provided? && auth.basic? ? auth.credentials : []
      end

      def repository
        @repository ||= self.class.repository || Repository.new
      end
    end
  end
end
