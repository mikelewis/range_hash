require "rangehash/version"
require 'forwardable'

class RangeHashElement
  extend Forwardable

  attr_reader :range
  attr_accessor :value

  def_delegators :@range, :begin
  def initialize(range, value)
    @range, @value = range, value
  end

  def end
    range.exclude_end? ? range.end - 1 : range.end
  end
end

class RangeHash
  def initialize
    @arr = []
  end

  def [](key)
    search(key)
  end

  def []=(key,value)
    elem = RangeHashElement.new(key, value)
    index = search(elem.end, true)
    if index < 0
      insert_index = -(index + 1)
      @arr.insert(insert_index, elem)

      # TODO
      # Edit value if index >= 0
    else
      @arr[index].value = value
    end
    value
  end

  private
  def search(key, ret_index=false)
    low, high = 0, @arr.size - 1
    mid = 0

    while low <= high
      mid = (low + high)/ 2
      if key <= @arr[mid].end && key >= @arr[mid].begin
        val = ret_index ? mid : @arr[mid].value
        return val
      elsif key < @arr[mid].end
        high = mid - 1
      else
        low = mid + 1
      end
    end

    return -low - 1 if ret_index
  end
end

