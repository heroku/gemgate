require "spec_helper"

describe "acceptance: push" do
  it "basically works" do
    post "/", :file => Rack::Test::UploadedFile.new(fixture("foobar-0.0.1.gem"), "application/octet-stream")

    last_response.status.should == 200

    file = directory.files.get("deadbeef/gems/foobar-0.0.1.gem")
    file.should_not be_nil, "gems/foobar-0.0.1.gem should exist"
    file.public_url.should_not be_nil, "gems/foobar-0.0.1.gem should be public"
    file.body.tap {|b| b.force_encoding("binary") }.should == fixture_read("foobar-0.0.1.gem")

    file = directory.files.get("deadbeef/latest_specs.4.8.gz")
    file.should_not be_nil, "latest_specs.4.8.gz should exist"
    file.public_url.should_not be_nil, "latest_specs.4.8.gz should be public"

    latest_specs = Marshal.load(Gem.gunzip(file.body))
    latest_specs.should == [["foobar", Gem::Version.new("0.0.1"), "ruby"]]

    file = directory.files.get("deadbeef/specs.4.8.gz")
    file.should_not be_nil, "specs.4.8.gz should exist"
    file.public_url.should_not be_nil, "specs.4.8.gz should be public"

    specs = Marshal.load(Gem.gunzip(file.body))
    specs.should == latest_specs

    file = directory.files.get("deadbeef/prerelease_specs.4.8.gz")
    file.should_not be_nil, "prerelease_specs.4.8.gz should exist"
    file.public_url.should_not be_nil, "prerelease_specs.4.8.gz should be public"

    prerelease_specs = Marshal.load(Gem.gunzip(file.body))
    prerelease_specs.should == []

    file = directory.files.get("deadbeef/quick/Marshal.4.8/foobar-0.0.1.gemspec.rz")
    file.should_not be_nil, "quick spec should exist"
    file.public_url.should_not be_nil, "quick spec should be public"

    quick_spec = Marshal.load(Gem.inflate(file.body))
    quick_spec.should == Gemgate::GemWrapper.from_path(fixture("foobar-0.0.1.gem")).spec
  end

  it "basically works for a prerelease gem" do
    post "/", :file => Rack::Test::UploadedFile.new(fixture("foobar-0.0.1.pre.gem"), "application/octet-stream")

    last_response.status.should == 200

    file = directory.files.get("deadbeef/gems/foobar-0.0.1.pre.gem")
    file.should_not be_nil, "gems/foobar-0.0.1.pre.gem should exist"
    file.public_url.should_not be_nil, "gems/foobar-0.0.1.pre.gem should be public"
    file.body.tap {|b| b.force_encoding("binary") }.should == fixture_read("foobar-0.0.1.pre.gem")

    file = directory.files.get("deadbeef/latest_specs.4.8.gz")
    file.should_not be_nil, "latest_specs.4.8.gz should exist"
    file.public_url.should_not be_nil, "latest_specs.4.8.gz should be public"

    latest_specs = Marshal.load(Gem.gunzip(file.body))
    latest_specs.should == []

    file = directory.files.get("deadbeef/prerelease_specs.4.8.gz")
    file.should_not be_nil, "prerelease_specs.4.8.gz should exist"
    file.public_url.should_not be_nil, "prerelease_specs.4.8.gz should be public"

    prerelease_specs = Marshal.load(Gem.gunzip(file.body))
    prerelease_specs.should == [["foobar", Gem::Version.new("0.0.1.pre"), "ruby"]]

    file = directory.files.get("deadbeef/quick/Marshal.4.8/foobar-0.0.1.pre.gemspec.rz")
    file.should_not be_nil, "quick spec should exist"
    file.public_url.should_not be_nil, "quick spec should be public"

    quick_spec = Marshal.load(Gem.inflate(file.body))
    quick_spec.should == Gemgate::GemWrapper.from_path(fixture("foobar-0.0.1.pre.gem")).spec
  end

  it "does nothing if no authentication info is provded" do
    header "Authorization", nil

    post "/", :file => Rack::Test::UploadedFile.new(fixture("foobar-0.0.1.pre.gem"), "application/octet-stream")

    last_response.status.should == 401

    file = directory.files.get("deadbeef/gems/foobar-0.0.1.pre.gem")
    file.should be_nil, "gems/foobar-0.0.1.pre.gem should not exist"
  end

  it "does nothing if no authentication info is provded but is incorrect" do
    basic_authorize "in", "correct"

    post "/", :file => Rack::Test::UploadedFile.new(fixture("foobar-0.0.1.pre.gem"), "application/octet-stream")

    last_response.status.should == 401

    file = directory.files.get("deadbeef/gems/foobar-0.0.1.pre.gem")
    file.should be_nil, "gems/foobar-0.0.1.pre.gem should not exist"
  end
end
