require 'spec_helper'

describe RangeHash do
  before do
    @rh = RangeHash.new
  end
  [:[], :[]=].each do |meth|
    it "should respond to #{meth}" do
      @rh.should respond_to(meth)
    end
  end

  context "integeration" do
    before  do
      c = (13..16)
      d = (20...25)
      a = (1..10)
      b = (10...13)

      @rh[c] = 'c'
      @rh[d] = 'd'
      @rh[a] = 'a'
      @rh[b] = 'b'
    end
    it "should insert to keep the internal array" do
      internal_array = @rh.instance_eval { @arr }
      internal_array.map(&:value).should == ['a', 'b', 'c', 'd']
    end

    it "[] should return the associated value for that range" do
      @rh[21].should == 'd'
    end

    it "[] should return nil for a value that is not in a range" do
      @rh[25].should == nil
    end

    it "should beable to replace an element" do
      @rh[(13..16)] = 'new'

      @rh[14].should == 'new'
    end

    it "should accept callbacks and return nil" do
      result = nil
      n = @rh.add_callback(100..105) do |elem|
        result = elem
      end

      @rh.call(103)

      result.should == 103
      n.should be_nil
    end

    it "should accept a default callback" do
      result = nil
      @rh.add_callback(:default) do |elem|
        result = elem
      end
      @rh.call(2000)
      result.should == 2000
    end

    it "should return nil and not blow up when accessing a callback that does not exist" do
      lambda { @rh.call(3) }.should_not raise_error
      @rh.call(3).should be_nil
    end

    it "should raise an ArgumentError if no block is passed into add_callback" do
      lambda { @rh.add_callback((1..3)) }.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if a non range or not default is passed into a callback" do
      lambda { @rh.add_callback(3) }.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if key is not range" do
      lambda { @rh["yo"] = 5}.should raise_error(ArgumentError)
    end

  end

end

describe RangeHashElement do
  it "should handle inclusive ranges for end" do
    e = RangeHashElement.new(:range => (1..10), :value => 'a')
    e.end.should == 10
  end

  it "should handle begin for ranges" do
    e = RangeHashElement.new(:range => (1..10), :value => 'a')
    e.begin.should == 1
  end

  it "should handle exclusive ranges end" do
    e = RangeHashElement.new(:range => (1...10), :value => 'a')
    e.end.should == 9
  end
end
