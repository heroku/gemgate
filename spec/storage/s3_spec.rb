require "spec_helper"

describe Gemgate::Storage::S3 do
  subject { described_class.new("AWS_ACCESS_KEY_ID" => "foobar", "AWS_SECRET_ACCESS_KEY" => "foobar", "S3_BUCKET" => "gemgate-test", "S3_KEY_PREFIX" => "ultrasecure") }

  it "creates a public file with the given path and body" do
    subject.create("foobar", "hello")

    remote_file = remote_directory.files.detect {|f| f.key == "ultrasecure/foobar" }
    remote_file.should_not be_nil

    remote_file.body.should == "hello"

    remote_file.public_url.should_not be_nil
  end

  it "updates a public file that already exists" do
    remote_directory.files.create(:key => "ultrasecure/foobar", :body => "first")

    subject.update("foobar", "second")

    remote_file = remote_directory.files.detect {|f| f.key == "ultrasecure/foobar" }
    remote_file.body.should == "second"

    remote_file.public_url.should_not be_nil
  end

  it "creates a public file that doesn't exist when updating" do
    subject.update("foobar", "created")

    remote_file = remote_directory.files.detect {|f| f.key == "ultrasecure/foobar" }
    remote_file.body.should == "created"

    remote_file.public_url.should_not be_nil
  end

  it "gets an existing file's data" do
    remote_directory.files.create(:key => "ultrasecure/foobar", :body => "hello")

    subject.get("foobar").should == "hello"
  end

  it "returns nil when getting a file that doesn't exist" do
    subject.get("foobar").should be_nil
  end

  it "errors if the bucket doesn't exist" do
    remote_directory.destroy

    expect { subject.get("foobar") }.to raise_error(described_class::Error, "Bucket `gemgate-test` doesn't exist")
  end

  def remote_directory
    fog.directories.get("gemgate-test")
  end
end
