require "spec_helper"

describe Gemgate::Repository do
  describe ".default" do
    it "returns the default repository"
  end

  it "uses the gem realizer to realize a gem binary blob" do
    realizer = mock("realizer")
    realizer.should_receive(:call).with("hi")

    gem_files = stub("gem_files").as_null_object

    index = stub("index").as_null_object

    subject.realizer = realizer
    subject.gem_files = gem_files
    subject.index = index

    subject.add_gem("hi")
  end

  it "adds the realized gem to the gem files" do
    gem = stub("gem")

    realizer = stub("realizer", :call => gem)

    gem_files = mock("gem_files")
    gem_files.should_receive(:add).with(gem)

    index = stub("index").as_null_object

    subject.realizer = realizer
    subject.gem_files = gem_files
    subject.index = index

    subject.add_gem("hi")
  end

  it "adds the realized gem to the index" do
    gem = stub("gem")

    realizer = stub("realizer", :call => gem)

    gem_files = stub("gem_files").as_null_object

    index = mock("index")
    index.should_receive(:add).with(gem)

    subject.realizer = realizer
    subject.gem_files = gem_files
    subject.index = index

    subject.add_gem("hi")
  end
end
