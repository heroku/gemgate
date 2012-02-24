require "sinatra/base"

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

    use Rack::Auth::Basic, "gemgate" do |username, password|
      [username, password] == auth
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
