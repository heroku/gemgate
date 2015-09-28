require "spec_helper"

describe Gemgate::GemFiles do
  it "adds a gem using storage" do
    gem = double("gem")
    expect(gem).to receive(:filename) { "foobar-0.0.1.gem" }
    expect(gem).to receive(:data) { "data" }

    storage = double("storage")
    expect(storage).to receive(:create).with("gems/foobar-0.0.1.gem", "data")

    subject.storage = storage

    subject.add(gem)
  end
end
