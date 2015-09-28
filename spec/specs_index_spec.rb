require "spec_helper"

describe Gemgate::SpecsIndex do
  subject { described_class.new("foobar_specs.4.8.gz") }

  it "adds a gem using storage when there is no existing file" do
    gem = double("gem")
    expect(gem).to receive(:name) { "foobar" }
    expect(gem).to receive(:version) { Gem::Version.create("0.0.1") }
    expect(gem).to receive(:platform) { "ruby" }

    storage = double("storage")
    expect(storage).to receive(:get).with("foobar_specs.4.8.gz") { nil }
    expect(storage).to receive(:update).with("foobar_specs.4.8.gz", Gem.gzip(Marshal.dump([["foobar", Gem::Version.create("0.0.1"), "ruby"]])))

    subject.storage = storage

    subject.add(gem)
  end

  it "adds a gem using storage when there is an existing file" do
    gem = double("gem")
    expect(gem).to receive(:name) { "foobar" }
    expect(gem).to receive(:version) { Gem::Version.create("0.0.1") }
    expect(gem).to receive(:platform) { "ruby" }

    storage = double("storage")
    expect(storage).to receive(:get).with("foobar_specs.4.8.gz") { Gem.gzip(Marshal.dump([["something", Gem::Version.create("0.0.2"), "ruby"]])) }
    expect(storage).to receive(:update).with("foobar_specs.4.8.gz", Gem.gzip(Marshal.dump([["something", Gem::Version.create("0.0.2"), "ruby"], ["foobar", Gem::Version.create("0.0.1"), "ruby"]])))

    subject.storage = storage

    subject.add(gem)
  end

  it "adds if all provided conditions are true" do
    gem = double("gem", :name => "foobar", :version => Gem::Version.create("0.0.1"), :platform => "ruby")

    storage = double("storage")
    expect(storage).to receive(:get).with("foobar_specs.4.8.gz") { nil }
    expect(storage).to receive(:update).with("foobar_specs.4.8.gz", Gem.gzip(Marshal.dump([["foobar", Gem::Version.create("0.0.1"), "ruby"]])))

    subject.storage = storage

    subject.conditions << lambda {|g| g.name == "foobar" } << lambda {|g| g.version == Gem::Version.create("0.0.1") }

    subject.add(gem)
  end

  it "skips adding if not all provided conditions are true" do
    gem = double("gem", :name => "foobar", :version => Gem::Version.create("0.0.1"), :platform => "ruby")

    storage = double("storage")
    expect(storage).to receive(:get).with("foobar_specs.4.8.gz") { Gem.gzip(Marshal.dump([])) }
    expect(storage).not_to receive(:update)

    subject.storage = storage

    subject.conditions << lambda {|g| g.name == "foobar" } << lambda {|g| g.version == "0.0.2" }

    subject.add(gem)
  end

  it "ensures the file exists even when not adding" do
    gem = double("gem", :name => "foobar", :version => Gem::Version.create("0.0.1"), :platform => "ruby")

    storage = double("storage")
    expect(storage).to receive(:get).with("foobar_specs.4.8.gz") { nil }
    expect(storage).to receive(:update).with("foobar_specs.4.8.gz", Gem.gzip(Marshal.dump([])))

    subject.storage = storage

    subject.conditions << lambda {|g| g.name == "foobar" } << lambda {|g| g.version == Gem::Version.create("0.0.2") }

    subject.add(gem)
  end

  it "uniqs the added data" do
    gem = double("gem")
    expect(gem).to receive(:name) { "foobar" }
    expect(gem).to receive(:version) { Gem::Version.create("0.0.1") }
    expect(gem).to receive(:platform) { "ruby" }

    storage = double("storage")
    expect(storage).to receive(:get).with("foobar_specs.4.8.gz") { Gem.gzip(Marshal.dump([["foobar", Gem::Version.create("0.0.1"), "ruby"]])) }
    expect(storage).to receive(:update).with("foobar_specs.4.8.gz", Gem.gzip(Marshal.dump([["foobar", Gem::Version.create("0.0.1"), "ruby"]])))

    subject.storage = storage

    subject.add(gem)
  end
end
