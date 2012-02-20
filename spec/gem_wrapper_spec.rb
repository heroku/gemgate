require "spec_helper"

describe Gemgate::GemWrapper do
  describe ".from_path" do
    it "creates a new instance from the provided path" do
      described_class.from_path(fixture("foobar-0.0.1.gem")).should be_a(described_class)
    end

    it "sets the spec on the new instance" do
      gem_wrapper = described_class.from_path(fixture("foobar-0.0.1.gem"))

      gem_wrapper.spec.should == Gem::Package.open(File.open(fixture("foobar-0.0.1.gem"))) {|p| p.metadata }
    end

    it "sets the path on the new instance" do
      gem_wrapper = described_class.from_path(fixture("foobar-0.0.1.gem"))

      gem_wrapper.path.should == fixture("foobar-0.0.1.gem")
    end
  end

  subject { described_class.from_path(fixture("foobar-0.0.1.gem")) }

  it "returns its filename" do
    subject.filename.should == "foobar-0.0.1.gem"
  end

  it "returns an io with its data" do
    subject.data.should be_a(IO)
  end

  it "returns its name" do
    subject.name.should == "foobar"
  end

  it "returns its version" do
    subject.version.should == Gem::Version.new("0.0.1")
  end

  it "returns its platform" do
    subject.platform.should == "ruby"
  end
end
