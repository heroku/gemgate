module Gemgate
  module Storage
    class S3
      def initialize(env = ENV)
        @env = env
      end

      def get(path)
        if file = remote_directory.files.get(prefix(path))
          file.body
        end
      end

      def create(path, body)
        remote_directory.files.create(:key => prefix(path), :body => body, :acl => "public-read")
      end

      def update(path, body)
        create(path, body)
      end

      private

      def env!(name)
        @env[name] or raise "ENV[#{name}] must be set"
      end

      def prefix(path)
        File.join(env!("S3_KEY_PREFIX"), path)
      end

      def remote_directory
        fog.directories.get(env!("S3_BUCKET"))
      end

      def fog
        Fog::Storage.new(:provider => "AWS", :aws_access_key_id => env!("AWS_ACCESS_KEY_ID"), :aws_secret_access_key => env!("AWS_SECRET_ACCESS_KEY"))
      end
    end
  end
end
