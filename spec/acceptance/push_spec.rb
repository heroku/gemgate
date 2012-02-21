require "spec_helper"

describe "acceptance: push" do
  it "basically works" do
    post "/", :file => Rack::Test::UploadedFile.new(fixture("foobar-0.0.1.gem"), "application/octet-stream")

    last_response.status.should == 200

    file = directory.files.get("gems/foobar-0.0.1.gem")
    file.should_not be_nil, "gems/foobar-0.0.1.gem should exist"
    file.public_url.should_not be_nil, "gems/foobar-0.0.1.gem should be public"
    file.body.tap {|b| b.force_encoding("binary") }.should == fixture_read("foobar-0.0.1.gem")

    file = directory.files.get("latest_specs.4.8.gz")
    file.should_not be_nil, "latest_specs.4.8.gz should exist"
    file.public_url.should_not be_nil, "latest_specs.4.8.gz should be public"

    latest_specs = Marshal.load(Gem.gunzip(file.body))
    latest_specs.should == [["foobar", Gem::Version.new("0.0.1"), "ruby"]]

    file = directory.files.get("prerelease_specs.4.8.gz")
    file.should_not be_nil, "prerelease_specs.4.8.gz should exist"
    file.public_url.should_not be_nil, "prerelease_specs.4.8.gz should be public"

    prerelease_specs = Marshal.load(Gem.gunzip(file.body))
    prerelease_specs.should == []

    file = directory.files.get("quick/Marshal.4.8/foobar-0.0.1.gemspec.rz")
    file.should_not be_nil, "quick spec should exist"
    file.public_url.should_not be_nil, "quick spec should be public"

    quick_spec = Marshal.load(Gem.inflate(file.body))
    quick_spec.should == Gemgate::GemWrapper.from_path(fixture("foobar-0.0.1.gem")).spec
  end

  it "basically works for a prerelease gem" do
    post "/", :file => Rack::Test::UploadedFile.new(fixture("foobar-0.0.1.pre.gem"), "application/octet-stream")

    last_response.status.should == 200

    file = directory.files.get("gems/foobar-0.0.1.pre.gem")
    file.should_not be_nil, "gems/foobar-0.0.1.pre.gem should exist"
    file.public_url.should_not be_nil, "gems/foobar-0.0.1.pre.gem should be public"
    file.body.tap {|b| b.force_encoding("binary") }.should == fixture_read("foobar-0.0.1.pre.gem")

    file = directory.files.get("latest_specs.4.8.gz")
    file.should_not be_nil, "latest_specs.4.8.gz should exist"
    file.public_url.should_not be_nil, "latest_specs.4.8.gz should be public"

    latest_specs = Marshal.load(Gem.gunzip(file.body))
    latest_specs.should == []

    file = directory.files.get("prerelease_specs.4.8.gz")
    file.should_not be_nil, "prerelease_specs.4.8.gz should exist"
    file.public_url.should_not be_nil, "prerelease_specs.4.8.gz should be public"

    prerelease_specs = Marshal.load(Gem.gunzip(file.body))
    prerelease_specs.should == [["foobar", Gem::Version.new("0.0.1.pre"), "ruby"]]

    file = directory.files.get("quick/Marshal.4.8/foobar-0.0.1.pre.gemspec.rz")
    file.should_not be_nil, "quick spec should exist"
    file.public_url.should_not be_nil, "quick spec should be public"

    quick_spec = Marshal.load(Gem.inflate(file.body))
    quick_spec.should == Gemgate::GemWrapper.from_path(fixture("foobar-0.0.1.pre.gem")).spec
  end
end
