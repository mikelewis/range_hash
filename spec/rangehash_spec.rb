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

  end

end

describe RangeHashElement do
  it "should handle inclusive ranges for end" do
    e = RangeHashElement.new((1..10), 'a')
    e.end.should == 10
  end

  it "should handle begin for ranges" do
    e = RangeHashElement.new((1..10), 'a')
    e.begin.should == 1
  end

  it "should handle exclusive ranges end" do
    e = RangeHashElement.new((1...10), 'a')
    e.end.should == 9
  end
end
