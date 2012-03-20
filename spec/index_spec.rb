require "spec_helper"

describe Gemgate::Index do
  it "adds a gem to latest specs" do
    gem = stub("gem")

    specs = stub("specs").as_null_object

    latest_specs = mock("latest specs")
    latest_specs.should_receive(:add).with(gem)

    prerelease_specs = stub("latest specs").as_null_object

    quick_marshal_specs = stub("quick marshal specs").as_null_object

    subject.specs = specs
    subject.latest_specs = latest_specs
    subject.prerelease_specs = prerelease_specs
    subject.quick_marshal_specs = quick_marshal_specs

    subject.add(gem)
  end

  it "adds a gem to specs" do
    gem = stub("gem")

    specs = mock("specs")
    specs.should_receive(:add).with(gem)

    latest_specs = stub("latest specs").as_null_object

    prerelease_specs = stub("latest specs").as_null_object

    quick_marshal_specs = stub("quick marshal specs").as_null_object

    subject.specs = specs
    subject.prerelease_specs = prerelease_specs
    subject.latest_specs = latest_specs
    subject.quick_marshal_specs = quick_marshal_specs

    subject.add(gem)
  end

  it "adds a gem to the prerelease specs" do
    gem = stub("gem")

    specs = stub("specs").as_null_object

    latest_specs = stub("latest specs").as_null_object

    prerelease_specs = mock("prerelease specs")
    prerelease_specs.should_receive(:add).with(gem)

    quick_marshal_specs = stub("quick marshal specs").as_null_object

    subject.specs = specs
    subject.latest_specs = latest_specs
    subject.prerelease_specs = prerelease_specs
    subject.quick_marshal_specs = quick_marshal_specs

    subject.add(gem)
  end

  it "adds a gem to the quick marshal specs" do
    gem = stub("gem")

    specs = stub("specs").as_null_object

    latest_specs = stub("latest specs").as_null_object

    prerelease_specs = stub("latest specs").as_null_object

    quick_marshal_specs = mock("quick marshal specs")
    quick_marshal_specs.should_receive(:add).with(gem)

    subject.specs = specs
    subject.latest_specs = latest_specs
    subject.prerelease_specs = prerelease_specs
    subject.quick_marshal_specs = quick_marshal_specs

    subject.add(gem)
  end
end
