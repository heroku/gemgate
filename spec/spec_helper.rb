ENV["AWS_ACCESS_KEY_ID"] = "foobar"
ENV["AWS_SECRET_ACCESS_KEY"] = "foobar"
ENV["S3_BUCKET"] = "gemgate-test"

require "gemgate/web"

require "rack/test"

RSpec.configure do |c|
  c.include Rack::Test::Methods

  c.before do
    Fog.mock!
    Fog::Mock.reset

    directory.save
  end

  def app
    Gemgate::Web
  end

  def fixture(name)
    File.join(File.expand_path("../fixtures", __FILE__), name)
  end

  def directory
    @directory ||= fog.directories.new(:key => ENV["S3_BUCKET"])
  end

  def fog
    @fog ||= Fog::Storage.new(
      :provider => "AWS",
      :aws_access_key_id => ENV["AWS_ACCESS_KEY_ID"],
      :aws_secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"]
    )
  end
end
