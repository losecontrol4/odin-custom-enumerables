module Enumerable
  # Your code goes here
  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    my_each do |element|
      yield element, i
      i += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    result = []
    my_each { |element| result.push(element) if yield element }
    result
  end

  def my_count
    return length unless block_given?

    count = 0
    my_each { |element| count += 1 if yield element }
    count
  end

  def my_all?
    result = true
    if block_given?
      my_each { |element| result = false unless yield element }
    else
      my_each { |element| result = false unless element }
    end
    result
  end

  def my_any?
    result = false
    if block_given?
      my_each { |element| result = true if yield element }
    else
      my_each { |element| result = true if element }
    end
    result
  end

  def my_none?(&block)
    !my_any?(&block)
  end

  def my_map
    return to_enum(:my_map) unless block_given?

    result = []
    my_each { |element| result.push(yield element) }
    result
  end

  def my_inject(initial = nil, symbol = nil)
    if block_given?
      if initial.nil?
        memo = self[0]
        drop(1).my_each { |element| memo = yield memo, element }
      else
        memo = initial
        my_each { |element| memo = yield memo, element }
      end
    else
      # Raise an ERROR if initial is nil
      memo = initial
      if symbol.nil?
        symbol = initial
        memo = self[0]
        drop(1).my_each { |element| memo = symbol.to_proc.call(memo, element) }
      else
        my_each { |element| memo = symbol.to_proc.call(memo, element) }
      end
    end
    memo
  end
end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  # Define my_each here
  def my_each
    return to_enum(:my_each) unless block_given?

    length = self.length
    i = 0
    while i < length
      yield self[i]
      i += 1
    end
    self
  end
end

# puts [1, 2, 3].my_inject(:-)
