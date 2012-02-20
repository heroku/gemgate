require "spec_helper"

describe "acceptance: push" do
  it "basically works" do
    post "/", :file => Rack::Test::UploadedFile.new(fixture("foobar-0.0.1.gem"), "application/octet-stream")

    last_response.status.should == 200

    [
      "gems/foobar-0.0.1.gem"
    ].each do |filename|
      file = directory.files.get(filename)
      file.should_not be_nil, "#{filename} should exist"

      file.public_url.should_not be_nil, "#{filename} should be public"
    end
  end
end
