require "spec_helper"

describe Gemgate::Index do
  it "adds a specification using storage" do
    storage = mock("storage")
    storage.should_receive(:update).with("latest_specs.4.8.gz", Gem.gzip(Marshal.dump([["foobar", "0.0.1", "ruby"]])))

    gem = mock("gem")
    gem.should_receive(:name) { "foobar" }
    gem.should_receive(:version) { "0.0.1" }
    gem.should_receive(:platform) { "ruby" }

    subject.storage = storage

    subject.add(gem)
  end
end
