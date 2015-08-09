require "spec_helper"

describe Gemgate::Index do
  it "adds a gem to latest specs" do
    gem = double("gem")

    specs = double("specs").as_null_object

    latest_specs = double("latest specs")
    expect(latest_specs).to receive(:add).with(gem)

    prerelease_specs = double("latest specs").as_null_object

    quick_marshal_specs = double("quick marshal specs").as_null_object

    subject.specs = specs
    subject.latest_specs = latest_specs
    subject.prerelease_specs = prerelease_specs
    subject.quick_marshal_specs = quick_marshal_specs

    subject.add(gem)
  end

  it "adds a gem to specs" do
    gem = double("gem")

    specs = double("specs")
    expect(specs).to receive(:add).with(gem)

    latest_specs = double("latest specs").as_null_object

    prerelease_specs = double("latest specs").as_null_object

    quick_marshal_specs = double("quick marshal specs").as_null_object

    subject.specs = specs
    subject.prerelease_specs = prerelease_specs
    subject.latest_specs = latest_specs
    subject.quick_marshal_specs = quick_marshal_specs

    subject.add(gem)
  end

  it "adds a gem to the prerelease specs" do
    gem = double("gem")

    specs = double("specs").as_null_object

    latest_specs = double("latest specs").as_null_object

    prerelease_specs = double("prerelease specs")
    expect(prerelease_specs).to receive(:add).with(gem)

    quick_marshal_specs = double("quick marshal specs").as_null_object

    subject.specs = specs
    subject.latest_specs = latest_specs
    subject.prerelease_specs = prerelease_specs
    subject.quick_marshal_specs = quick_marshal_specs

    subject.add(gem)
  end

  it "adds a gem to the quick marshal specs" do
    gem = double("gem")

    specs = double("specs").as_null_object

    latest_specs = double("latest specs").as_null_object

    prerelease_specs = double("latest specs").as_null_object

    quick_marshal_specs = double("quick marshal specs")
    expect(quick_marshal_specs).to receive(:add).with(gem)

    subject.specs = specs
    subject.latest_specs = latest_specs
    subject.prerelease_specs = prerelease_specs
    subject.quick_marshal_specs = quick_marshal_specs

    subject.add(gem)
  end
end
