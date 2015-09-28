require "spec_helper"

describe Gemgate::GemWrapper do
  describe ".from_path" do
    it "creates a new instance from the provided path" do
      expect(described_class.from_path(fixture("foobar-0.0.1.gem"))).to be_a(described_class)
    end

    it "sets the spec on the new instance" do
      gem_wrapper = described_class.from_path(fixture("foobar-0.0.1.gem"))

      expect(gem_wrapper.spec).to eq(Gem::Package.new(File.open(fixture("foobar-0.0.1.gem"))).spec)
    end

    it "sets the path on the new instance" do
      gem_wrapper = described_class.from_path(fixture("foobar-0.0.1.gem"))

      expect(gem_wrapper.path).to eq(fixture("foobar-0.0.1.gem"))
    end
  end

  subject { described_class.from_path(fixture("foobar-0.0.1.gem")) }

  it "returns its filename" do
    expect(subject.filename).to eq("foobar-0.0.1.gem")
  end

  it "returns its spec filename" do
    expect(subject.spec_filename).to eq("foobar-0.0.1.gemspec")
  end

  it "returns its prerelease status" do
    expect(subject.prerelease?).to be_falsey
  end

  it "returns an io with its data" do
    expect(subject.data).to be_a(IO)
  end

  it "returns its name" do
    expect(subject.name).to eq("foobar")
  end

  it "returns its version" do
    expect(subject.version).to eq(Gem::Version.new("0.0.1"))
  end

  it "returns its platform" do
    expect(subject.platform).to eq("ruby")
  end
end
