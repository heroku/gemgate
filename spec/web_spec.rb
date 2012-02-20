require "spec_helper"

describe Gemgate::Web do
  describe "POST /" do
    it "adds the gem to the repository" do
      uploaded_file = Rack::Test::UploadedFile.new(fixture("foobar-0.0.1.gem"), "application/octet-stream")

      repository = mock("repository")
      repository.should_receive("add_gem").with(kind_of(String))

      described_class.repository = repository

      post "/", :file => uploaded_file
    end
  end
end
