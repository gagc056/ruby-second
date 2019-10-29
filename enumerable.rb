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
    return to_enum :my_each_with_index unless block_given?

    i = 0
    my_each do |element|
      yield element, i
      i += 1
    end
    self
  end

  def my_select
    return enum_for :my_select unless block_given?

    Enumerator.new do |y|
      my_each { |item| y << item if yield item }
    end.to_a
  end

  def my_all?(initial = nil)
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

  def my_inject(acc = nil, cur = nil)
    tmp = is_a?(Range) ? to_a : self
    a = acc.nil? || acc.is_a?(Symbol) ? tmp[0] : acc
    if block_given?
      start = acc ? 0 : 1
      tmp[start..-1].my_each { |e| a = yield(a, e) }
    end
    tmp[1..-1].my_each { |e| a = a.send(acc, e) } if acc.is_a?(Symbol)
    tmp[0..-1].my_each { |e| a = a.send(cur, e) } if cur
    a
  end
end

def multiply_els(arr)
  arr.my_inject(1) { |product, x| product * x }
end
