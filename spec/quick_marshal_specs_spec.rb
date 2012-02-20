require "spec_helper"

describe Gemgate::QuickMarshalSpecs do
  it "adds a quick marshal spec to storage for a gem" do
    storage = mock("storage")
    storage.should_receive(:create).with("quick/Marshal.4.8/foobar-0.0.1.gemspec.rz", Gem.deflate(Marshal.dump("spec")))

    gem = mock("gem")
    gem.should_receive(:spec_filename) { "foobar-0.0.1.gemspec" }
    gem.should_receive(:spec) { "spec" }

    subject.storage = storage

    subject.add(gem)
  end
end
