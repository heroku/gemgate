require "spec_helper"

describe Gemgate::Repository do
  it "uses the gem realizer to realize a gem binary blob" do
    realizer = double("realizer")
    expect(realizer).to receive(:call).with("hi")

    gem_files = double("gem_files").as_null_object

    index = double("index").as_null_object

    subject.realizer = realizer
    subject.gem_files = gem_files
    subject.index = index

    subject.add_gem("hi")
  end

  it "adds the realized gem to the gem files" do
    gem = double("gem")

    realizer = double("realizer", :call => gem)

    gem_files = double("gem_files")
    expect(gem_files).to receive(:add).with(gem)

    index = double("index").as_null_object

    subject.realizer = realizer
    subject.gem_files = gem_files
    subject.index = index

    subject.add_gem("hi")
  end

  it "adds the realized gem to the index" do
    gem = double("gem")

    realizer = double("realizer", :call => gem)

    gem_files = double("gem_files").as_null_object

    index = double("index")
    expect(index).to receive(:add).with(gem)

    subject.realizer = realizer
    subject.gem_files = gem_files
    subject.index = index

    subject.add_gem("hi")
  end
end
