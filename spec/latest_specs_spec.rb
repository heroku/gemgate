require "spec_helper"

describe Gemgate::LatestSpecs do
  it "adds a gem using storage when there is no existing latest_specs file" do
    gem = mock("gem")
    gem.should_receive(:name) { "foobar" }
    gem.should_receive(:version) { "0.0.1" }
    gem.should_receive(:platform) { "ruby" }

    storage = mock("storage")
    storage.should_receive(:get).with("latest_specs.4.8.gz") { nil }
    storage.should_receive(:update).with("latest_specs.4.8.gz", Gem.gzip(Marshal.dump([["foobar", "0.0.1", "ruby"]])))

    subject.storage = storage

    subject.add(gem)
  end

  it "adds a gem using storage when there is already a latest_specs file" do
    gem = mock("gem")
    gem.should_receive(:name) { "foobar" }
    gem.should_receive(:version) { "0.0.1" }
    gem.should_receive(:platform) { "ruby" }

    storage = mock("storage")
    storage.should_receive(:get).with("latest_specs.4.8.gz") { Gem.gzip(Marshal.dump([["something", "0.0.2", "ruby"]])) }
    storage.should_receive(:update).with("latest_specs.4.8.gz", Gem.gzip(Marshal.dump([["something", "0.0.2", "ruby"], ["foobar", "0.0.1", "ruby"]])))

    subject.storage = storage

    subject.add(gem)
  end
end
