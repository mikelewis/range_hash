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
  attr_accessor :value, :callback

  def_delegators :@range, :begin
  def_delegator :@range, :real_end, :end
  def initialize(opts={})
    @range, @value, @callback = opts[:range], opts[:value], opts[:callback]
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
    index = search(key, true)
    if index < 0
      @default_callback.call(key) if @default_callback.respond_to?(:call)
    else
      callback = @arr[index].callback
      callback.call(key) if callback.respond_to?(:call)
    end
    nil
  end

  def []=(range,value)
    raise ArgumentError.new("Key should be a range") unless Range === range
    edit_or_create(range, :range => range, :value => value)
    value
  end

  def add_callback(range, &callback)
    raise ArgumentError.new("Need to pass a callback in the form of a block") unless block_given?
    unless Range === range || range == :default
      raise ArgumentError.new("Argument needs to be a range or :default")
    end
    if range == :default
      @default_callback = callback
    else
      edit_or_create(range, :range => range, :callback => callback)
    end
    nil
  end

  def to_s
    "#RangeHash<@ranges=[#{@arr.map(&:range).join(",")}]>"
  end

  private

  def edit_or_create(range, element_opts={})
    index = search(range.real_end, true)
    if index < 0
      elem = RangeHashElement.new(element_opts)
      index = -(index + 1)
      @arr.insert(index, elem)
    else
      element_opts.delete(:range)
      edit_attr, attr_value = element_opts.to_a.first
      @arr[index].instance_variable_set(:"@#{edit_attr}", attr_value)
    end
  end

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

