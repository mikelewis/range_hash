
rangehash
========================

##Problem

  Given a list of ranges, how do you effectively find if an element exist in any of them?

##Solution

    [sudo] gem install range_hash

##Example

### Simple

    require 'rangehash'
    ranges = RangeHash.new
    ranges[1..3] = 'a'
    ranges[10..15] = 'b'
    ranges[27...30] = 'c'
    ranges[7..10] = 'd'

    ranges[2] #=> 'a'
    ranges[15] #=> 'b'
    ranges[100] #=> nil

### Callbacks
    require 'rangehash'
    ranges = RangeHash.new
    ranges.add_callback(1..13) do |elem|
      puts "#{elem} is between 1 and 3"
    end
    ranges.add_callback(10..15) do |elem|
      puts "#{elem} is between 10 and 15!"
    end
    ranges.add_callback(27...30) do |elem|
      puts "#{elem} is between 27 and 29!"
    end
    ranges.add_callback(7..10) do |elem|
      puts "#{elem} is between 7 and 10!"
    end
    ranges.add_callback(:default) do |elem|
      puts "Couldn't find a range for #{elem}"
    end

    ranges.call(2) #=> 2 is between 1 and 3!
    ranges.call(15) #=> 15 is between 10 and 15!
    ranges.call(100) #=> Couldn't find a range of 100



##Wait ... why?

  Because O(log n) is better than O(N). RangeHash keeps an internal sorted array that uses a binary search to find your range. This allows you to achieve (log n) search. Another option would be to store a dense hash that stores all possible elements within the ranges, however this isn't efficient in terms of memory usage. This is great happy medium.

  On-top of that, RangeHash provides some awesome functionality such as callbacks.

