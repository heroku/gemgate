module Gemgate
  module Storage
    class S3
      def initialize(options)
        @options = options
      end

      def create(path, body)
        remote_directory.files.create(:key => path, :body => body, :acl => "public-read")
      end

      def update(path, body)
        create(path, body)
      end

      private

      def remote_directory
        fog.directories.get(@options["S3_BUCKET"])
      end

      def fog
        Fog::Storage.new(:provider => "AWS", :aws_access_key_id => @options["AWS_ACCESS_KEY_ID"], :aws_secret_access_key => @options["AWS_SECRET_ACCESS_KEY"])
      end
    end
  end
end
