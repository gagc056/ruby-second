# frozen_string_literal: true

module Enumerable
  def my_each
    i = 0
    while i < check_self.length
      yield check_self[i]
      i += 1
    end
  end

  def my_each_with_index
    my_each { |i, x| yield i, x }
    self
  end

  def my_select
    return enum_for :my_select unless block_given?

    Enumerator.new do |y|
      my_each { |item| y << item if yield item }
    end.to_a
  end

  def my_all?(intial = nil)
    result = true
    if block_given?
      my_each { |element| result &= (yield element) }
    elsif initial
      my_each { |element| result &= pattern == element }
    else
      my_each { |element| result &= element }
    end
    result
  end

  def my_any?
    my_each { |item| return true if block_given? ? yield(item) : item }
    false
  end

  def my_none?
    my_each do |item|
      return false if block_given? ? yield(item) : item
    end
    true
  end

  def my_count(item = nil)
    count = 0
    if block_given?
      my_each { |i| count += 1 if yield(i) == true }
    elsif item.nil?
      my_each { count += 1 }
    else
      my_each { |i| count += 1 if i == item }
    end
    count
  end

  def my_map
    return to_enum :my_map unless block_given?

    arr = []
    my_each { |element| arr << (yield element) }
    arr
  end

  def my_inject(object = 1, sbl = nil)
    array = if instance_of? Range
              to_a
            else
              self
            end
    if block_given?
      array.unshift(object) if object != 1

      accumulator = array[0]
      (1..array.length - 1).each do |i|
        accumulator = yield(accumulator, array[i])
      end
      accumulator
    else
      if object.class == Symbol
        accumulator = array[0]
        (1..array.length - 1).each do |i|
          accumulator = accumulator.send(object, array[i])
        end
        return accumulator
      end
      if (object.class == Integer) && (sbl.class == Symbol)

        array.unshift(object) if object != 1

        accumulator = array[0]
        (1..array.length - 1).each do |i|
          accumulator = accumulator.send(sbl, array[i])
        end
        return accumulator
      end
    end
  end
end

def multiply_els(arr)
  arr.my_inject(1) { |product, x| product * x }
end
