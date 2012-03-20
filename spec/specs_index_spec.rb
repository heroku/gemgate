require "spec_helper"

describe Gemgate::SpecsIndex do
  subject { described_class.new("foobar_specs.4.8.gz") }

  it "adds a gem using storage when there is no existing file" do
    gem = mock("gem")
    gem.should_receive(:name) { "foobar" }
    gem.should_receive(:version) { Gem::Version.create("0.0.1") }
    gem.should_receive(:platform) { "ruby" }

    storage = mock("storage")
    storage.should_receive(:get).with("foobar_specs.4.8.gz") { nil }
    storage.should_receive(:update).with("foobar_specs.4.8.gz", Gem.gzip(Marshal.dump([["foobar", Gem::Version.create("0.0.1"), "ruby"]])))

    subject.storage = storage

    subject.add(gem)
  end

  it "adds a gem using storage when there is an existing file" do
    gem = mock("gem")
    gem.should_receive(:name) { "foobar" }
    gem.should_receive(:version) { Gem::Version.create("0.0.1") }
    gem.should_receive(:platform) { "ruby" }

    storage = mock("storage")
    storage.should_receive(:get).with("foobar_specs.4.8.gz") { Gem.gzip(Marshal.dump([["something", Gem::Version.create("0.0.2"), "ruby"]])) }
    storage.should_receive(:update).with("foobar_specs.4.8.gz", Gem.gzip(Marshal.dump([["something", Gem::Version.create("0.0.2"), "ruby"], ["foobar", Gem::Version.create("0.0.1"), "ruby"]])))

    subject.storage = storage

    subject.add(gem)
  end

  it "adds if all provided conditions are true" do
    gem = stub("gem", :name => "foobar", :version => Gem::Version.create("0.0.1"), :platform => "ruby")

    storage = mock("storage")
    storage.should_receive(:get).with("foobar_specs.4.8.gz") { nil }
    storage.should_receive(:update).with("foobar_specs.4.8.gz", Gem.gzip(Marshal.dump([["foobar", Gem::Version.create("0.0.1"), "ruby"]])))

    subject.storage = storage

    subject.conditions << lambda {|g| g.name == "foobar" } << lambda {|g| g.version == Gem::Version.create("0.0.1") }

    subject.add(gem)
  end

  it "skips adding if not all provided conditions are true" do
    gem = stub("gem", :name => "foobar", :version => Gem::Version.create("0.0.1"), :platform => "ruby")

    storage = mock("storage")
    storage.should_receive(:get).with("foobar_specs.4.8.gz") { Gem.gzip(Marshal.dump([])) }
    storage.should_not_receive(:update)

    subject.storage = storage

    subject.conditions << lambda {|g| g.name == "foobar" } << lambda {|g| g.version == "0.0.2" }

    subject.add(gem)
  end

  it "ensures the file exists even when not adding" do
    gem = stub("gem", :name => "foobar", :version => Gem::Version.create("0.0.1"), :platform => "ruby")

    storage = mock("storage")
    storage.should_receive(:get).with("foobar_specs.4.8.gz") { nil }
    storage.should_receive(:update).with("foobar_specs.4.8.gz", Gem.gzip(Marshal.dump([])))

    subject.storage = storage

    subject.conditions << lambda {|g| g.name == "foobar" } << lambda {|g| g.version == Gem::Version.create("0.0.2") }

    subject.add(gem)
  end

  it "uniqs the added data" do
    gem = mock("gem")
    gem.should_receive(:name) { "foobar" }
    gem.should_receive(:version) { Gem::Version.create("0.0.1") }
    gem.should_receive(:platform) { "ruby" }

    storage = mock("storage")
    storage.should_receive(:get).with("foobar_specs.4.8.gz") { Gem.gzip(Marshal.dump([["foobar", Gem::Version.create("0.0.1"), "ruby"]])) }
    storage.should_receive(:update).with("foobar_specs.4.8.gz", Gem.gzip(Marshal.dump([["foobar", Gem::Version.create("0.0.1"), "ruby"]])))

    subject.storage = storage

    subject.add(gem)
  end
end
