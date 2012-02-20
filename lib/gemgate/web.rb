require "fog"
require "sinatra/base"

require "rubygems/format"

module Gemgate
  class Web < Sinatra::Base

    enable :raise_errors
    disable :show_exceptions

    post "/" do
      # upload file to S3
      # generate file-specific index things
      #   quick/Marshal.4.8/foo-0.0.1.gemspec.rz
      # upload file-specific index things to S3
      # generate global index things
      #   latest_specs.4.8
      #   latest_specs.4.8.gz
      #   prerelease_specs.4.8
      #   prerelease_specs.4.8.gz
      #   specs.4.8
      #   specs.4.8.gz
      # upload file-specific index things to S3

      filename = params[:file][:filename]

      gem_file = gems_directory.files.new(:key => "gems/#{filename}")
      gem_file.body = params[:file][:tempfile]
      gem_file.public = true
      gem_file.save

      ""
    end

    helpers do
      def gems_directory
        s3.directories.get(ENV["S3_BUCKET"])
      end

      def s3
        Fog::Storage.new(
          :provider => "AWS",
          :aws_access_key_id => ENV["AWS_ACCESS_KEY_ID"],
          :aws_secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"]
        )
      end
    end
  end
end
