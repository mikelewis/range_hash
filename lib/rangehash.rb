require "rangehash/version"
require 'forwardable'

class Range
  def real_end
    exclude_end? ? self.end - 1 : self.end
  end
end

class RangeHashElement
  extend Forwardable

  attr_reader :range
  attr_accessor :value

  def_delegators :@range, :begin
  def_delegator :@range, :real_end, :end
  def initialize(range, value)
    @range, @value = range, value
  end
end

class RangeHash
  def initialize
    @arr = []
    @default_callback = nil
  end

  def [](key)
    result = search(key)
  end

  def call(key)
    callback = search(key)
    if callback
      callback.call(key)
    else
      if Proc === @default_callback
        @default_callback.call(key)
      end
    end
    nil
  end

  def []=(key,value)
    index = search(key.real_end, true)
    if index < 0
      elem = RangeHashElement.new(key, value)
      index = -(index + 1)
      @arr.insert(index, elem)
    else
      @arr[index].value = value
    end
    value
  end

  def add_callback(range, &callback)
    if range == :default
      @default_callback = callback
    else
      self[range] = callback
    end
    nil
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

